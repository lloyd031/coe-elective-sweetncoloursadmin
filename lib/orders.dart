import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sweetncoloursadmin/models/product.dart';
import 'package:sweetncoloursadmin/models/user.dart';
import 'package:sweetncoloursadmin/services/database.dart';

class OrdersPanel extends StatefulWidget {
  const OrdersPanel({super.key});

  @override
  State<OrdersPanel> createState() => _OrdersPanelState();
}

class _OrdersPanelState extends State<OrdersPanel> {
  @override
  Widget build(BuildContext context) {
   final order = Provider.of<List<Orders>?>(context);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height:18,),
              
                 const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("PENDING ORDER LIST",style:TextStyle(color:Colors.black54,fontSize: 16,fontWeight:FontWeight.bold)),
                    SizedBox(width: 24,),
                    Text("1",style:TextStyle(color:Colors.black54,fontSize: 16,fontWeight:FontWeight.bold))
                  ]
                ),
            
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, 
            crossAxisSpacing:12,
            mainAxisSpacing: 12,
            mainAxisExtent:100,),
            itemCount: (order==null)? 0: order.length,
            itemBuilder: (_,index)
            {
              return OrderTile(order:order?[index]);
            }
            
          ),
        ],
      ),
    );
  }
    
  }
  class OrderTile extends StatefulWidget {
    final Orders? order;
  const OrderTile({super.key, required this.order});

  @override
  State<OrderTile> createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile> {
  @override
  Widget build(BuildContext context) {
    return  SizedBox(
        width:double.maxFinite,
        child: Column(
          mainAxisSize:MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            const SizedBox(
              height: 16,
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top:Radius.circular(8)),
              gradient:const LinearGradient(
                begin: Alignment.bottomLeft,
                end:Alignment.topRight,
                colors:[Color.fromRGBO(132,90,254,1),
            Color.fromRGBO(174,46,255,1),],
              ),
            
            ),
              
              child: Row(
                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                children: [
                  StreamProvider<UserData?>.value(
                  value:DatabaseService(widget.order?.customerId, null,"").userData,
                  initialData: null,
                  child:const CustomerModel())
                  ,
                  const Row(
                    children: [
                      Icon(FontAwesomeIcons.calendarDay,color:Color.fromRGBO(239,201,255,1),size:14),
                        SizedBox(
                            width: 8,
                          ),
                      Text("July 4, 2023",style:TextStyle(color:Color.fromRGBO(239,201,255,1),fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding:EdgeInsets.all(8),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      Text("Total",style:TextStyle(color:Colors.black54,fontSize: 12)),
                      Text("P542.00",style:TextStyle(color:Color.fromRGBO(11,16,36,1),fontSize: 13,fontWeight: FontWeight.bold))
                    ]
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    
  }
}
class CustomerModel extends StatelessWidget {
  const CustomerModel({super.key});

  @override
  Widget build(BuildContext context) {
    final customer = Provider.of<UserData?>(context);
    return Text("${customer?.fn}",style:const TextStyle(color:Colors.white,fontSize: 12,));
  }
}