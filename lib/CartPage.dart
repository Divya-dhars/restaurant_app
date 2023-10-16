import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaraunt_app/FoodPage.dart';
import 'package:restaraunt_app/PaymentPage.dart';

class CartPage extends StatelessWidget {
  final List<FoodItem> foodList;
  final double totOrderPrice;
  CartPage({required this.foodList, required this.totOrderPrice});
  late User? user;
  Future<void> addOrderedFoodItemsToFirebase(List<FoodItem> foodList) async {
  user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return;
  }
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference orderCollection = firestore.collection('orders');
  final CollectionReference userProfileCollection = firestore.collection('user_profiles');
  final userDoc = await userProfileCollection.doc(user!.email).get();
  if (!userDoc.exists) {
    return;
  }
  final userData = userDoc.data() as Map<String, dynamic>;
  final String username = userData['name'];
  final String mobileNumber = userData['phoneNumber'];
  final String address = userData['address'];

  for (FoodItem foodItem in foodList) {
    if (foodItem.quantity > 0) {
      await orderCollection.add({
        'userEmail': user!.email,
        'username': username,
        'mobileNumber': mobileNumber,
        'address': address,
        'name': foodItem.name,
        'quantity': foodItem.quantity,
        'price': foodItem.quantity*foodItem.price,
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
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF5212BF6B),
        title: Text('Cart',
            style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w900,
                color: Colors.black)),
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
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: ListTile(
                      leading: Image.asset(foodItem.imagePath),
                      title: Text(foodItem.name,
                          style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.bold)),
                      subtitle: Text('Quantity: ${foodItem.quantity}',
                          style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.bold)),
                      trailing: Text(
                          '₹${(foodItem.price * foodItem.quantity).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  );
                } else {
                  return Container(); // If quantity is 0, don't show in the cart
                }
              },
            ),
          ),
          //SizedBox(height:25.0),
          ElevatedButton(
              onPressed: () {
                addOrderedFoodItemsToFirebase(foodList);
                showDialog(
                  context: context,
                  builder: (context) {
                    //return PaymentDialog();
                    return AlertDialog(
                      title: Text(
                        "Payment Options",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold),
                      ),
                      content: Text(
                        "Please select a payment method.",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold),
                      ),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PaymentPage(foodList:foodList,totOrderPrice:totOrderPrice,)),
                              );
                            },
                            child: Text(
                              "Proceed to Pay",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF5212BF6B),
                            )),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text(
                "Proceed to Pay",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF5212BF6B),
              )),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total Price: ₹${totOrderPrice.toStringAsFixed(2)}',
              style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w900,
                  fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}