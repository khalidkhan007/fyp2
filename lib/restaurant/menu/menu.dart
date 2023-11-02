import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../profile/profile.dart';
import '../token_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:http/http.dart' as http;
import '../reservations/reservations.dart';

class menu extends StatefulWidget {
  const menu({Key? key, required this.name, required this.token})
      : super(key: key);
  final dynamic token;
  final String name;
  @override
  State<menu> createState() => _menuState();
}

class _menuState extends State<menu> {
  int _selectedIndex = 1; // Default index for the profile screen
  Map<String, int>? _menuData;
  bool _isEditing = false;
  Map<String, int>? _originalMenuData;
  Map<String, int>? _editedMenuData;
  bool _addingNewItem = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController newNameController = TextEditingController();
  TextEditingController newPriceController = TextEditingController();
  String? _renamingItem;

  @override
  void initState() {
    super.initState();
    _originalMenuData = {};
    _editedMenuData = {};
    fetchMenuData();
  }
// delete items
  void _deleteItem(String itemName,int item_price) async {
    // Implement the logic to delete the menu item
    try {
      final response = await http.post(

        // https://sparkling-sarong-bass.cyclic.app/signin/restaurant/menu_delete

        Uri.parse("https://sparkling-sarong-bass.cyclic.app/signin/restaurant/menu_delete"), // Replace with your API URL
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "name": widget.name,
          "menu": {
            itemName: item_price
          }
        }),
      );

