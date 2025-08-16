import 'package:flutter/material.dart';

class InvoicePage extends StatelessWidget {
  const InvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Card 1: Invoice Info
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with curved stripe
                      Stack(
                        children: [
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: ClipPath(
                                clipper: CurvedRightClipper(),
                                child: Container(
                                  width: 70,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.blue.shade700,
                                        Colors.blue.shade400
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("OS-2024-001",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                    )),
                                const SizedBox(height: 4),
                                Text("Office Supplies Co. • 2024-01-16",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade600)),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    _statusBadge(
                                        "Pending Approval",
                                        Colors.orange.shade100,
                                        Colors.orange.shade800),
                                    const SizedBox(width: 8),
                                    _priceBadge("\$1275.00"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Match Status
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _matchItem(
                                "PO Match", Colors.green, Icons.check_circle),
                            _matchItem(
                                "GR Match", Colors.green, Icons.check_circle),
                            _matchItem("Price Match", Colors.amber,
                                Icons.error_outline),
                          ],
                        ),
                      ),
                      const Divider(),

                      // Discrepancies
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.warning_amber_rounded,
                                    color: Colors.orange, size: 20),
                                SizedBox(width: 6),
                                Text("Discrepancies Found",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            _discrepancyItem(
                                "Price variance: \$25.00 over PO amount"),
                            _discrepancyItem(
                                "Unit price difference on Desk Organizer: \$2.50 higher than PO"),
                          ],
                        ),
                      ),

                      //items
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Line Items' ,style: TextStyle(fontWeight: FontWeight.bold),),
                      ),
                      SizedBox(
                        child: Scrollbar(
                          radius: const Radius.circular(12),
                          thickness: 8,
                          thumbVisibility: true,
                          trackVisibility: true,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              headingRowHeight: 36,
                              dataRowMinHeight: 44,
                              horizontalMargin: 12,
                              columnSpacing: 28,
                              border: TableBorder.all(
                                color: Colors.grey.shade300,
                                width: 0.6,
                              ),
                              headingTextStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              columns: const [
                                DataColumn(label: Text('Item')),
                                DataColumn(label: Text('Ordered')),
                                DataColumn(label: Text('Received')),
                                DataColumn(label: Text('Remaining')),
                                DataColumn(label: Text('Status')),
                              ],
                              rows: [
                                _goodsReceiptRow("Office Paper A4", 50, 50, 0, "Complete"),
                                _goodsReceiptRow("Ballpoint Pens (Pack of 10)", 25, 25, 0, "Complete"),
                                _goodsReceiptRow("Desk Organizer", 10, 10, 0, "Complete"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Card 2: Payment Details
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: const [
                        _DetailItem(label: "Total Invoice", value: "Ksh 4204"),
                        _DetailItem(label: "Total Paid", value: "Ksh 0"),
                        _DetailItem(label: "Balance Due", value: "Ksh 4204"),
                        SizedBox(height: 6),
                        Text("Payment Status",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                        SizedBox(height: 2),
                        Text("0 of 1 Paid",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DataRow _goodsReceiptRow(
      String item, int ordered, int received, int remaining, String status) {
    return DataRow(
      cells: [
        DataCell(Text(item)),
        DataCell(Text(ordered.toString())),
        DataCell(Text(received.toString())),
        DataCell(Text(remaining.toString())),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }


  static Widget _statusBadge(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration:
      BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(text,
          style: TextStyle(
              color: fg, fontSize: 12, fontWeight: FontWeight.w500)),
    );
  }

  static Widget _priceBadge(String price) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(price,
          style: const TextStyle(
              color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }

  static Widget _matchItem(String label, Color color, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(color: Colors.grey.shade800, fontSize: 13)),
      ],
    );
  }

  static Widget _discrepancyItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 26, top: 2),
      child: Text(text,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;

  const _DetailItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.black54)),
          Text(value,
              style:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}

class CurvedRightClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width * 0.3, 0);
    path.quadraticBezierTo(size.width * 0.15, size.height * 0.5,
        size.width * 0.3, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
