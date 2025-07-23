import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String? label;
  final String? hint;
  final List<T> items;
  final T? value;
  final void Function(T?)? onChanged;
  final String Function(T)? itemToString;
  final bool isExpanded;
  final double? fontSize;

  const CustomDropdown({
    Key? key,
    this.label,
    this.fontSize,
    this.hint,
    required this.items,
    this.value,
    required this.onChanged,
    this.itemToString,
    this.isExpanded = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(

      value: value,
      isExpanded: isExpanded,
      decoration: InputDecoration(

        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        helperStyle: const TextStyle(color: Colors.black),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      dropdownColor: Colors.white,
      iconEnabledColor: Colors.black,
      style:  TextStyle(color: Colors.black,fontSize:fontSize ),
      hint: Text(hint ?? '', style: const TextStyle(color: Colors.black)),
      items: items.map((T item) {
        return DropdownMenuItem<T>(

          value: item,
          child: Text(itemToString != null ? itemToString!(item) : item.toString()),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
