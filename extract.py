import os
import re
import json
import csv

ENTITY_FOLDER = r"lib/data/models"  # root lib folder

OUTPUT_TXT = os.path.join(ENTITY_FOLDER, "model_attributes.txt")
OUTPUT_CSV = os.path.join(ENTITY_FOLDER, "model_attributes.csv")
OUTPUT_JSON = os.path.join(ENTITY_FOLDER, "model_attributes.json")

# === Patterns (robust, handles nesting better) ===
field_regex = re.compile(r'\s*(?:final|var|late)?\s*([\w<>?]+)\s+(\w+)\s*(?:=.*)?;')
enum_pattern = re.compile(r'enum\s+(\w+)\s*{([^}]*)}', re.DOTALL)

def extract_classes(content):
    models = []
    tokens = re.finditer(r'class\s+(\w+)[^{]*{', content)
    for match in tokens:
        start = match.end()
        class_name = match.group(1)
        brace_count = 1
        end = start
        while end < len(content) and brace_count > 0:
            if content[end] == '{':
                brace_count += 1
            elif content[end] == '}':
                brace_count -= 1
            end += 1
        class_body = content[start:end - 1]
        fields = field_regex.findall(class_body)
        models.append({
            "type": "class",
            "name": class_name,
            "fields": [{"name": name, "type": ftype} for ftype, name in fields]
        })
    return models

def extract_enums(content):
    enums = []
    for match in enum_pattern.finditer(content):
        name = match.group(1)
        values_raw = match.group(2)
        values = [v.strip().strip(',') for v in values_raw.splitlines() if v.strip()]
        enums.append({"type": "enum", "name": name, "values": values})
    return enums

def scan_dart_files(folder):
    all_models = []
    for root, _, files in os.walk(folder):
        for file in files:
            if file.endswith(".dart"):
                with open(os.path.join(root, file), "r", encoding="utf-8") as f:
                    content = f.read()
                    all_models.extend(extract_classes(content))
                    all_models.extend(extract_enums(content))
    return all_models

# === Run ===
models = scan_dart_files(ENTITY_FOLDER)

# === TXT ===
with open(OUTPUT_TXT, "w", encoding="utf-8") as f:
    for m in models:
        if m["type"] == "class":
            f.write(f"Model: {m['name']}\n")
            for field in m["fields"]:
                f.write(f"- {field['name']}: {field['type']}\n")
        elif m["type"] == "enum":
            f.write(f"Enum: {m['name']}\n")
            for v in m["values"]:
                f.write(f"- {v}\n")
        f.write("\n")

# === CSV ===
with open(OUTPUT_CSV, "w", newline="", encoding="utf-8") as f:
    writer = csv.writer(f)
    writer.writerow(["Type", "Name", "Field/Value", "Data Type"])
    for m in models:
        if m["type"] == "class":
            for field in m["fields"]:
                writer.writerow(["class", m["name"], field["name"], field["type"]])
        elif m["type"] == "enum":
            for v in m["values"]:
                writer.writerow(["enum", m["name"], v, "enum value"])

# === JSON ===
with open(OUTPUT_JSON, "w", encoding="utf-8") as f:
    json.dump(models, f, indent=2)

print(f"✅ Extracted {len(models)} models/enums from {ENTITY_FOLDER}")
print(f"- {OUTPUT_TXT}\n- {OUTPUT_CSV}\n- {OUTPUT_JSON}")
