//import 'dart:js';

//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:room_organizer/single_item_view.dart';
//import 'package:room_organizer/single_storage_view.dart';

class ItemService extends StatefulWidget {
  const ItemService(
      {super.key, required this.room_id, required this.storage_id});

  @override
  State<ItemService> createState() => _ItemServiceState();
  final String room_id;
  final String storage_id;
}

class _ItemServiceState extends State<ItemService> {
  final ctrlNumber = TextEditingController();
  final ctrlName = TextEditingController();
  final ctrlDescription = TextEditingController();
  final ctrlSize = TextEditingController();
  final ctrlQuantity = TextEditingController();

  final ctrlItemNumber = TextEditingController();
  final ctrlItemName = TextEditingController();
  final ctrlItemDescription = TextEditingController();
  final ctrlItemSize = TextEditingController();
  final ctrlItemQuantity = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Service'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              Row(
                children: [
                  const Text("Item Number : "),
                  Expanded(
                    child: TextField(
                      controller: ctrlNumber,
                      autocorrect: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 3,
              ),
              Row(
                children: [
                  const Text("Item Name : "),
                  Expanded(
                    child: TextField(
                      controller: ctrlName,
                      autocorrect: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 3,
              ),
              Row(
                children: [
                  const Text("Item Description : "),
                  Expanded(
                    child: TextField(
                      controller: ctrlDescription,
                      autocorrect: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 3,
              ),
              Row(
                children: [
                  const Text("Item Size : "),
                  Expanded(
                    child: TextField(
                      controller: ctrlSize,
                      autocorrect: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 3,
              ),
              Row(
                children: [
                  const Text("Item Quantity : "),
                  Expanded(
                    child: TextField(
                      controller: ctrlQuantity,
                      autocorrect: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 3,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (ctrlNumber.text.isEmpty) return;
                  await addItem();
                  ctrlDescription.clear();
                  ctrlName.clear();
                  ctrlNumber.clear();
                },
                child: const Icon(Icons.add),
              ),
              Expanded(
                child: storageList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<DocumentReference> addItem() {
    return FirebaseFirestore.instance
        .collection('room')
        .doc(widget.room_id)
        .collection('storage')
        .doc(widget.storage_id)
        .collection('item')
        .add(<String, dynamic>{
      'description': ctrlDescription.text,
      'number': ctrlNumber.text,
      'name': ctrlName.text,
      'size': ctrlSize.text,
      'quantity': ctrlQuantity.text,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Widget storageList() {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: ((context, snapshot) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('room')
              .doc(widget.room_id)
              .collection('storage')
              .doc(widget.storage_id)
              .collection('item')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Text('No Data');
            } else {
              print(snapshot.data!.docs.first.get('description'));
              return ListView(
                children: snapshot.data!.docs.map((doc) {
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
                                  ctrlItemNumber.text = doc.get('number');
                                  ctrlItemName.text = doc.get('name');
                                  ctrlItemDescription.text =
                                      doc.get('description');
                                  ctrlItemSize.text = doc.get('size');
                                  ctrlItemQuantity.text = doc.get('quantity');

                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => singleItemView(
                                          ctrlItemNumber: ctrlItemNumber,
                                          ctrlItemName: ctrlItemName,
                                          ctrlItemDescription:
                                              ctrlItemDescription,
                                          ctrlItemSize: ctrlItemSize,
                                          ctrlItemQuantity: ctrlItemQuantity,
                                          storage_id: widget.storage_id,
                                          room_id: widget.room_id,
                                          item_id: doc.id),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.edit)),
                          ],
                        ),
                      ),
                      onTap: () {},
                    ),
                  );
                }).toList(),
              );
            }
          },
        );
      }),
    );
  }
}
