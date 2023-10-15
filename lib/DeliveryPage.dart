import 'package:flutter/material.dart';
import 'package:restaraunt_app/FoodPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeliveryPage extends StatefulWidget {
  final List<FoodItem> foodList;
  final double totOrderPrice;

  DeliveryPage({
    required this.foodList,
    required this.totOrderPrice,
  });

  @override
  _DeliveryPageState createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  void saveOrderDetails() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
      'orders',
      widget.foodList.map((foodItem) => foodItem.name).toList(),
    );
    prefs.setDouble('totalOrderPrice', widget.totOrderPrice);
  }

  void removeItem(int index) {
    setState(() {
      widget.foodList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delivery Page'),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final foodItem = widget.foodList[index];
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    removeItem(index);
                  },
                  background: Container(
                    color: Colors.red,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    alignment: Alignment.centerRight,
                  ),
                  child: Card(
                    elevation: 10.0,
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                  ),
                );
              },
              childCount: widget.foodList.length,
            ),
          ),
          SliverToBoxAdapter(
            child: ElevatedButton(
              onPressed: () {
                saveOrderDetails();
              },
              child: Text('Confirm Order'),
            ),
          ),
        ],
      ),
    );
  }
}
