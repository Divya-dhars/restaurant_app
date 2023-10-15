import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminCartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF5212BF6B),
        title: Text(
          'Order Details',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: OrderList(), // Display the order list
    );
  }
}

class OrderList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('orders').snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final orders = snapshot.data!.docs;

        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index].data() as Map<String, dynamic>;
            return OrderCard(orderData: order);
          },
        );
      },
    );
  }
}

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> orderData;

  OrderCard({required this.orderData});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation:15.0,
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Food Name: ${orderData['name']}',
            style:TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.bold)
            ),
            Text('Quantity: ${orderData['quantity']}',
            style:TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.bold)
            ),
            Text('Total Amount: \₹${orderData['price']}',
            style:TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.bold)
            ),
            Text('Customer Name: ${orderData['username']}',
            style:TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.bold)
            ),
            Text('Address: ${orderData['address']}',
            style:TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.bold)
            ),
            Text('Mobile Number: ${orderData['mobileNumber']}',
            style:TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.bold)
            ),
            // Add more fields as needed
          ],
        ),
      ),
    );
  }
}
