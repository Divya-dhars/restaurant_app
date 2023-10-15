import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaraunt_app/FoodPage.dart';
import 'package:restaraunt_app/AdminCartPage.dart';// Assuming FoodItem is a custom class.

class AdminPanel extends StatefulWidget {
  static String id = "adminpanel_screen";
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController imagePathController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

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
          'Admin Panel',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminCartPage(),
                    ),
                  );
                },
                icon: Icon(Icons.shopping_cart, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Card(
          elevation: 20.0,
          margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.1,
            horizontal: MediaQuery.of(context).size.width * 0.1,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    ),
                  ),
                ),
                TextField(
                  controller: imagePathController,
                  decoration: InputDecoration(
                    labelText: 'Image Path',
                    labelStyle: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    ),
                  ),
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    labelStyle: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    addFoodItem();
                  },
                  child: Text(
                    'Add Food Item',
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF5212BF6B),
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Food Items:',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: firestore.collection('foodDetails').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    final foodItems = snapshot.data!.docs;
                    return Column(
                      children: foodItems.map((foodItem) {
                        final data = foodItem.data() as Map<String, dynamic>;
                        return ListTile(
                          title: Text(
                            data['name'],
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'Price: ₹${data['price']}',
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  updateFoodItemFirestore(foodItem.id);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  deleteFoodItem(foodItem.id);
                                },
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addFoodItem() {
    final name = nameController.text;
    final imagePath = imagePathController.text;
    final price = double.parse(priceController.text);
    
    if (name.isNotEmpty && price > 0) {
      firestore.collection('foodDetails').add({
        'name': name,
        'imagePath': imagePath,
        'price': price,
      });

      // Clear the text fields
      nameController.clear();
      imagePathController.clear();
      priceController.clear();
    }
  }

  void updateFoodItemFirestore(String docId) {
    final name = nameController.text;
    final imagePath = imagePathController.text;
    final price = double.parse(priceController.text);

    firestore.collection('foodDetails').doc(docId).update({
      'name': name,
      'imagePath': imagePath,
      'price': price,
    });

    // Clear the text fields
    nameController.clear();
    imagePathController.clear();
    priceController.clear();
  }

  void deleteFoodItem(String docId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Delete Food Item',
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this food item?',
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                firestore.collection('foodDetails').doc(docId).delete();
                Navigator.pop(context);
              },
              child: Text(
                'Yes',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'No',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
