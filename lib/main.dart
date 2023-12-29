import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:room_organizer/room.dart';
import 'package:room_organizer/serach_by_item_name.dart';

import 'firebase_options.dart';
//import 'package:room_organizer/search.dart';

Future<void> main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

// List<String> rooms = <String>["1", "2", "3"];
// List<String> items = <String>["bag", "keys", "MRT card"];
// List<String> storage = <String>["green box", "locker", "cupboard"];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //int _counter = 0;
  ColorScheme a = ColorScheme.fromSeed(seedColor: Colors.deepPurple);

  void _incrementCounter() {
    setState(() {
      Random random = new Random();

      a = ColorScheme.fromSeed(
          seedColor: Color.fromARGB(random.nextInt(255), random.nextInt(255),
              random.nextInt(255), random.nextInt(255)));
    });
  }

  // String roomsdropdownValue = rooms.first;
  // String itemsdropdownValue = items.first;
  // String storagedropdownValue = storage.first;
  var currentPageIndex = 1;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (currentPageIndex) {
      case 0:
        page = const RoomService();
        break;
      case 1:
        page = const Placeholder();
        break;
      case 2:
        page = RoomItemsScreen();
        break;
      default:
        throw UnimplementedError('no widget for $currentPageIndex');
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: a.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BottomNavigationBar(
              // destinations: const [
              //   NavigationDestination(
              //     icon: Icon(Icons.production_quantity_limits),
              //     label: 'Room',
              //   ),
              //   NavigationDestination(
              //     icon: Icon(Icons.storage),
              //     label: 'Storage',
              //   ),
              //   NavigationDestination(
              //     icon: Icon(Icons.list),
              //     label: 'Item',
              //   ),
              // ],
              type: BottomNavigationBarType.fixed,
              currentIndex: currentPageIndex,
              selectedItemColor: Colors.amber,
              onTap: (value) {
                setState(() {
                  currentPageIndex = value;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.production_quantity_limits),
                  label: 'Room',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.storage),
                  label: 'Storage',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  label: 'Item',
                ),
              ],
            ),

            Expanded(
                child: Container(
              child: page,
            ))

            //rooms
            // DropdownMenu(
            //   initialSelection: roomsdropdownValue,
            //   dropdownMenuEntries:
            //       rooms.map<DropdownMenuEntry<String>>((String value) {
            //     return DropdownMenuEntry<String>(value: value, label: value);
            //   }).toList(),
            //   onSelected: (value) {
            //     setState(() {
            //       roomsdropdownValue = value!;
            //     });
            //   },
            // ),

            // //storage
            // DropdownMenu(
            //   initialSelection: storagedropdownValue,
            //   dropdownMenuEntries:
            //       storage.map<DropdownMenuEntry<String>>((String value) {
            //     return DropdownMenuEntry<String>(value: value, label: value);
            //   }).toList(),
            //   onSelected: (value) {
            //     setState(() {
            //       roomsdropdownValue = value!;
            //     });
            //   },
            // ),

            // // items
            // DropdownMenu(
            //   initialSelection: itemsdropdownValue,
            //   dropdownMenuEntries:
            //       items.map<DropdownMenuEntry<String>>((String value) {
            //     return DropdownMenuEntry<String>(value: value, label: value);
            //   }).toList(),
            //   onSelected: (value) {
            //     setState(() {
            //       itemsdropdownValue = value!;
            //     });
            //   },
            // ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.search),
        backgroundColor: a.inversePrimary,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
