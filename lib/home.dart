import 'package:flutter/material.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:restaraunt_app/DeliveryPage.dart';
import 'package:restaraunt_app/FoodPage.dart';
import 'package:restaraunt_app/ProfilePage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String id = "Home_screen";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController textController = TextEditingController();
  int _selectedIndex = 1;
  final List<String> imageList = [
    'assets/Paneert.jpg',
    'assets/Chickent.jpg',
    'assets/grill6.jpg',
    'assets/Chicken.jpg',
  ];
  String deliveryTime = '35-40 minutes';
  int _currentIndex = 0; // To keep track of the current image index
  final CarouselController _carouselController = CarouselController();
  final double totOrderPrice = 0.0;
  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  // Function to handle page change in CarouselSlider
  void _handlePageChange(int index, CarouselPageChangedReason reason) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      ),
      body: ListView(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              children: [
                AnimSearchBar(
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
              ],
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
              onPageChanged: _handlePageChange, // Callback for page change
            ),
            items: imageList.map((imagePath) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.asset(imagePath, fit: BoxFit.cover),
              );
            }).toList(),
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imageList.asMap().entries.map((entry) {
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
          ),
          const SizedBox(height: 1.0),
          Card(
            margin: EdgeInsets.all(16.0),
            elevation: 5,
            shadowColor: const Color.fromARGB(255, 173, 204, 174),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.width * 0.24,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF5212BF6B),
                    Color(0xFF5212BF6B),
                    Color(0xFF5212BF6B)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Offers:',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          '   up to 50% OFF, flat discounts',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Color.fromARGB(255, 10, 88, 12),
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '   and other great offers',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Color.fromARGB(255, 10, 88, 12),
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width *
                        0.20, // 80% of screen width
                    height: MediaQuery.of(context).size.width * 0.25,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/offer2.gif'),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF5212BF6B).withOpacity(0.0),
                          spreadRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ], // Replace with the path to your GIF
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 1.0),
          Card(
            color: Colors.white,
            margin: const EdgeInsets.all(20.0),
            elevation: 7,
            shadowColor: const Color.fromARGB(255, 173, 204, 174),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                  ),
                  child: Image.asset(
                    'assets/Barbeque.jpg',
                    width: 380.0,
                    height: 160.0,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width *
                      0.8, // 80% of screen width
                  height: MediaQuery.of(context).size.width * 0.3,
                  child: const Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          //crossAxisAlignment: CrossAxisAlignment.center,
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Delivery Available',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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
                    MaterialPageRoute(builder: (context) => ProfilePage()));
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DeliveryPage()));
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
