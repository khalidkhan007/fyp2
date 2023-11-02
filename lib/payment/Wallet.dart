import 'package:dine_easy/client/Home/HomePage.dart';
import 'package:dine_easy/main.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../client/client_signin/token_manager.dart';

class Wallet extends StatefulWidget {
  Wallet({super.key});
  String? name;

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  TextEditingController amountController = TextEditingController();

  Future<void> getname() async {
    final Name = await TokenManager.getName();
    if (Name != null) {
      setState(() {
        name = Name;
      });
      print("Name assigned to widget name: ${widget.name}");
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
        ),
        body: Container(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SizedBox(height: 100,),

              const Text(
                "Please select a payment provider",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent),
                      onPressed: () {},
                      child: Container(
                        child: Image.asset(
                          'assets/images/3.jpg',
                          width: 130,
                          height: 130,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                      ),
                      onPressed: () {},
                      child: Container(
                        color: Colors.transparent,
                        child: Image.asset(
                          'assets/images/jazzcash.jpg',
                          width: 130,
                          height: 130,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                width: 20,
              ),
              SizedBox(height: 30,),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Enter Amount',
                  prefixIcon: Icon(Icons.attach_money), // Optional: Add a currency icon

                  filled: true,
                  fillColor: Colors.white, // Change to your desired background color
                ),
                style: TextStyle(fontSize: 16.0, color: Colors.black), // Adjust text style
                cursorColor: Colors.blue, // Change cursor color to your preference
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(
                      0xFF808080), // Change 808080 to the correct color value
                  fixedSize: Size(double.infinity,
                      60), // Adjust the height as per your requirements
                ),
                onPressed: () {
                  awasomdialog();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(21),
                      ),
                    ),
                    Icon(
                      Icons.verified,
                      color: Colors.green, // Color of the verification icon
                    ),
                    SizedBox(width: 8), // Add spacing between the icon and text
                    Text('Pay in'),
                  ],
                ),
              ),
              TextButton(
                  onPressed: () async {



                    await getname();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RestaurantHomePage(name: name!)),
                    );
                  },
                  child: Text(
                    "skip",
                    style: TextStyle(color: Colors.lightBlue),
                  ))
            ],
          ),
        )),
      ),
    );
  }
  void awasomdialog(){

    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      showCloseIcon: true,
      dialogType: DialogType.success,
      body: Center(child: Text(
        'Payment successful',
        style: TextStyle(fontStyle: FontStyle.italic),
      ),),
      title: 'Success',
      desc:   'This is also Ignored',
      btnOkOnPress: () {},
    )..show();
  }
}
