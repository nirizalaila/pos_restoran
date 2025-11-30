import 'package:flutter/material.dart';

class QtyCalculatorDialog extends StatefulWidget {
  final int initialQty;

  const QtyCalculatorDialog({super.key, required this.initialQty});

  @override
  State<QtyCalculatorDialog> createState() => _QtyCalculatorDialogState();
}

class _QtyCalculatorDialogState extends State<QtyCalculatorDialog> {
  late int qty;

  @override
  void initState() {
    super.initState();
    qty = widget.initialQty;
  }

  void addDigit(String number) {
    setState(() {
      if (qty == 0) {
        qty = int.parse(number);
      } else {
        qty = int.tryParse("$qty$number") ?? qty;
      }
    });
  }

  Widget numButton(String number) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ElevatedButton(
          onPressed: () => addDigit(number),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 18),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(number, style: const TextStyle(fontSize: 24)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Edit Quantity",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // DISPLAY MIRIP ODOO
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "$qty",
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // KEYPAD
            Column(
              children: [
                Row(children: [numButton("1"), numButton("2"), numButton("3")]),
                Row(children: [numButton("4"), numButton("5"), numButton("6")]),
                Row(children: [numButton("7"), numButton("8"), numButton("9")]),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: ElevatedButton(
                          onPressed: () => setState(() => qty = 0),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("C", style: TextStyle(fontSize: 24)),
                        ),
                      ),
                    ),
                    numButton("0"),

                    // Backspace
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              final s = qty.toString();
                              qty = s.length > 1
                                  ? int.parse(s.substring(0, s.length - 1))
                                  : 0;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Icon(Icons.backspace, size: 24),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // OK BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, qty),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("OK", style: TextStyle(fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
