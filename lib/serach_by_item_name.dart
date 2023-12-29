//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomItemsScreen extends StatefulWidget {
  @override
  _RoomItemsScreenState createState() => _RoomItemsScreenState();
}

class _RoomItemsScreenState extends State<RoomItemsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _searchController = TextEditingController();
  // List<Map<String, dynamic>> _searchResults = [];

  Future<void> getItemsByName(String itemName) async {
    print("in method");
    try {
      setState(() {
        // _filteredItems = snapshot.data!.docs
        //     .where((doc) =>
        //         doc.get('name').toLowerCase().contains(itemName.toLowerCase()))
        //     .toList();
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
                return ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
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
                                    // ctrlRoomNumber.text = doc.get('number');
                                    // ctrlRoomName.text = doc.get('name');
                                    // ctrlRoomDescription.text =
                                    //     doc.get('description');

                                    // Navigator.of(context).push(
                                    //   MaterialPageRoute(
                                    //     builder: (_) => SingleRoomView(
                                    //         ctrlRoomNumber: ctrlRoomNumber,
                                    //         ctrlRoomName: ctrlRoomName,
                                    //         ctrlRoomDescription:
                                    //             ctrlRoomDescription,
                                    //         id: doc.id),
                                    //   ),
                                    // );
                                  },
                                  icon: const Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () {
                                    // Navigator.of(context).push(
                                    //   MaterialPageRoute(
                                    //     builder: (_) => StorageService(
                                    //       room_id: doc.id,
                                    //     ),
                                    //   ),
                                    // );
                                  },
                                  icon: const Icon(Icons.search)),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // Widget itemList() {
  //   return FutureBuilder(
  //     future: Firebase.initializeApp(),
  //     builder: ((context, snapshot) {
  //       return Column(
  //         children: [
  //           Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: TextField(
  //               controller: _searchController,
  //               decoration: InputDecoration(labelText: 'Search by Item Name'),
  //             ),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               getItemsByName(_searchController.text);
  //             },
  //             child: Text('Search'),
  //           ),
  //           StreamBuilder<QuerySnapshot>(
  //             stream: _firestore.collectionGroup('item').snapshots(),
  //             builder: (context, snapshot) {
  //               if (snapshot.connectionState == ConnectionState.waiting) {
  //                 return const Center(
  //                   child: CircularProgressIndicator(),
  //                 );
  //               } else if (snapshot.hasError) {
  //                 return Text('Error: ${snapshot.error}');
  //               } else {
  //                 print(snapshot.data!.docs.first.get('description'));
  //                 return ListView(
  //                   children: snapshot.data!.docs.map((doc) {
  //                     return Card(
  //                       child: ListTile(
  //                         title: Text(doc.get('number')),
  //                         subtitle: Text(doc.get('name')),
  //                         trailing: SizedBox(
  //                           width: 150,
  //                           child: Row(
  //                             children: [
  //                               IconButton(
  //                                   onPressed: () {
  //                                     // ctrlRoomNumber.text = doc.get('number');
  //                                     // ctrlRoomName.text = doc.get('name');
  //                                     // ctrlRoomDescription.text =
  //                                     //     doc.get('description');

  //                                     // Navigator.of(context).push(
  //                                     //   MaterialPageRoute(
  //                                     //     builder: (_) => SingleRoomView(
  //                                     //         ctrlRoomNumber: ctrlRoomNumber,
  //                                     //         ctrlRoomName: ctrlRoomName,
  //                                     //         ctrlRoomDescription:
  //                                     //             ctrlRoomDescription,
  //                                     //         id: doc.id),
  //                                     //   ),
  //                                     // );
  //                                   },
  //                                   icon: const Icon(Icons.edit)),
  //                               IconButton(
  //                                   onPressed: () {
  //                                     // Navigator.of(context).push(
  //                                     //   MaterialPageRoute(
  //                                     //     builder: (_) => StorageService(
  //                                     //       room_id: doc.id,
  //                                     //     ),
  //                                     //   ),
  //                                     // );
  //                                   },
  //                                   icon: const Icon(Icons.search)),
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                     );
  //                   }).toList(),
  //                 );
  //               }
  //             },
  //           ),
  //         ],
  //       );
  //     }),
  //   );
  // }
}

void main() {
  runApp(MaterialApp(
    home: RoomItemsScreen(),
  ));
}
