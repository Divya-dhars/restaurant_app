import 'package:flutter/material.dart';
import 'package:restaraunt_app/CartPage.dart';
import 'package:restaraunt_app/DeliveryPage.dart';
import 'package:restaraunt_app/FoodPage.dart';
import 'package:restaraunt_app/ProfilePage.dart';
import 'package:restaraunt_app/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:restaraunt_app/register.dart';
import 'package:restaraunt_app/home.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: LoginApp.id,
      routes: {
        FoodPage.id: (context) => FoodPage(),
        LoginApp.id: (context) => LoginApp(),
        RegisterApp.id: (context) => RegisterApp(),
        HomePage.id: (context) => HomePage(),
        FoodPage.id:(context)=>FoodPage(),
        DeliveryPage.id:(context)=>DeliveryPage(),
        ProfilePage.id:(context)=>ProfilePage(),
      },
      debugShowCheckedModeBanner: false,
      home: LoginApp(),
    );
  }
}
