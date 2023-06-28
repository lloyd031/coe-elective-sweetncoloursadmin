import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sweetncoloursadmin/models/product.dart';
import 'package:sweetncoloursadmin/models/user.dart';
import 'package:sweetncoloursadmin/pendingoreder.dart';
import 'package:sweetncoloursadmin/services/database.dart';

class OrdersPanel extends StatefulWidget {
  final Function showOrderDetails;
  const OrdersPanel({super.key,required this.showOrderDetails});

  @override
  State<OrdersPanel> createState() => _OrdersPanelState();
}

class _OrdersPanelState extends State<OrdersPanel> {

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserObj?>(context);
   final order = Provider.of<List<Orders>?>(context);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height:18,),
              
                  Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("PENDING ORDER LIST",style:TextStyle(color:Color.fromRGBO(30,30,50,1),fontSize: 16,fontWeight:FontWeight.bold)),
                    SizedBox(width: 24,),
                    Container(
                      padding:EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        color:Color.fromRGBO(255, 234,246, 1),
                      ),
                      child: StreamProvider<List<Orders>?>.value(
                  value:DatabaseService(user?.uid, user?.email,"").getPendingOrders,
                  initialData: null,
                  child: PendingOrdersCount(darkFont:true))
                      )
                  ]
                ),
            
          GridView.builder(
            physics:  const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, 
            crossAxisSpacing:12,
            mainAxisSpacing: 12,
            mainAxisExtent:150),
            itemCount: (order==null)? 0: order.length,
            itemBuilder: (_,index) 
            {
              return OrderTile(order:order?[index],showOrderDetails:widget.showOrderDetails);
            }
            
          ),
        ],
      ),
    );
  }
    
  }
  class OrderTile extends StatefulWidget {
    final Orders? order;
    final Function showOrderDetails;
  const OrderTile({super.key, required this.order,required this.showOrderDetails});

  @override
  State<OrderTile> createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile> {
  @override
  Widget build(BuildContext context) {
    
    return  InkWell(
      onTap:(){widget.showOrderDetails();},
      child: SizedBox(
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
                decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top:Radius.circular(8)),
                gradient:LinearGradient(
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
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.vertical(bottom:Radius.circular(8)),
                ),
                padding:const EdgeInsets.all(8),
                child:  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          const Text("Total",style:TextStyle(color:Color.fromARGB(224, 27, 26, 26),fontSize: 12)),
                          
                          StreamProvider<OrderModel?>.value(
                          value:FetchOrderFromCustomer(widget.order?.orderId,widget.order?.customerId).getOrders,
                          initialData: null,
                          child:const OrderModelValue(val:"total")),
                           
                        ]
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          const Text("Location",style:TextStyle(color:Color.fromARGB(224, 27, 26, 26),fontSize: 12)),
                          
                          StreamProvider<OrderModel?>.value(
                          value:FetchOrderFromCustomer(widget.order?.orderId,widget.order?.customerId).getOrders,
                          initialData: null,
                          child:const OrderModelValue(val:"loc")),
                           
                        ]
                      ),
                      const Divider(),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          Text("Tap to view",style:TextStyle(color:Color.fromARGB(224, 27, 26, 26),fontSize: 12)),
                          
                         
                        ]
                      ),
                       
                    ],
                  ),
                
              ),
            ],
          ),
        ),
    );
    
  }
}
class CustomerModel extends StatelessWidget {
  const CustomerModel({super.key});

  @override
  Widget build(BuildContext context) {
    final customer = Provider.of<UserData?>(context);
    return Text("${customer?.fn} ${customer?.ln}",style:const TextStyle(color:Colors.white,fontSize: 12,));
  }
}
class OrderModelValue extends StatelessWidget {
  final String val;
  const OrderModelValue({super.key,required this.val});

  @override
  Widget build(BuildContext context) {
    final total = Provider.of<OrderModel?>(context);
    double t=(total==null)?0:double.parse(total.total);
    String loc=(total==null)?"":total.loc;
    return Text((val=="total")?"P ${t.toStringAsFixed(2)}":loc,style:const TextStyle(color:Color.fromRGBO(20, 20, 20, 1),fontSize: 13,fontWeight: FontWeight.bold));
  }
}
