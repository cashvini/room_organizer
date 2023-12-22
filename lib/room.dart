//import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
                                onPressed: () {},
                                icon: const Icon(Icons.search)),
                            IconButton(
                                onPressed: () {
                                  //       showDialog(
                                  // builder: (context) => AlertDialog(
                                  //       title: Text("Hi"),
                                  //       content: RoomEdit(ctrlRoomNumber: ctrlRoomNumber, ctrlRoomName: ctrlRoomName, ctrlRoomDescription: ctrlRoomDescription),
                                  //     ),
                                  // context: context);
                                },
                                icon: const Icon(Icons.edit)),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.delete)),
                          ],
                        ),
                      ),
                      onTap: () {
                        ctrlRoomNumber.text = doc.get('number');
                        ctrlRoomName.text = doc.get('name');
                        ctrlRoomDescription.text = doc.get('description');
                        // showDialog(
                        //     builder: (context) => AlertDialog(
                        //           title: Text("Hi"),
                        //           content: singleRoomView(ctrlRoomNumber: ctrlRoomNumber, ctrlRoomName: ctrlRoomName, ctrlRoomDescription: ctrlRoomDescription),
                        //         ),
                        //     context: context);

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => singleRoomView(
                                ctrlRoomNumber: ctrlRoomNumber,
                                ctrlRoomName: ctrlRoomName,
                                ctrlRoomDescription: ctrlRoomDescription,
                                id: doc.id)));
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

class singleRoomView extends StatelessWidget {
  const singleRoomView({
    super.key,
    required this.ctrlRoomNumber,
    required this.ctrlRoomName,
    required this.ctrlRoomDescription,
    required this.id,
  });

  final TextEditingController ctrlRoomNumber;
  final TextEditingController ctrlRoomName;
  final TextEditingController ctrlRoomDescription;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: ctrlRoomNumber,
            ),
            TextField(
              controller: ctrlRoomName,
            ),
            TextField(
              controller: ctrlRoomDescription,
            ),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('room')
                          .doc(id)
                          .update({
                        'description': ctrlRoomDescription.text,
                        'number': ctrlRoomNumber.text,
                        'name': ctrlRoomName.text,
                        'timestamp': DateTime.now().millisecondsSinceEpoch
                      });

                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: Icon(Icons.edit)),
                ElevatedButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('room')
                          .doc(id)
                          .delete();
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: Icon(Icons.delete)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class RoomData extends StatefulWidget {
  const RoomData({super.key});

  @override
  State<RoomData> createState() => _RoomDataState();
}

class _RoomDataState extends State<RoomData> {
  @override
  Widget build(BuildContext context) {
    return const Text("Hi");
  }
}
