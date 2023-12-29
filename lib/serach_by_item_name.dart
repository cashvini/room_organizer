import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomItemsScreen extends StatefulWidget {
  @override
  _RoomItemsScreenState createState() => _RoomItemsScreenState();
}

class _RoomItemsScreenState extends State<RoomItemsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _searchController = TextEditingController();

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
              onChanged: (_) {
                setState(() {}); // Trigger a rebuild when the text changes
              },
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _firestore.collectionGroup('item').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                print(snapshot.data!.docs.first.get('description'));
                return itemList(snapshot.data!);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget itemList(QuerySnapshot snapshot) {
    List<DocumentSnapshot> _filteredItems = snapshot.docs
        .where((doc) => doc
            .get('name')
            .toLowerCase()
            .contains(_searchController.text.toLowerCase()))
        .toList();

    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: _filteredItems.map((doc) {
        return Card(
          child: ListTile(
            title: Text(doc.get('number')),
            subtitle: Text(doc.get('name')),
            trailing: SizedBox(
              width: 150,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // Handle edit action
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () {
                      // Handle search action
                    },
                    icon: const Icon(Icons.search),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
