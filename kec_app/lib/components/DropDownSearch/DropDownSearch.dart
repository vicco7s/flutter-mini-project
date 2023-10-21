import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DropdownButtonSearch extends StatelessWidget {
  DropdownButtonSearch(
      {super.key,
      required this.itemes,
      this.onChage,
      this.validators,
      this.selectedItems,
      this.loadingBuilders,
      this.textDropdownPorps,
      this.hintTextProps});

  final List<String> itemes;
  final void Function(String?)? onChage;
  final String? Function(String?)? validators;
  final String? selectedItems;
  final String? textDropdownPorps;
  final String? hintTextProps;
  final Widget Function(BuildContext, String)? loadingBuilders;
  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      popupProps: PopupProps.menu(
        showSelectedItems: true,
        loadingBuilder: loadingBuilders,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            hintText: hintTextProps,
            filled: true,
            hintStyle: TextStyle(color: Colors.grey[500]),
            // hintText: "Masukan Email",
            fillColor: Colors.white70,
          ),
        ),
        showSearchBox: true,
        // disabledItemFn: (String s) => s.startsWith('I'),
      ),
      items: itemes,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[500]),
          // hintText: "Masukan Email",
          fillColor: Colors.white70,
          labelText: textDropdownPorps,
        ),
      ),
      onChanged: onChage,
      validator: validators,
      selectedItem: selectedItems,
      // selectedItem: _selectedValue,
    );
  }
}
