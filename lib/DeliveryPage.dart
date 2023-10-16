import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaraunt_app/FoodPage.dart';
import 'package:restaraunt_app/PaymentPage.dart';
import 'package:restaraunt_app/home.dart';
import 'package:restaraunt_app/payment_screen.dart';

class DeliveryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF5212BF6B),
        title: Text(
          'Delivery',
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder<User?>(
        future: FirebaseAuth.instance.authStateChanges().first,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            // User is not logged in.
            return Center(child: Text("User is not logged in."));
          }

          User? user = snapshot.data;

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('orders')
                .where('userEmail', isEqualTo: user!.email)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text("No orders found for this user."));
              }

              List<Widget> orderCards = [];
              for (var doc in snapshot.data!.docs) {
                var data = doc.data() as Map<String, dynamic>;
                String foodName = data['name'];
                int quantity = data['quantity'];
                double price = data['price'].toDouble(); // Convert to double

                orderCards.add(Card(
                  elevation:15.0,
                  margin: EdgeInsets.all(10.0),
                 
                  child: ListTile(
                    title: Text('Food Name: $foodName',
                    style:TextStyle(fontFamily:'Quicksand',fontWeight:FontWeight.bold)
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Quantity: $quantity',
                        style:TextStyle(fontFamily:'Quicksand',fontWeight:FontWeight.bold)
                        ),
                        Text('Price: \₹${price.toStringAsFixed(2)}',
                        style:TextStyle(fontFamily:'Quicksand',fontWeight:FontWeight.bold)
                        ), // Format the price as a string
                      ],
                    ),
                  ),
                ));
              }

              return ListView(
                children: orderCards,
              );
            },
          );
        },
      ),
    );
  }
}