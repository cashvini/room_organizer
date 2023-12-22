import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SearchService extends StatefulWidget {
  const SearchService({super.key});

  @override
  State<SearchService> createState() => _SearchState();
}

List<String> rooms = <String>["1", "2", "3"];
List<String> items = <String>["bag", "keys", "MRT card"];
List<String> storage = <String>["green box", "locker", "cupboard"];
String roomsdropdownValue = rooms.first;
String itemsdropdownValue = items.first;
String storagedropdownValue = storage.first;

class _SearchState extends State<SearchService> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DropdownMenu(
          initialSelection: roomsdropdownValue,
          dropdownMenuEntries:
              rooms.map<DropdownMenuEntry<String>>((String value) {
            return DropdownMenuEntry<String>(value: value, label: value);
          }).toList(),
          onSelected: (value) {
            setState(() {
              roomsdropdownValue = value!;
            });
          },
        ),

        //storage
        DropdownMenu(
          initialSelection: storagedropdownValue,
          dropdownMenuEntries:
              storage.map<DropdownMenuEntry<String>>((String value) {
            return DropdownMenuEntry<String>(value: value, label: value);
          }).toList(),
          onSelected: (value) {
            setState(() {
              roomsdropdownValue = value!;
            });
          },
        ),

        // items
        DropdownMenu(
          initialSelection: itemsdropdownValue,
          dropdownMenuEntries:
              items.map<DropdownMenuEntry<String>>((String value) {
            return DropdownMenuEntry<String>(value: value, label: value);
          }).toList(),
          onSelected: (value) {
            setState(() {
              itemsdropdownValue = value!;
            });
          },
        ),
      ],
    );
  }
}
