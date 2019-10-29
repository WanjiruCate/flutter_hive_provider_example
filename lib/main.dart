import 'package:flutter/material.dart';
import 'package:flutter_hive_example/models/contact.dart';
import 'package:flutter_hive_example/screens/add_contact_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_hive_example/models/contact_data.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_hive_example/screens/contacts_screen.dart';

void main() {
  Hive.registerAdapter(ContactAdapter(), 0);
  runApp(MyApp());
}

Future _initHive() async {
  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => ContactsData(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => FutureBuilder(
                future: _initHive(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.error != null) {
                      print(snapshot.error);
                      return Scaffold(
                        body: Center(
                          child: Text('Error initializing hive data store.'),
                        ),
                      );
                    } else {
                      return ContactsScreen();
                    }
                  } else {
                    return Scaffold();
                  }
                },
              ),
          '/AddContactScreen': (context) => AddContactScreen(),
        },
      ),
    );
  }
}