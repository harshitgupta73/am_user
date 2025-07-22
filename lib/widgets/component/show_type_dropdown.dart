import 'package:flutter/material.dart';

class CategorySelectorDialog extends StatefulWidget {
  final Map<String, List<String>> businessCategory;

  const CategorySelectorDialog({required this.businessCategory});

  @override
  State<CategorySelectorDialog> createState() => _CategorySelectorDialogState();
}

class _CategorySelectorDialogState extends State<CategorySelectorDialog> {
  Set<String> selectedCategories = {};
  Map<String, Set<String>> selectedSubcategories = {};

  void _openCategoryDialog() async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Select Business Categories"),
          content: StatefulBuilder(
            builder: (context, setStateDialog) {
              return Container(
                width: double.maxFinite,
                height: 400,
                child: Scrollbar(
                  child: ListView(
                    children: widget.businessCategory.entries.map((entry) {
                      final category = entry.key;
                      final subcats = entry.value;

                      return ExpansionTile(
                        title: Row(
                          children: [
                            Checkbox(
                              value: selectedCategories.contains(category),
                              onChanged: (bool? checked) {
                                setState(() {
                                  setStateDialog(() {
                                    if (checked == true) {
                                      selectedCategories.add(category);
                                      selectedSubcategories[category] =
                                          selectedSubcategories[category] ?? {};
                                    } else {
                                      selectedCategories.remove(category);
                                      selectedSubcategories.remove(category);
                                    }
                                  });
                                });
                              },
                            ),
                            Expanded(child: Text(category)),
                          ],
                        ),
                        children: subcats.map((subcat) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: CheckboxListTile(
                              title: Text(subcat),
                              value: selectedSubcategories[category]
                                  ?.contains(subcat) ??
                                  false,
                              onChanged: (bool? checked) {
                                setState(() {
                                  setStateDialog(() {
                                    if (checked == true) {
                                      selectedSubcategories[category]
                                          ?.add(subcat);
                                    } else {
                                      selectedSubcategories[category]
                                          ?.remove(subcat);
                                    }
                                  });
                                });
                              },
                            ),
                          );
                        }).toList(),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel without save
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Save and close
                setState(() {}); // Update chips UI
              },
              child: Text("Done"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Extract subcategory chips
    final selectedChips = selectedSubcategories.entries
        .expand((entry) => entry.value.map((v) => Chip(label: Text(v))))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _openCategoryDialog,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(child: Text("Select Business Categories")),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: selectedChips,
        )
      ],
    );
  }
}

