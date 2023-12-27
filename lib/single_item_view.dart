import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class singleItemView extends StatelessWidget {
  const singleItemView(
      {Key? key,
      required this.storage_id,
      required this.room_id,
      required this.item_id,
      required this.ctrlItemNumber,
      required this.ctrlItemName,
      required this.ctrlItemDescription,
      required this.ctrlItemSize,
      required this.ctrlItemQuantity})
      : super(key: key);

  final TextEditingController ctrlItemNumber;
  final TextEditingController ctrlItemName;
  final TextEditingController ctrlItemDescription;
  final TextEditingController ctrlItemSize;
  final TextEditingController ctrlItemQuantity;
  final String storage_id;
  final String room_id;
  final String item_id;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        body: Column(
          children: [
            AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: ctrlItemNumber,
                  ),
                  TextField(
                    controller: ctrlItemName,
                  ),
                  TextField(
                    controller: ctrlItemDescription,
                  ),
                  TextField(
                    controller: ctrlItemSize,
                  ),
                  TextField(
                    controller: ctrlItemQuantity,
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
                                .collection('item')
                                .doc(item_id)
                                .update({
                              'description': ctrlItemNumber.text,
                              'number': ctrlItemName.text,
                              'name': ctrlItemDescription.text,
                              'size': ctrlItemSize.text,
                              'quantity': ctrlItemQuantity.text
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
                                .collection('item')
                                .doc(item_id)
                                .delete();
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          child: Icon(Icons.delete)),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
