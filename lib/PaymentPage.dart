import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaraunt_app/DeliveryPage.dart';
import 'package:restaraunt_app/FoodPage.dart';
import 'package:restaraunt_app/ProfilePage.dart';
import 'package:restaraunt_app/upi.dart';
import 'package:upi_india/upi_india.dart';

class PaymentPage extends StatefulWidget {
  static String id = "Payment_screen";
  final List<FoodItem> foodList;
  final double totOrderPrice;
  PaymentPage({required this.foodList, required this.totOrderPrice});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final double order = 1;
  String selectedPaymentMethod = 'Cash on Delivery(COD)';

  void handlePayment(String selectedMethod) {
    if (selectedMethod == 'UPI') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UPIPayment(order: this.order)),
      );
    } else if (selectedMethod == 'Credit/Debit Card') {
      // Implement Credit/Debit card payment logic
    } else if (selectedMethod == 'Cash on Delivery (COD)') {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Confirm Delivery Address",
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                "Your order will be delivered to your adrress.Do you want to change it?",
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                TextButton(
                  child: Text(
                    "Change Address",
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ProfilePage()));
                  },
                ),
                TextButton(
                    child: Text(
                      "Confirm Address",
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      placeOrder();
                      //Navigator.of(context).pop();
                    })
              ],
            );
          });
    }
  }

  void placeOrder() {
    double totOrderPrice=0.0;
    for (var foodItem in widget.foodList) {
    totOrderPrice += (foodItem.price * foodItem.quantity);
  }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Make Order",
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "OK",
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DeliveryPage(
                          foodList: widget.foodList,
                          totOrderPrice: totOrderPrice)),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: Colors.black)),
        centerTitle: true,
        backgroundColor: Color(0xFF5212BF6B),
        title: Text('Payment Page',
            style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w900,
                color: Colors.black)),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 25.0),
          Card(
            elevation: 10.0,
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: Text('UPI',
                  style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              leading: Radio(
                value: 'UPI',
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value!;
                  });
                },
                activeColor: Color(0xFF53917E),
              ),
            ),
          ),
          Card(
            elevation: 10.0,
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: Text('Credit/Debit Card',
                  style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              leading: Radio(
                value: 'Credit/Debit Card',
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value!;
                  });
                },
                activeColor: Color(0xFF53917E),
              ),
            ),
          ),
          Card(
            elevation: 10.0,
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: Text('Cash on Delivery (COD)',
                  style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              leading: Radio(
                value: 'Cash on Delivery (COD)',
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value!;
                  });
                },
                activeColor: Color(0xFF53917E),
              ),
            ),
          ),
          SizedBox(height: 25.0),
          ElevatedButton(
              onPressed: () {
                handlePayment(selectedPaymentMethod);
              },
              child: Text('Proceed to Pay',
                  style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF5212BF6B),
              )),
        ],
      ),
    );
  }
}
