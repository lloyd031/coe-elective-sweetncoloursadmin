import 'package:flutter/material.dart';

class OrderDeials extends StatefulWidget {
  const OrderDeials({super.key});

  @override
  State<OrderDeials> createState() => _OrderDeialsState();
}

class _OrderDeialsState extends State<OrderDeials> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
          //Color.fromRGBO(215,15,100, 1)
           backgroundColor:Colors.white,
          appBar:  AppBar(
            elevation: 0,
            leading: Builder( builder: (BuildContext context) { return IconButton(
              onPressed:(){Scaffold.of(context).openDrawer();}, 
              icon: Icon(Icons.menu,color: Colors.grey[600],size: 20,)); }),
          
          backgroundColor:Colors.white,
          actions: <Widget>[
            IconButton(onPressed: (){}, icon: const Icon(Icons.notifications, color:Colors.white,size: 18,)),
          ],
          ),
          body:Text("order"),
    );
  }
}