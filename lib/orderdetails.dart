import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sweetncoloursadmin/models/product.dart';
import 'package:sweetncoloursadmin/models/user.dart';
import 'package:sweetncoloursadmin/services/database.dart';
import 'package:sweetncoloursadmin/shared/loading.dart';
class OrderDetails extends StatefulWidget {
  final Function showPanel;
  final Orders? orderDoc;
  const OrderDetails({super.key,required this.showPanel, required this.orderDoc});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  bool loading=false;
  bool updated =false;
  @override
  Widget build(BuildContext context) {
    final orderdet = Provider.of<OrderModel?>(context);
    
    return (loading==true)?Loading():  Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SafeArea(
                    child: Container(
                      padding:const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                        gradient:LinearGradient(
                          begin: Alignment.bottomLeft,
                          end:Alignment.topRight,
                          colors:[Color.fromRGBO(132,90,254,1),
                      Color.fromRGBO(174,46,255,1),],
                        ),
                       
                      ),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [InkWell(onTap:(){widget.showPanel(4);},child: const Icon(Icons.arrow_back,color:Colors.white)),
                        Text("${orderdet?.time}",style:const TextStyle(color:Color.fromRGBO(239,201,255,1),))
                        ],
                      )
                      ),
                  ),
          Expanded(
            child:SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
          
                 /* Container(
                    padding:EdgeInsets.all(6),
                    decoration:  const BoxDecoration(
                
                borderRadius: BorderRadius.all(Radius.circular(3.0)),
                boxShadow: [
                      BoxShadow(
                          offset: Offset(3, 3),
                          spreadRadius: -3,
                          blurRadius: 6,
                          color: Color.fromRGBO(0, 0, 0, 0.15),
                      ),
                  ],
                color: Colors.white,
                ),
                    child: StreamProvider<UserData?>.value(
                            value:DatabaseService(orderdet?.uid, null,"").userData,
                            initialData: null,
                            child:const CustomerProfile()),
                  ),
                  SizedBox(height: 10,),
                  */
          
                  
                 StreamProvider<List<OrderedProducts>?>.value(
                          value:FetchOrderFromCustomer("${orderdet?.uid}${orderdet?.time}",orderdet?.uid,"").getOrdersItem,
                          initialData: null,
                          child: const OrderedItemProductTiles()),
                Container(
                  height: 10,
                  color: Colors.grey[200],
                ),
                 Padding(
                  padding: EdgeInsets.only(left:20, top: 20,),
                  child: Row(
                    children: [
                       Icon(FontAwesomeIcons.truckFast,color:Colors.grey[800],size: 16,),
                                        SizedBox(width: 10,),
                      SizedBox(width: 10,),
                      Text("Delivery Details",style:const TextStyle(color:Color.fromRGBO(30,30,50,1),fontSize: 16,fontWeight:FontWeight.bold)),
                    ],
                  ),
                    
                 
                ),
                 SizedBox(height: 10,),
                 Padding(
                   padding: const EdgeInsets.only(bottom:20),
                   child: StreamProvider<UserData?>.value(
                                value:DatabaseService(orderdet?.uid, null,"").userData,
                                initialData: null,
                                child:const CustomerProfile()),
                 ),
                Container(
                  height: 10,
                  color: Colors.grey[200],
                ),
                  Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                           Icon(FontAwesomeIcons.moneyBill1Wave,color:Colors.grey[800],size: 16,),
                                            SizedBox(width: 10,),
                          SizedBox(width: 10,),
                          Text("Cash on Delivery",style:const TextStyle(color:Color.fromRGBO(30,30,50,1),fontSize: 16,fontWeight:FontWeight.bold)),
                        ],
                      ),
                      Text((orderdet!=null)?"₱ ${double.parse("${orderdet?.total}").toStringAsFixed(2)}":"",style: const TextStyle(fontWeight: FontWeight.bold)),
                      
                    ],
                  ),
                  
                ),
                Container(
                  height: 10,
                  color: Colors.grey[200],
                ),
                   
                OrderInstruction(index: "1",instruction: "Prepare the order.",),
                            OrderInstruction(index: "2",instruction: "Click the DELIVER button once done.",),
                            OrderInstruction(index: "3",instruction: "The Rider will deliver your \n  product to the customer.",),
                            OrderInstruction(index: "4",instruction: "The cutomer will recieve the order.",),
                            OrderInstruction(index: "5",instruction: "The rider will recieve the payment.",),
                ],
              )),
          ),
           
            
                
               
                    
                       
                            
                           

                        

                            InkWell(
                                            child: Container(
                                                decoration: const BoxDecoration(
                                                gradient:LinearGradient(
                                                  begin: Alignment.bottomLeft,
                                                  end:Alignment.topRight,
                                                  colors:[Color.fromRGBO(19,188,240,1),
                                                    Color.fromRGBO(116,211,241,1),],
                                                ),
                                              
                                              ),
                                              padding: EdgeInsets.all(16),
                                              
                                              child: Center(
                                                child: Text("DELIVER", style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold,letterSpacing: 1.5,),),
                                              ),
                                            ),
                                            onTap: ()async{
                                                      if(updated==false)
                                                      {
                                                         setState(() {
                                                         loading=true;
                                                       });
                                                        dynamic update=await FetchOrderFromCustomer("${orderdet?.uid}${orderdet?.time}",orderdet?.uid,"").updateOrderStatus("To Deliver");
                                                      dynamic updateOrderStatus=await FetchOrderFromCustomer("${widget.orderDoc?.docId}",orderdet?.uid,"").updateOrderStatusInAdmin("To Deliver");
                                                        if(update == null && updateOrderStatus==null)
                                                      {
                                                        setState(() {
                                                         loading=false;
                                                         updated=true;
                                                       });
                                                      }
                                                    
                                                      }  
                                            },
                                          ),
                         
                      
                
              ],
            
        
      ),
    );
  }
}
class CustomerProfile extends StatelessWidget {
  const CustomerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final customerdet = Provider.of<UserData?>(context);
    final orderdet = Provider.of<OrderModel?>(context);

