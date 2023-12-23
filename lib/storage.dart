//import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
//import 'package:room_organizer/single_storage_view.dart';

class StorageService extends StatefulWidget {
  const StorageService({
    super.key,
    required this.room_id,
  });

  @override
  State<StorageService> createState() => _StorageServiceState();
  final String room_id;
}

class _StorageServiceState extends State<StorageService> {
  final ctrlNumber = TextEditingController();
  final ctrlName = TextEditingController();
  final ctrlDescription = TextEditingController();

  final ctrlStorageNumber = TextEditingController();
  final ctrlStorageName = TextEditingController();
  final ctrlStorageDescription = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Storage Service'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              Row(
                children: [
                  const Text("Storage Number : "),
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
                  const Text("Storage Name : "),
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
                  const Text("Storage Description : "),
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
              ElevatedButton(
                onPressed: () async {
                  if (ctrlNumber.text.isEmpty) return;
                  await addStorage();
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

  Future<DocumentReference> addStorage() {
    return FirebaseFirestore.instance
        .collection('room')
        .doc(widget.room_id)
        .collection('storage')
        .add(<String, dynamic>{
      's_description': ctrlDescription.text,
      'number': ctrlNumber.text,
      'name': ctrlName.text,
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
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              print(snapshot.data!.docs.first.get('s_description'));
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
                                onPressed: () {},
                                icon: const Icon(Icons.search)),
                            IconButton(
                                onPressed: () {}, icon: const Icon(Icons.edit)),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.delete)),
                          ],
                        ),
                      ),
                      onTap: () {
                        // ctrlStorageNumber.text = doc.get('number');
                        // ctrlStorageName.text = doc.get('name');
                        // ctrlStorageDescription.text = doc.get('description');

                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (_) => singleStorageView(
                        //         ctrlRoomNumber: ctrlStorageNumber,
                        //         ctrlRoomName: ctrlStorageName,
                        //         ctrlRoomDescription: ctrlStorageDescription,
                        //         id: doc.id),
                        //   ),
                        // );
                      },
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
