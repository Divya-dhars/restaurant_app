import 'package:flutter/material.dart';
import 'package:restaraunt_app/CartPage.dart';
import 'package:restaraunt_app/FoodPage.dart';
import 'package:restaraunt_app/ProfilePage.dart';
import 'package:restaraunt_app/home.dart';

class DeliveryPage extends StatefulWidget {
  static String id = "delivery_screen";
   final List<FoodItem> orderedFoodItems;
  final String deliveryTime;

  DeliveryPage({required this.orderedFoodItems, required this.deliveryTime, required List<FoodItem> orderedFooditems});
  @override
  _DeliveryPageState createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  int _selectedIndex = 1;
 
  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
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
            icon: Icon(Icons.arrow_back, color: Colors.black)),
        centerTitle: true,
        backgroundColor: const Color(0xFF5212BF6B),
        title: const Text(
          'Food Truck',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body:Column(
        children:<Widget>[
          Card(
            elevation:10.0,
            margin:EdgeInsets.all(16.0),
            child:ListTile(
              title:Text('Your Order',
              style:TextStyle(fontFamily:'Quicksand',fontWeight:FontWeight.bold)
              ),
              subtitle:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:widget.orderedFoodItems.map((item){
                  return Text('${item.name}-${item.quantity} x ${item.price}');
                }).toList(),
              ),
            ),
            ),
            Card(
              elevation:10.0,
              margin:EdgeInsets.all(16.0),
              child:ListTile(
                title:Text('Expected Delivery Time:',
                style:TextStyle(fontFamily:'Quicksand',fontWeight:FontWeight.w800)
                ),
                subtitle:Text(widget.deliveryTime,
                style:TextStyle(fontFamily:'Quicksand',fontWeight:FontWeight.bold)
                ),
              )
            )
        ]
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF5212BF6B),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Quicksand',
          fontWeight: FontWeight.w900,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Quicksand',
          fontWeight: FontWeight.w900,
        ),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: Icon(Icons.home, size: 26),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FoodPage()));
              },
              child: Image.asset(
                'assets/food-tray.png',
                width: 26,
                height: 26,
              ),
            ),
            label: 'Food',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
             onTap: () {
                /*/Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DeliveryPage()));*/
              },
              child: Image.asset(
                'assets/motorbike.png',
                width: 26,
                height: 26,
              ),
            ),
            label: 'Delivery',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(),
                  ),
                );
              },
              child: Icon(Icons.person, size: 26),
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