    return ListTile(
      
      title:Text((customerdet!=null)?"${customerdet.fn} ${customerdet.ln}":"..."),
      subtitle:Text((customerdet!=null)?"\n${orderdet?.loc} \n  \n +62 906 6581 632":"...") ,
     
      
    );
  }
}
class OrderedItemProductTiles extends StatefulWidget {
  const OrderedItemProductTiles({super.key});

  @override
  State<OrderedItemProductTiles> createState() => _OrderedItemProductTilesState();
}

class _OrderedItemProductTilesState extends State<OrderedItemProductTiles> {
  @override
  Widget build(BuildContext context) {
    final order= Provider.of<List<OrderedProducts>?>(context);
    return (order==null)?const Text(""):Column(
      children: [
        for(int i=0; i<order.length; i++)
        ListTile(
      title:Text(order[i].name),
      subtitle:const Text("tap to view details") ,
      trailing: ClipOval(
                  child: Container(
                    color:const Color.fromRGBO(254,71,228,1),
                    width:20,
                    height:20,
                    child: Center(
                      child: Text(order[i].qty,
                      style: const TextStyle(fontSize: 12, color: Colors.white),),
                    )
                  ),
                ),
     leading: CircleAvatar(
  backgroundImage:  NetworkImage(order[i].image), // No matter how big it is, it won't overflow
),
     
    )
      ],
    );
  }
}
class OrderInstruction extends StatelessWidget {
  final String index;
  final String instruction;
  const OrderInstruction({super.key,required this.index, required this.instruction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
                                children:[
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(19,188,240,1),
                                      borderRadius: BorderRadius.all(Radius.circular(100))
                                    ),
                                    child: Center(child: Text("${index}",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold, color:Colors.white),))),
                                  SizedBox(width:10),
                                  Text("  ${instruction}"),
                                ] 
                              ),
    );
  }
}