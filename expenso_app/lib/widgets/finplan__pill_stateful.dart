// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class FinPlanStatefulButton extends StatefulWidget {
  final String text;
  final String value;
  final ValueChanged<String> onSelectionChanged;

  const FinPlanStatefulButton({
    Key? key,
    required this.text,
    required this.value,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  _FinPlanStatefulButtonState createState() => _FinPlanStatefulButtonState();
}

class _FinPlanStatefulButtonState extends State<FinPlanStatefulButton> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isSelected = !_isSelected;
            widget.onSelectionChanged(widget.value);
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
            color: _isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            widget.text,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}