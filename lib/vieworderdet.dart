import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sweetncoloursadmin/services/database.dart';

import 'models/product.dart';

class OrderDetials extends StatefulWidget {
  final Function showOrderDetails;
  final String? order_id;
  final String? customer_id;
  const OrderDetials({super.key, required this.showOrderDetails,required this.order_id,required this.customer_id});

  @override
  State<OrderDetials> createState() => _OrderDetialsState();
}

class _OrderDetialsState extends State<OrderDetials> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
          //Color.fromRGBO(215,15,100, 1)
           backgroundColor:Color.fromRGBO(245,245,245,1),
          body:Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient:LinearGradient(
          begin: Alignment.bottomLeft,
          end:Alignment.topRight,
          colors:[Color.fromRGBO(132,90,254,1),Color.fromRGBO(174,46,255,1)],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: (){
                        widget.showOrderDetails();
                      },
                      child: Icon(FontAwesomeIcons.arrowLeft, color: Colors.white,size:16)),
                  ],
                ),
              ),
              ),

              SizedBox(height:12),

              Padding(
                  padding: const EdgeInsets.fromLTRB(20,0,20,20),
                  child: StreamProvider<List<OrderedProducts>?>.value(
                    value:FetchOrderFromCustomer(widget.order_id,widget.customer_id).getOrdersItem,
                    initialData: null,
                    child: OrderedProductGrid())),
                
            ],
          ),
    );
  }
}