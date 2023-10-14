import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:restaraunt_app/AdminHome.dart';
import 'package:restaraunt_app/CartPage.dart';
import 'package:restaraunt_app/DeliveryPage.dart';
import 'package:restaraunt_app/ProfilePage.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FoodItem {
  final String id;
  final String imagePath;
  final String name;
  final double price;
  final double rating;
  int quantity;

  FoodItem({
    required this.id,
    required this.imagePath,
    required this.name,
    required this.price,
    this.rating = 0.0,
    this.quantity = 0,
  });

  double getTotalPrice() {
    return price * quantity;
  }
}

class FoodPage extends StatefulWidget {
  static const String id = "Food_screen";
  final FoodItem? foodItem;

  FoodPage({this.foodItem});

  @override
  _FoodPageState createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  TextEditingController textController = TextEditingController();
  int _selectedIndex = 1;
  int _currentIndex = 0;
  int cartItemCount = 0;
  double totOrderPrice = 0.0;

  final CarouselController _carouselController = CarouselController();
  final List<String> imageList = [
    'assets/Paneert.jpg',
    'assets/Chickent.jpg',
    'assets/grill6.jpg',
    'assets/Chicken.jpg',
  ];

  List<FoodItem> foodList = [];
  List<String> imageLists = [
    'assets/login19.jpeg',
    'assets/salad.png',
    'assets/delivery-man.png',
    'assets/dish.png',
    'assets/fastdelivery.png',
    'assets/food-delivery.png',
    'assets/food-tray.png',
     'assets/menu.png',
     'assets/Menuorder.png',
    'assets/motorbike.png',
    'assets/tray.png',
    'assets/bg.jpg',
    'assets/Chickent.jpg',
    'assets/grill3.jpg',
    'assets/Chicken.jpg',
    'assets/grill6.jpg',
    'assets/Paneert.jpg',
    'assets/Mimg7.jpg',
    'assets/Naan.jpg',
    'assets/adimg1.jpg',
    'assets/Barbeque.jpg',
    'assets/offer2.gif',
    'assets/res1.jpg',
    'assets/res2.jpg',
    'assets/res3.jpg',
    'assets/res4.jpg',
    'assets/res5.jpg',
    'assets/menuf.jpg',
    'assets/menuf1.jpg',
    'assets/menuf3.jpg',
  
  ];
  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _handlePageChange(int index, CarouselPageChangedReason reason) {
    setState(() {
      _currentIndex = index;
    });
  }

  void addToCart(FoodItem foodItem) {
    setState(() {
      final existingCartItem = foodList.firstWhere(
        (item) => item.id == foodItem.id,
        //orElse: () => null,
      );
      if (existingCartItem != null) {
        existingCartItem.quantity++;
      } else {
        foodList.add(FoodItem(
          id: foodItem.id,
          imagePath: foodItem.imagePath,
          name: foodItem.name,
          price: foodItem.price,
          rating: foodItem.rating,
          quantity: 1,
        ));
      }
      updateCartInfo();
    });
  }

  void removeFromCart(FoodItem foodItem) {
    setState(() {
      final existingCartItem = foodList.firstWhere(
        (item) => item.id == foodItem.id,
        //orElse: () => null,
      );
      if (existingCartItem != null && existingCartItem.quantity > 0) {
        existingCartItem.quantity--;
        if (existingCartItem.quantity == 0) {
          foodList.remove(existingCartItem);
        }
      }
      updateCartInfo();
    });
  }

  void updateCartInfo() {
    cartItemCount = foodList.fold<int>(
      0,
      (previousValue, cartItem) => previousValue + cartItem.quantity,
    );
    totOrderPrice = foodList.fold<double>(
      0,
      (previousValue, cartItem) => previousValue + cartItem.getTotalPrice(),
    );
  }

