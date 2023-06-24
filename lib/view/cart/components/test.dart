import 'package:flutter/material.dart';

class ProductCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const ProductCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  _ProductCheckboxState createState() => _ProductCheckboxState();
}

class _ProductCheckboxState extends State<ProductCheckbox> {
  bool _value = false;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didUpdateWidget(covariant ProductCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    _value = widget.value;
  }

  void _handleChanged(bool? newValue) {
    setState(() {
      _value = newValue!;
    });
    widget.onChanged?.call(newValue!);
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: _value,
      onChanged: _handleChanged,
    );
  }
}
