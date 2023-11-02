import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dine_easy/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:http/http.dart' as http;
import '../client_reservations/./client_reservations.dart';
import '../Home/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../client_signin/./token_manager.dart';

class Profile extends StatefulWidget {
  Profile({required this.name, required this.token, Key? key})
      : super(key: key);
  final String token;
  String name;

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  int _selectedIndex = 0; // Default index for profile screen
  Map<String, dynamic>? _profileData;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  // TextEditingController _addressController = TextEditingController();
  bool _isEditing = false;
  bool _dataVisible = false;

  @override
  void initState() {
    super.initState();
    // Initialize default values
    _isEditing = false;
    _profileData = null;
    // Fetch profile data when the screen loads
    fetchProfileData();
  }

  Future<void> getname() async {
    final name = await TokenManager.getName();
    if (name != null) {
      setState(() {
        widget.name = name;
      });
      print("Name assigned to widget name: ${widget.name}");
    }
  }

  void fetchProfileData() async {
    try {
      await getname();
      final Map<String, String> newdata = {
        "name": widget.name,
      };
      print(newdata);
      final response = await http.post(
        Uri.parse(
            "https://sparkling-sarong-bass.cyclic.app/customer/signin/profile"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(newdata),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        setState(() {
          _profileData = data['profile'];
          _nameController.text = _profileData!["name"];
          _emailController.text = _profileData!["email"];
          _passwordController.text = _profileData!["password"];
          _isEditing = false;
          _dataVisible = true; // Set data visibility to true
        });
      } else {
        // Handle error response
        print('Error fetching profile data');
      }
    } catch (error) {
      // Handle network or other errors
      print('Error: $error');
    }
  }

  void _updateProfile() async {
    final updatedData = {};
    await getname();
    print("old name in update profile::${widget.name}");

    if (_nameController.text != _profileData?["name"]) {
      updatedData["newName"] = _nameController.text;
    }

    if (_emailController.text != _profileData?["email"]) {
      updatedData["email"] = _emailController.text;
    }

    if (_passwordController.text != _profileData?["password"]) {
      updatedData["password"] = _passwordController.text;
    }

    updatedData["name"] = widget.name;
    updatedData["token"] = widget.token;
    if (kDebugMode) {
      print("updated data=$updatedData");
    }
    try {
      final response = await http.put(
        Uri.parse(
            "https://sparkling-sarong-bass.cyclic.app/customer/signin/update_profile"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        // Successfully updated, fetch the updated profile data again
        Future.delayed(const Duration(seconds: 2), () {
          fetchProfileData();
        });
        setState(() {
          _isEditing = false;
        });
        _showToastMessage("Profile updated successfully", true);
        await TokenManager.saveName(_nameController.text);
      } else {
        // Handle error response
        print('Error updating profile data:::');
        print(response.body);
        _showToastMessage("Error updating profile data", false);
      }
    } catch (error) {
      // Handle network or other errors
      print('Error: $error');
      _showToastMessage("An error occurred. Please try again later", false);
    }
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    // _addressController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _isEditing = false;
      _selectedIndex = index;
    });
    if (index == 1) {
      if (kDebugMode) {
        print("going to home screen......");
      }
      //Navigate to Menu screen
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RestaurantHomePage(
                  name: widget.name,
                )),
      );
    } else if (index == 2) {
      // Navigate to Reservations screen
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                reservations(name: widget.name, token: widget.token)),
      );
    }
  }

  Future<void> _performLogout() async {
    // Remove token and navigate to login or home screen
    await TokenManager.removeToken();
    await TokenManager.removeName();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage()),
    );
  }

  void _showToastMessage(String message, bool isSuccess) {
    // Flushbar(
    //   message: message,
    //   duration: Duration(seconds: 3),
    //   backgroundColor: isSuccess ? Colors.green : Colors.red,
    // )..show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            // Start color (#F5F5DC)
            Color(0xFF2b1b17),
            Color(0xFF0c0908),
          ],
          begin: Alignment.bottomRight,
          end: Alignment.topCenter,
          stops: [0.1, 0.5],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: const Color(0xFF020403),
          title: const Hero(
            tag: 'profile-title',
            child: Material(
              color: Colors.transparent,
              child: Text(
                'Profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          leading: IconButton(
            color: Colors.red,
            icon: const Icon(Icons.logout_rounded),
            onPressed: () {
              _performLogout();
            },
          ),
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: _isEditing
              ? _buildEditingView()
              : _dataVisible
                  ? _buildDataView()
                  : _buildLoadingView(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 8,
          backgroundColor: const Color(0xFF2b1b17),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Reservations',
            ),
          ],
          currentIndex: _selectedIndex,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.white,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Widget _buildDataView() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Center(
      key: const ValueKey<int>(1),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: BlurryContainer(

          height: height * 0.4,
          width: width * 0.7,
          elevation: 8.3,
          color: Colors.grey.shade900,
          blur: 7,

          child: Padding(
            padding: const EdgeInsets.only(left: 11,top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Hero(
                  tag: 'profile-name',
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      'Name:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                  ),
                ),
                Text(
                  _profileData!["name"],
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 8),
                const Hero(
                  tag: 'profile-email',
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      'Email:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                  ),
                ),
                Text(
                  _profileData!["email"],
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 8),
                const Hero(
                  tag: 'profile-password',
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      'Password:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                  ),
                ),
                Text(
                  _profileData!["password"],
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 8),
                // const Hero(
                //   tag: 'profile-address',
                //   child: Material(
                //     color: Colors.transparent,
                //     child: Text(
                //       'Address:',
                //       style: TextStyle(
                //         fontWeight: FontWeight.bold,
                //         fontSize: 18,
                //       ),
                //     ),
                //   ),
                // ),
                // Text(_profileData!["address"]),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isEditing = true;
                      });
                    },
                    child: const Text('Edit Profile'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditingView() {
    return Center(
      key: const ValueKey<int>(2),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Hero(
              tag: 'profile-name-edit',
              child: Material(
                color: Colors.transparent,
                child: Text(
                  'Name:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white),
                ),
              ),
            ),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Hero(
              tag: 'profile-email-edit',
              child: Material(
                color: Colors.transparent,
                child: Text(
                  'Email:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white),
                ),
              ),
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Hero(
              tag: 'profile-password-edit',
              child: Material(
                color: Colors.transparent,
                child: Text(
                  'Password:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white),
                ),
              ),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            // const Hero(
            //   tag: 'profile-address-edit',
            //   child: Material(
            //     color: Colors.transparent,
            //     child: Text(
            //       'Address:',
            //       style: TextStyle(
            //         fontWeight: FontWeight.bold,
            //         fontSize: 18,
            //       ),
            //     ),
            //   ),
            // ),
            // TextFormField(
            //   controller: _addressController,
            //   decoration: const InputDecoration(
            //     border: OutlineInputBorder(),
            //   ),
            // ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _updateProfile,
                  child: const Text('Update'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      key: ValueKey<int>(3),
      child: CircularProgressIndicator(),
    );
  }
}
