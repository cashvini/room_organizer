import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class singleStorageView extends StatelessWidget {
  const singleStorageView(
      {Key? key,
      required this.storage_id,
      required this.room_id,
      required this.ctrlStorageNumber,
      required this.ctrlStorageName,
      required this.ctrlStorageDescription})
      : super(key: key);

  final TextEditingController ctrlStorageNumber;
  final TextEditingController ctrlStorageName;
  final TextEditingController ctrlStorageDescription;
  final String storage_id;
  final String room_id;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: ctrlStorageNumber,
              ),
              TextField(
                controller: ctrlStorageName,
              ),
              TextField(
                controller: ctrlStorageDescription,
              ),
              Row(
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('room')
                            .doc(room_id)
                            .collection('storage')
                            .doc(storage_id)
                            .update({
                          's_description': ctrlStorageDescription.text,
                          'number': ctrlStorageNumber.text,
                          'name': ctrlStorageName.text
                          //'timestamp': DateTime.now().millisecondsSinceEpoch
                        });

                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: Icon(Icons.edit)),
                  ElevatedButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('room')
                            .doc(room_id)
                            .collection('storage')
                            .doc(storage_id)
                            .delete();
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: Icon(Icons.delete)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
