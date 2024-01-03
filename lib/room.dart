//import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:room_organizer/single_room_view.dart';
import 'package:room_organizer/storage.dart';

class RoomService extends StatefulWidget {
  const RoomService({super.key});

  @override
  State<RoomService> createState() => _RoomServiceState();
}

class _RoomServiceState extends State<RoomService> {
  final ctrlNumber = TextEditingController();
  final ctrlName = TextEditingController();
  final ctrlDescription = TextEditingController();

  var ctrlRoomNumber = TextEditingController();
  final ctrlRoomName = TextEditingController();
  final ctrlRoomDescription = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          children: [
            Row(
              children: [
                const Text("Room Number : "),
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
                const Text("Room Name : "),
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
                const Text("Room Description : "),
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
                addRoom();
                ctrlDescription.clear();
                ctrlName.clear();
                ctrlNumber.clear();
              },
              child: const Icon(Icons.add),
            ),
            Expanded(child: roomList())
          ],
        ),
      ),
    );
  }

  Future<DocumentReference> addRoom() {
    return FirebaseFirestore.instance.collection('room').add(<String, dynamic>{
      'description': ctrlDescription.text,
      'number': ctrlNumber.text,
      'name': ctrlName.text,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Widget roomList() {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: ((context, snapshot) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('room').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
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
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                ctrlRoomNumber.text = doc.get('number');
                                ctrlRoomName.text = doc.get('name');
                                ctrlRoomDescription.text =
                                    doc.get('description');

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => SingleRoomView(
                                        ctrlRoomNumber: ctrlRoomNumber,
                                        ctrlRoomName: ctrlRoomName,
                                        ctrlRoomDescription:
                                            ctrlRoomDescription,
                                        id: doc.id),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => StorageService(
                                      room_id: doc.id,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
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
