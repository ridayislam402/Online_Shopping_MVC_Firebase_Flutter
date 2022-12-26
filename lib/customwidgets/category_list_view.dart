
import 'package:flutter/material.dart';

import '../providers/product_provider.dart';
import '../utils/constants.dart';

class CategoryListView extends StatefulWidget {
  final ProductProvider provider;
  final Function(String) onSelect;

  const CategoryListView(
      {Key? key, required this.provider, required this.onSelect})
      : super(key: key);

  @override
  State<CategoryListView> createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  int? _value = 1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.provider.getCategoryFilterList().length,
        itemBuilder: (context, index) {
          final category = widget.provider.getCategoryFilterList()[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: ChoiceChip(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              selectedColor: appBarColor,
              backgroundColor: Colors.white24,
              label: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(category),
              ),
              labelStyle: TextStyle(
                color: _value == index ? Colors.white : Colors.black,
                fontSize: 20,
                fontWeight: _value == index ? FontWeight.bold : null,
              ),
              selected: _value == index,
              onSelected: (value) {
                setState(() {
                  _value = value ? index : null;
                });
                widget.onSelect(category);
              },
            ),
          );
        },
      ),
    );
  }
}
