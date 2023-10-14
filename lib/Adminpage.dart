import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  static String id = "admin_screen";
  @override
  _AdminPageState createState() => _AdminPageState();
}


class _AdminPageState extends State<AdminPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
      ),
      /*body: ListView.builder(
        itemCount: userList.length,
        itemBuilder: (context, index) {
          final user = userList[index];
          return ListTile(
            title: Text(user.email),
            subtitle: Text(user.password),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Code to add a new user
          // You can use a dialog or navigate to a new page to add user details
        },
        child: Icon(Icons.add),
      ),*/
    );
  }
}
