import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sweetncoloursadmin/models/product.dart';
import 'package:sweetncoloursadmin/models/user.dart';
import 'package:sweetncoloursadmin/ordercount.dart';
import 'package:sweetncoloursadmin/services/database.dart';

class OrdersPanel extends StatefulWidget {
   final String status;
  const OrdersPanel({super.key, required this.status});

  @override
  State<OrdersPanel> createState() => _OrdersPanelState();
}

class _OrdersPanelState extends State<OrdersPanel> {
   List<OrderModel?> ordercount=[];
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
                    Text("${(widget.status=="pending")?"PENDING":"APPROVED"} ORDER LIST",style:TextStyle(color:Color.fromRGBO(30,30,50,1),fontSize: 16,fontWeight:FontWeight.bold)),
                    SizedBox(width: 24,),
                    Container(
                      padding:EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        color:Color.fromRGBO(255, 234,246, 1),
                      ),
                      child: StreamProvider<List<Orders>?>.value(
                  value:FetchOrderFromCustomer(null,null,widget.status).getOrdersFromCustomer,
                  initialData: null,
                  child: OrdersCount(darkFont:true))
                      )
                  ]
                ),
            Container(
              child:(order==null)?Text(""):Column(
                children: [
                  for(int i=0; i<order.length; i++)
                  StreamProvider<OrderModel?>.value(
                            value:FetchOrderFromCustomer(order[i].orderId,order[i].customerId,"").getOrders,
                            initialData: null,
                            child:OrderTile(status:widget.status,orderdoc:order[i]),),
              
                ],
              ),
            ),
            
          
        ],
      ),
    );
  }
    
  }
  class OrderTile extends StatefulWidget {
    final Orders? orderdoc;
  final String status;
  const OrderTile({super.key,required this.status,required this.orderdoc});
 
  @override
  State<OrderTile> createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile> {
  @override
  
  Widget build(BuildContext context) {
    final order= Provider.of<OrderModel?>(context);
    return   InkWell(
      onDoubleTap: ()async{
        if(widget.status=="pending")
        {
          dynamic update=await FetchOrderFromCustomer("${order?.uid}${order?.time}",order?.uid,"").updateOrderStatus("approved");
          dynamic updateOrderStatus=await FetchOrderFromCustomer("${widget.orderdoc?.docId}",order?.uid,"").updateOrderStatusInAdmin("approved");
          
          
        if(update == null && updateOrderStatus==null)
        {
          print("approved");
        }
        }
      },
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
                      value:DatabaseService(order?.uid, null,"").userData,
                      initialData: null,
                      child:const CustomerModel())
                      ,
                       Row(
                        children: [
                          Icon(("${widget.status}"=="approved")?FontAwesomeIcons.calendar:FontAwesomeIcons.xmark,color:Color.fromRGBO(239,201,255,1),size:14),
                            SizedBox(
                                width: 8,
                              ),
                          Text(("${widget.status}"=="approved")?"${order?.time}":"",style:TextStyle(color:Color.fromRGBO(239,201,255,1),) ,),
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
                            
                            Text("P ${order?.total}"),
                             
                          ]
                        ),
                        /*const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:[
                            const Text("Location",style:TextStyle(color:Color.fromARGB(224, 27, 26, 26),fontSize: 12)),
                            
                            StreamProvider<OrderModel?>.value(
                            value:FetchOrderFromCustomer(widget.order?.orderId,widget.order?.customerId).getOrders,
                            initialData: null,
                            child:const OrderModelValue(val:"loc")),
                             
                          ]
                        ),*/
                        const Divider(),
                      StreamProvider<List<OrderedProducts>?>.value(
                      value:FetchOrderFromCustomer("${order?.uid}${order?.time}",order?.uid,"").getOrdersItem,
                      initialData: null,
                      child: OrderedItemTiles()),
                      
                      ],
                    ),
                  
                ),
              ],
            ),
          ),
    );
    
  }
}
class OrderedItemTiles extends StatefulWidget {
  const OrderedItemTiles({super.key});

  @override
  State<OrderedItemTiles> createState() => _OrderedItemTilesState();
}

class _OrderedItemTilesState extends State<OrderedItemTiles> {
  @override
  Widget build(BuildContext context) {
    final order= Provider.of<List<OrderedProducts>?>(context);
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:1, 
      crossAxisSpacing:12,
      mainAxisSpacing: 12,
      mainAxisExtent:25,),
      itemCount: (order==null)? 0: order.length,
      itemBuilder: (_,index)
      {
        return OrderedProductTile(op:order?[index]);
      }
      
    );
  }
}
class OrderedProductTile extends StatelessWidget {
  final OrderedProducts? op;
  const OrderedProductTile({super.key, required this.op});

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Text("${op?.qty} x"),
          SizedBox(width:10),
          ClipRRect(
                borderRadius: const BorderRadius.only(topLeft:Radius.circular(3.0),topRight: Radius.circular(3.0) ),
                child: Image.network("${op?.image}",
                height:25,
                width: 25,
                fit:BoxFit.cover,)),
          SizedBox(width:10),
          Text(op!.name),
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
    return Text("${customer?.fn} ${customer?.ln}",style:const TextStyle(color:Colors.white,fontSize: 12,));
  }
}

