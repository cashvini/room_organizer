import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SingleRoomView extends StatelessWidget {
  const SingleRoomView({
    Key? key,
    required this.ctrlRoomNumber,
    required this.ctrlRoomName,
    required this.ctrlRoomDescription,
    required this.id,
  }) : super(key: key);

  final TextEditingController ctrlRoomNumber;
  final TextEditingController ctrlRoomName;
  final TextEditingController ctrlRoomDescription;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
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
                        'timestamp': DateTime.now().millisecondsSinceEpoch,
                      });

                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: Icon(Icons.edit),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('room')
                          .doc(id)
                          .delete();
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: Icon(Icons.delete),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
