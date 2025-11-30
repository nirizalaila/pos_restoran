import 'package:flutter/material.dart';

class CalculatorPad extends StatefulWidget {
  final int initialValue;
  final Function(int) onSubmit;

  const CalculatorPad({
    super.key,
    required this.initialValue,
    required this.onSubmit,
  });

  @override
  State<CalculatorPad> createState() => _CalculatorPadState();
}

class _CalculatorPadState extends State<CalculatorPad> {
  late String value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue.toString();
  }

  void input(String v) {
    setState(() => value += v);
  }

  void clear() => setState(() => value = "");

  void backspace() {
    if (value.isEmpty) return;
    setState(() => value = value.substring(0, value.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Display
        Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          alignment: Alignment.centerRight,
          child: Text(
            value.isEmpty ? "0" : value,
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
        ),

        Expanded(
          child: GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.2,
            padding: const EdgeInsets.all(12),
            children: [
              calcButton("1"), calcButton("2"), calcButton("3"),
              calcButton("4"), calcButton("5"), calcButton("6"),
              calcButton("7"), calcButton("8"), calcButton("9"),

              controlButton("C", clear, Colors.orange),
              calcButton("0"),
              controlButton("⌫", backspace, Colors.orange),
            ],
          ),
        ),

        SizedBox(
          height: 56,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              widget.onSubmit(int.tryParse(value) ?? 0);
              Navigator.pop(context);
            },
            child: const Text(
              "OK",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget calcButton(String text) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () => input(text),
      child: Text(text, style: const TextStyle(fontSize: 24)),
    );
  }

  Widget controlButton(String text, VoidCallback onTap, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: onTap,
      child: Text(text, style: const TextStyle(fontSize: 24)),
    );
  }
}
