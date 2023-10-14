import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaraunt_app/DeliveryPage.dart';
import 'package:restaraunt_app/FoodPage.dart';
import 'package:restaraunt_app/home.dart';

class ProfilePage extends StatefulWidget {
  static String id = "profile_screen";
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  late User? user;
  int _selectedIndex = 0;
  String deliveryTime = '35-40 minutes';
  List<FoodItem> foodList = [];
  List<FoodItem> orderedFoodItems = [];
  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('user_profiles')
          .doc(user!.uid)
          .get();
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _nameController.text = userData['name'] ?? '';
          _addressController.text = userData['address'] ?? '';
          _phoneController.text = userData['phone'] ?? '';
        });
      }
    }
  }

  // Define a callback function to update the profile data
  void _updateProfileData() {
    _fetchUser(); // Fetch the updated user data
    Navigator.pop(context); // Close the EditProfilePage
  }

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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF5212BF6B),
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(
                    nameController: _nameController,
                    addressController: _addressController,
                    phoneController: _phoneController,
                    onSave: _updateProfileData,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.black),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.person,
              size: 100,
              color: Colors.black,
            ),
            if (user != null)
              Text(
                'User: ${user!.email}',
                style: TextStyle(fontSize: 18, fontFamily: 'Quicksand'),
              ),
            SizedBox(height: 20),
            ProfileInformation(
              nameController: _nameController,
              addressController: _addressController,
              phoneController: _phoneController,
              user: user,
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DeliveryPage(
                      orderedFoodItems:orderedFoodItems,deliveryTime:deliveryTime, orderedFooditems: [],
                    )));
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
                // Navigate to ProfilePage
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

class ProfileInformation extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController addressController;
  final TextEditingController phoneController;
  final User? user;

  ProfileInformation({
    required this.nameController,
    required this.addressController,
    required this.phoneController,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildProfileCard('Name', nameController.text),
        _buildProfileCard('Address', addressController.text),
        _buildProfileCard('Phone Number', phoneController.text),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Implement the Create Profile functionality here
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProfilePage(
                  nameController: nameController,
                  addressController: addressController,
                  phoneController: phoneController,
                  onSave: () async {
                    // Save the profile details to Firestore here
                    await FirebaseFirestore.instance
                        .collection('user_profiles')
                        .doc(user?.uid)
                        .set({
                      'name': nameController.text,
                      'address': addressController.text,
                      'phone': phoneController.text,
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            );
          },
          child: Text(
            'Create Profile',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            primary: Color(0xFF5212BF6B),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard(String label, String value) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10.0),
      child: Container(
        height: 80.0,
        width: 360.0,
        child: ListTile(
          title: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Quicksand',
            ),
          ),
          subtitle: Text(value,
              style: TextStyle(
                fontFamily: 'Quicksand',
              )),
        ),
      ),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController addressController;
  final TextEditingController phoneController;
  final VoidCallback onSave;

  EditProfilePage({
    required this.nameController,
    required this.addressController,
    required this.phoneController,
    required this.onSave,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  int _selectedIndex = 0;

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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF5212BF6B),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontFamily: 'Quicksand',
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: widget.nameController,
              style: TextStyle(
                fontFamily: 'Quicksand',
              ),
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Quicksand',
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            TextFormField(
              controller: widget.addressController,
              style: TextStyle(
                fontFamily: 'Quicksand',
              ),
              decoration: InputDecoration(
                labelText: 'Address',
                labelStyle: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Quicksand',
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            TextFormField(
              controller: widget.phoneController,
              style: TextStyle(
                fontFamily: 'Quicksand',
              ),
              decoration: InputDecoration(
                labelText: 'Phone Number',
                labelStyle: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Quicksand',
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () {
                // Implement the Save Profile functionality here
                widget.onSave();
              },
              child: Text(
                'Save Profile',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Quicksand',
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF5212BF6B),
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
                // Navigate to Home
              },
              child: Icon(Icons.home, size: 26),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                // Navigate to FoodPage
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
                // Navigate to DeliveryPage
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
                // Navigate to ProfilePage
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