      if (response.statusCode == 200) {
        // Menu item deleted successfully
        final deletedData = json.decode(response.body);
        print("Deleted Item: $deletedData");
        setState(() {
          // Update the menu data by removing the deleted item
          _menuData!.remove(itemName);
        });
      } else {
        print('Error deleting menu item');
        Fluttertoast.showToast(
          msg: "Error deleting menu item. Please try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (error) {
      print('Error: $error');
      Fluttertoast.showToast(
        msg: "An error occurred. Please check your internet connection.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }


  void _updateItemPrice(String itemName, int newPrice) {
    setState(() {
      // Update the edited data with the new price
      _editedMenuData![itemName] = newPrice;

      // Clear the item being edited
      _cancelRenameItem();
    });
  }

  void _startRenameItem(String itemName) {
    setState(() {
      newNameController.text =
          itemName; // Set the text field with the current name
      if (_menuData != null && _menuData!.containsKey(itemName)) {
        newPriceController.text = _menuData![itemName].toString();
      }
      _renamingItem = itemName; // Store the item being renamed
    });
  }

  void _cancelRenameItem() {
    setState(() {
      _renamingItem = null; // Clear the renaming item
    });
  }

  void _renameItem() {
    final newName = newNameController.text;
    final newPrice = int.parse(newPriceController.text);

    _editedMenuData = Map.from(_originalMenuData!);
    if (kDebugMode) {
      print("edited data:::$_editedMenuData");
      print("original data:::$_originalMenuData");
    }

    print("renaming item::::$_renamingItem");
    print("value of renaming item is::::${_editedMenuData![_renamingItem]}");
    _editedMenuData?.update(_renamingItem!, (value) => newPrice,
        ifAbsent: () => newPrice);

    if (newName.isNotEmpty && _renamingItem != null) {
      // Check if _renamingItem is not null
      // Update the edited data with the new name
      final currentValue = _editedMenuData![_renamingItem!];

      print("current value ::::$currentValue");
      print("new item:::::$newName");

      if (currentValue != null) {
        print("renaming item value before removing::::$_renamingItem");
        _editedMenuData!.remove(_renamingItem!);
        _editedMenuData![newName] = currentValue;
        print("edited data after removal:::$_editedMenuData");
        _cancelRenameItem(); // Clear the renaming item
      } else {
        print("item not updated...............");
      }
    }
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      // Navigate to the Menu screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Profile(name: widget.name, token: widget.token),
        ),
      );
    } else if (index == 2) {
      // Navigate to the Reservations screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              reservations(name: widget.name, token: widget.token),
        ),
      );
    }
  }

  Future<void> fetchMenuData() async {
    try {
      final Map<String, String> _reqdata = {"name": widget.name};
      final response = await http.post(
        Uri.parse("https://sparkling-sarong-bass.cyclic.app/signin/restaurant/menu"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(_reqdata),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        setState(() {
          _menuData = Map<String, int>.from(data);
          _originalMenuData = Map<String, int>.from(data);
        });
      } else {
        print("error fetching menu data");
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  void _updateMenu() async {
    if (!_isEditing) {
      return;
    }
    if (kDebugMode) {
      print("edited data:::$_editedMenuData");
    }
    final Map<String, dynamic> combinedMenuData = {
      "name": widget.name,
      "menu": _editedMenuData,
    };

    if (kDebugMode) {
      print("before sending req:::$combinedMenuData");
    }
    try {
      final response = await http.put(
        Uri.parse("https://sparkling-sarong-bass.cyclic.app/signin/restaurant/menu_update"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(combinedMenuData),
      );

      if (response.statusCode == 200) {
        final updatedData = json.decode(response.body);
        print(updatedData);
        setState(() {
          _menuData = Map<String, int>.from(updatedData["menu"]);
          _isEditing = false;
        });

        Fluttertoast.showToast(
          msg: "Menu updated successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        print('Error updating menu data::${response.statusCode}');
        print('Response Body: ${response.body}');
        Fluttertoast.showToast(
          msg: "Error updating menu data. Please try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (error) {
      print('Error: $error');
      Fluttertoast.showToast(
        msg: "Menu updated successfully!",
        toastLength: Toast.LENGTH_SHORT,  // Corrected typo here
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

    }
  }

  void _addNewItemToMenu() async {
    final newItemName = nameController.text;
    final newItemPrice = priceController.text;

    if (newItemName.isNotEmpty && newItemPrice.isNotEmpty) {
      final parsedPrice = int.parse(newItemPrice);
      if (parsedPrice != null) {
        _editedMenuData![newItemName] = int.parse(newItemPrice);
      }

      try {
        final response = await http.post(
          Uri.parse("https://sparkling-sarong-bass.cyclic.app/signin/restaurant/menu_create"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            "name": widget.name,
            "menu": {
              newItemName: parsedPrice,
            },
          }),
        );



        if (response.statusCode == 200) {
          final addedItem = json.decode(response.body);
          print("Added Item: $addedItem");
          setState(() {
            _menuData = Map<String, int>.from(addedItem["menu"]);
            _editedMenuData!.remove(newItemName);
            _addingNewItem = false;
          });
        } else {
          print('Error adding new item to menu data');
          Fluttertoast.showToast(
            msg: "Error adding new item to menu data. Please try again.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } catch (error) {
        print('Error: $error');
        Fluttertoast.showToast(
          msg: "An error occurred. Please check your internet connection.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
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
          title: Text("Menu"),
          actions: [
            IconButton(
              icon: Icon(_isEditing ? Icons.save : Icons.edit),

              onPressed: () {
                setState(() {
                  if (_isEditing) {
                    _updateMenu();
                  }
                  _isEditing = !_isEditing;
                  if (!_isEditing) {
                    setState(() {
                      _menuData = Map<String, int>.from(_originalMenuData!);
                      _editedMenuData = {};
                    });
                  }
                });
              },
            ),
            if (_isEditing)
              IconButton(
                icon: Icon(Icons.cancel),
                onPressed: () {
                  setState(() {
                    _isEditing = false;
                    setState(() {
                      _menuData = Map<String, int>.from(_originalMenuData!);
                      _editedMenuData = {};
                    });
                  });
                },
              ),
          ],
        ),
        body: Center(
          child: Column(
            children: [
              //   Text("hello ",style: TextStyle(color: Colors.white),),
              _addingNewItem
                  ? Column(
                children: [
                  ListTile(
                    title: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'item name',
                        hintText: 'Enter your name of item',
                        hintStyle: TextStyle(color: Colors.white),
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      style: const TextStyle(color: Colors.white),
                      controller: nameController,
                    ),
                    subtitle: TextFormField(
                      decoration: const InputDecoration(

                        labelText: 'item price',
                        hintText: 'Enter your name of item',
                        hintStyle: TextStyle(color: Colors.white),
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      style: const TextStyle(color: Colors.white),
                      controller: priceController,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _addingNewItem = false;
                            _editedMenuData?.remove("New Item");
                          });
                        },
                        child: Text(" Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _addNewItemToMenu();
                          });
                        },
                        child: Text("Add"),
                      ),
                    ],
                  ),
                ],
              )
                  : SizedBox.shrink(),
              _menuData == null
                  ? const CircularProgressIndicator()
                  : Expanded(
                child: ListView.builder(
                  itemCount: _menuData!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final menuEntry = _menuData!.entries.elementAt(index);

                    return ListTile(
                      title: _renamingItem == menuEntry.key
                          ? Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              decoration: const InputDecoration(

                              ),
                              style: const TextStyle(
                                  color: Colors.white),
                              controller: newNameController,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              decoration: const InputDecoration(
                              ),
                              style: const TextStyle(
                                  color: Colors.white),
                              controller: newPriceController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              onPressed: _renameItem,
                              child: Text("Save"),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              onPressed: _cancelRenameItem,
                              child: Text("Cancel"),
                            ),
                          ),
                        ],
                      )
                          : Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: () {
                                if (_isEditing) {
                                  if (kDebugMode) {
                                    print("Edit button pressed for ${menuEntry.key}");
                                  }
                                  _startRenameItem(menuEntry.key);
                                }
                              },
                              child: Text(
                                menuEntry.key,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              menuEntry.value.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          if (_isEditing) // Show delete icon when in edit mode
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                icon: Icon(Icons.delete,color: Colors.white,),
                                onPressed: () {
                                  // Handle the deletion logic when the delete icon is pressed
                                  _deleteItem(menuEntry.key,menuEntry.value);
                                },
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _addingNewItem = !_addingNewItem;
            });
          },
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        bottomNavigationBar: BottomNavigationBar(
          elevation: 8,
          backgroundColor: const Color(0xFF2b1b17),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded),
              label: 'menu',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Reservations',
            ),
          ],
          currentIndex: _selectedIndex,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.blue,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}


