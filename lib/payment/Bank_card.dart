import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Bank_card extends StatefulWidget {
  const Bank_card({super.key});

  @override
  State<Bank_card> createState() => _Bank_cardState();
}

class _Bank_cardState extends State<Bank_card> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
    body:Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("Use only Personal Bank Card",style: TextStyle(backgroundColor: Colors.yellow),),
            TextField(keyboardType: TextInputType.number,inputFormatters:[FilteringTextInputFormatter.digitsOnly],decoration: InputDecoration(label: Text("Card Number"),),),
            TextField(keyboardType: TextInputType.number,inputFormatters:[FilteringTextInputFormatter.digitsOnly],decoration: InputDecoration(suffixIcon: FaIcon(Icons.question_mark_sharp),labelText: ("Exp. date"),),),
            TextField(keyboardType: TextInputType.name,decoration: InputDecoration(suffixIcon: Icon(Icons.person),labelText: ("Cardholder name"),),),
            TextField(decoration: InputDecoration(suffixIcon: Icon(Icons.email_outlined),labelText: ("your email"),),),
            TextField(keyboardType: TextInputType.number,inputFormatters:[FilteringTextInputFormatter.digitsOnly],decoration: InputDecoration(suffixIcon: FaIcon(Icons.numbers_rounded,),labelText: ("CNIC"),),),
            TextField(keyboardType: TextInputType.number,inputFormatters:[FilteringTextInputFormatter.digitsOnly],decoration: InputDecoration(suffixIcon: Icon(Icons.attach_money),labelText: ("Enter amount"),),),
            SizedBox(height: 15,),
            ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor:Color(808080) ),onPressed: (){}, child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.verified,
                  color: Colors.green, // Color of the verification icon
                ),
                SizedBox(width: 8), // Add spacing between the icon and text
                Text('Pay in'),
              ],
            ),),
          ],
        ),
      ),
    ),
    );
  }
}
