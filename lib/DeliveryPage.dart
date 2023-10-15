import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaraunt_app/FoodPage.dart';
import 'package:restaraunt_app/PaymentPage.dart';
import 'package:restaraunt_app/home.dart';

class DeliveryPage extends StatelessWidget {
  final List<FoodItem> foodList;
  final double totOrderPrice;
  DeliveryPage({required this.foodList, required this.totOrderPrice});

  Future<void> addOrderedFoodItemsToFirebase(List<FoodItem> foodList) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    if (user == null) {
      // Handle the case where the user is not signed in.
      return;
    }

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference orderCollection = firestore.collection('orders');
    final CollectionReference userProfileCollection =
        firestore.collection('user_profiles');

    // Fetch the user's data from the 'user_profiles' collection
    final userDoc = await userProfileCollection.doc(user.email).get();
    if (!userDoc.exists) {
      // Handle the case where user data is not found.
      return;
    }

    final userData = userDoc.data() as Map<String, dynamic>;
    final String username = userData['name'];
    final String mobileNumber = userData['phone'];
    final String address = userData['address'];

    for (FoodItem foodItem in foodList) {
      if (foodItem.quantity > 0) {
        await orderCollection.add({
          'name': foodItem.name,
          'quantity': foodItem.quantity,
          'price': foodItem.price,
          'username': username,
          'mobileNumber': mobileNumber,
          'address': address,
        });
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
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
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: foodList.length,
              itemBuilder: (context, index) {
                final foodItem = foodList[index];
                if (foodItem.quantity > 0) {
                  return Card(
                    elevation: 10.0,
                    margin: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: ListTile(
                      leading: Image.asset(foodItem.imagePath),
                      title: Text(
                        foodItem.name,
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Quantity: ${foodItem.quantity}',
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Text(
                        '₹${(foodItem.price * foodItem.quantity).toStringAsFixed(2)}',
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container(); // If quantity is 0, don't show in the cart
                }
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              addOrderedFoodItemsToFirebase(foodList);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Your order has been placed successfully!',
                  style:TextStyle(fontFamily:'Quicksand',fontWeight:FontWeight.w900),
                  
                  ),
                ),
              );
            },
            child: Text('Place Order',
            style:TextStyle(
              fontFamily:'Quicksand',
              fontWeight: FontWeight.bold,
              color:Colors.black,
            )
            ),
            style:ElevatedButton.styleFrom(
              primary:Color(0xFF5212BF6B),
            )
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 18.0),
            child: Card(
              elevation: 20.0,
              margin: EdgeInsets.all(10.0),
              color: Color(0xFF5212BF6B),
              child: ListTile(
                title: Center(
                child:Text(
                  'Delivery within 35-40 mins',
                  style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w900),
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }
}
