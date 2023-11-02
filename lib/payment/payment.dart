import 'package:flutter/material.dart';

import 'Bank_card.dart';
import 'Wallet.dart';

class paymentpage extends StatefulWidget {
  const paymentpage({super.key});

  @override
  State<paymentpage> createState() => _paymentpageState();
}

class _paymentpageState extends State<paymentpage> {
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
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFF020403),
          ),
          body: Center(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 120,
                    ),
                    const Text(
                      "Want to payment now",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // Container(
                    //     width: double.infinity,
                    //     height: 50,
                    //     child: ElevatedButton(
                    //         onPressed: () {
                    //           Navigator.push(
                    //             context,
                    //             MaterialPageRoute(builder: (context) => const Bank_card()),
                    //           );
                    //         }, child: Text("Bank cards"))),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                        width: double.infinity,
                        height: 50,
                        color: Colors.teal,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Wallet()),
                              );
                            },
                            child: Text("Wallet"))),
                    const SizedBox(
                      height: 15,
                    ),
                    // Container(
                    //     width: double.infinity,
                    //     height: 50,
                    //     child: ElevatedButton(onPressed: () {}, child: Text("FAQ"))),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Back"))),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
