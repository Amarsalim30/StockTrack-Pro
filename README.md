# 📦 StockTrackPro – Stock Management System

**Am'' Technologies** proudly presents **StockTrackPro**, a scalable and modular inventory management solution. Designed with clean architecture principles, this system leverages a **Flutter frontend**, **Spring Boot backend**, and **Firebase integration** to provide seamless stock control, reporting, and role-based access management.

---

## 📁 Phase 1 Documentation

| 📄 Document                                   | Description                                                              | Download                                                                                                                                                                                                   |
| --------------------------------------------- | ------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Software Requirements Specification (SRS)** | Captures all functional and non-functional system requirements           | [📥 Download](https://github.com/Amarsalim30/StockTrack-Pro/raw/refs/heads/dev/docs/2.Software%20Requirements%20Specification.docx)      |
| **Requirements Traceability Matrix (RTM)**    | Maps requirements to design, test coverage, and current status           | [📥 Download](https://github.com/Amarsalim30/StockTrack-Pro/raw/refs/heads/dev/docs/rtm_stocktrackpro.docx)                                                                   |

---

## 🚀 Project Roadmap

### 🗓️ Phase 1 Timeline

```mermaid
gantt
    title StockTrackPro – Phase 1 Roadmap
    dateFormat  YYYY-MM-DD
    section 📑 Documentation
    Charter & Stakeholders       :done,    charter,    2025-07-29, 3d
    SRS, BRD & RTM               :done,    docs,       2025-08-1, 4d
    section 🛠️ Development
    Sprint 1 – Frontend MVP      :active,  s1,         2025-08-4, 7d
    Sprint 2 – Backend + Firebase:         s2,         2025-08-11, 14d
    Sprint 3 – Reporting + QA    :         s3,         2025-08-24, 7d
    section 🚀 Release
    Release v1.0                 :         release,    2025-08-26, 1d
```

---

## 📌 Sprint 1 Snapshot

```text
Sprint 1 – Frontend MVP
├─ ✅ FR-001: Product Creation (In Progress)
├─ 🟡 FR-002: Product Editing (Ready)
├─ 🧪 FR-004: RBAC Implementation (Testing)
└─ ✅ FR-008: Supplier Management (Complete)
```

---

### 🛠 Tech Stack

* **Frontend:** Flutter (MVVM, Clean Architecture)
* **Backend:** Spring Boot (RESTful APIs)
* **Database:** Firebase Firestore
* **Authentication:** Firebase Auth
* **DevOps:** GitHub Projects (Agile Iterative Board)
* **CI/CD:** GitHub Actions

---

```mermaid
---
config:
  layout: dagre
---
flowchart TD

  A["App Start"] --> B{"Token Exists?"}
  B -- Yes --> C["Load Current User"]
  B -- No --> F["Redirect to Login"]

  C --> D{"Token Valid?"}
  D -- Yes --> E["Show Dashboard"]
  D -- No --> TR["Attempt Token Refresh"]
  TR -- Success --> E
  TR -- Failure --> F

  F --> L["LoginViewModel"]
  L --> P["Validate Credentials"]
  P --> MFA{"MFA Required?"}
  MFA -- Yes --> M1["OTP Verification"]
  MFA -- No --> C

  E --> INV["Inventory Module"]
  INV --> IV1["Load Stocks"] --> IV2{"Can Edit/Delete?"}
  IV2 -- Yes --> IV3["Full UI"]
  IV2 -- No --> IV4["Read-Only UI"]

  E --> SETTINGS["Settings Module"] --> S1["Change Password"]
  E --> SALES["Sales Module"] --> SA1["View Orders"]
  E --> REPORTS["Reports Module"] --> R1["Stock Analytics"]

  C --> ERR{"Token Expired?"} -->|Yes| TR
  ANY_ERROR --> CRASH["Log to Crashlytics"]
```

---

> Built with ❤️ by **Am'' Technologies** — *Clarity Engineered™*

---

"# StockTrack-Pro" 
