

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DropdownSearchUpdate extends StatelessWidget {
  DropdownSearchUpdate({super.key, required this.itemes, this.onChage, this.validators, this.selectedItems, this.textDropdownPorps, this.hintTextProps});

  final List<String> itemes;
  final void Function(String?)? onChage;
  final String? Function(String?)? validators;
  final String? selectedItems;
  final String? textDropdownPorps;
  final String? hintTextProps;
  
  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      items: itemes,
      popupProps: PopupProps.menu(
        showSearchBox: true,
        showSelectedItems: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: hintTextProps,
          )
        ),
        loadingBuilder: (context, searchEntry) => LinearProgressIndicator(),
      ),
      onChanged: onChage,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: textDropdownPorps,
        )
      ),
      validator: validators,
      selectedItem: selectedItems,
    );
  }
}