  @override
  void initState() {
    super.initState();
    // Initialize your foodList from Firestore or an empty list
    // You can do this by listening to changes in Firestore collection
    FirebaseFirestore.instance.collection('foodDetails').snapshots().listen(
      (querySnapshot) {
        final updatedFoodList = querySnapshot.docs.map((document) {
          final data = document.data() as Map<String, dynamic>;
          final imagePath = data['imagePath'];
          /*final matchingImage = imageLists.firstWhere(
            (assestPath) => assestPath == imagePath,
            orElse:()=>'assets/res3.jpg',
          );*/
          
          return FoodItem(
            id: document.id,
            name: data['name'],
            imagePath: data['imagePath'],
            price: data['price'].toDouble(),
          );
        }).toList();

        // Update the state with the new foodList.
        setState(() {
          foodList = updatedFoodList;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.foodItem != null) {
      foodList.add(widget.foodItem!);
    }

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
        title: const Text(
          'Food Truck',
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
                        builder: (context) => CartPage(
                            foodList: foodList, totOrderPrice: totOrderPrice),
                      ),
                    );
                  },
                  icon: Icon(Icons.shopping_cart, color: Colors.black),
                ),
                if (cartItemCount > 0)
                  Positioned(
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 10,
                      child: Text(
                        cartItemCount.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: AnimSearchBar(
                width: 400,
                textController: textController,
                onSuffixTap: () {
                  setState(() {
                    textController.clear();
                  });
                },
                color: const Color(0xFF5212BF6B),
                helpText: 'Search here....',
                closeSearchOnSuffixTap: true,
                animationDurationInMilli: 1000,
                rtl: true,
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                ),
                onSubmitted: (String) {},
              ),
            ),
            CarouselSlider(
              carouselController: _carouselController,
              options: CarouselOptions(
                height: 250.0,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                enlargeFactor: 0.3,
                enableInfiniteScroll: true,
                onPageChanged: _handlePageChange,
              ),
              items: imageList.map((imagePath) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset(imagePath, fit: BoxFit.cover),
                );
              }).toList(),
            ),
            Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...foodList.asMap().entries.map((entry) {
                        return Container(
                          width: 8.0,
                          height: 8.0,
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: entry.key == _currentIndex
                                ? Color(0xFF5212BF6B)
                                : Colors.grey,
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 2.0,
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: foodList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final foodItem = foodList[index];
                      final isGreenCard = index % 2 == 0;
                      final ratingColor = isGreenCard
                          ? Colors.orange
                          : Color.fromARGB(255, 10, 88, 12);
                      return Card(
                        elevation: 12.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 16.0),
                        color: isGreenCard ? Colors.white : Color(0xFF5212BF6B),
                        child: ListTile(
                          contentPadding: EdgeInsets.only(right:12.0,left:12.0,top:5.0,bottom:8.0),
                          leading: Image.asset(
                            foodItem.imagePath,
                            width: 80.0,
                            height: 150.0,
                            //fit: BoxFit.cover,
                          ),
                          title: Text(
                            foodItem.name,
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.star,
                                      color: ratingColor, size: 18.0),
                                  SizedBox(width: 4.0),
                                  Text(
                                    foodItem.rating.toStringAsFixed(1),
                                    style: TextStyle(
                                      color: ratingColor,
                                      fontFamily: 'Quicksand',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.0),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (foodItem.quantity > 0) {
                                          foodItem.quantity--;
                                          totOrderPrice -= foodItem.price;
                                        }
                                      });
                                    },
                                    child: Icon(Icons.remove,
                                        color: Colors.black, size: 22.0),
                                  ),
                                  SizedBox(width: 8.0),
                                  Text(
                                    foodItem.quantity.toString(),
                                    style: TextStyle(
                                      fontFamily: 'Quicksand',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(width: 8.0),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        foodItem.quantity++;
                                        totOrderPrice += foodItem.price;
                                      });
                                    },
                                    child: Icon(Icons.add,
                                        color: Colors.black, size: 22.0),
                                  ),
                                  SizedBox(width: 8.0),
                                  Text(
                                    '₹${(foodItem.price * foodItem.quantity).toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontFamily: 'Quicksand',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          onTap: () {
                            // Add your onTap logic here
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: Icon(Icons.home, size: 26),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FoodPage()),
                );
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeliveryPage()),
                );
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
