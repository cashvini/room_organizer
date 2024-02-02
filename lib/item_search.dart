import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomItemsScreen extends StatefulWidget {
  @override
  _RoomItemsScreenState createState() => _RoomItemsScreenState();
}

class _RoomItemsScreenState extends State<RoomItemsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  Future<void> getItemsByName(String itemName) async {
    try {
      QuerySnapshot itemsSnapshot = await _firestore
          .collectionGroup('items')
          .where('itemName', isEqualTo: itemName)
          .get();

      List<Map<String, dynamic>> results = [];

      itemsSnapshot.docs.forEach((itemDoc) {
        var itemData = itemDoc.data() as Map<String, dynamic>;
        results.add({'id': itemDoc.id, 'data': itemData});
      });

      setState(() {
        _searchResults = results;
      });
    } catch (error) {
      print('Error retrieving data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room Items'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(labelText: 'Search by Item Name'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              getItemsByName(_searchController.text);
            },
            child: Text('Search'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                var item = _searchResults[index];
                return ListTile(
                  title: Text('Item ID: ${item['id']}'),
                  subtitle: Text('Data: ${item['data']}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: RoomItemsScreen(),
  ));
}
