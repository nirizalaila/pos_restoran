import 'package:flutter/material.dart';

class QtyCalculatorDialog extends StatefulWidget {
  final int initialQty;

  const QtyCalculatorDialog({super.key, required this.initialQty});

  @override
  State<QtyCalculatorDialog> createState() => _QtyCalculatorDialogState();
}

class _QtyCalculatorDialogState extends State<QtyCalculatorDialog> {
  String value = "";

  @override
  void initState() {
    super.initState();
    value = widget.initialQty.toString();
  }

  void input(String v) {
    setState(() {
      if (v == "C") {
        value = "";
      } else {
        value += v;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF334B76),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: const Text(
              "Ubah Jumlah",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            value.isEmpty ? "0" : value,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                ...["1","2","3","4","5","6","7","8","9"]
                    .map((e) => calcButton(e)),
                calcButton("C", color: Colors.red.shade500),
                calcButton("0"),
                confirmButton(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget calcButton(String label, {Color? color}) {
    return InkWell(
      onTap: () => input(label),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: color ?? Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color != null ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget confirmButton() {
    return InkWell(
      onTap: () {
        final qty = int.tryParse(value);
        Navigator.pop(context, qty ?? 0);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF334B76),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.check, color: Colors.white, size: 28),
      ),
    );
  }
}
