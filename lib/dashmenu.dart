import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sweetncoloursadmin/models/product.dart';
import 'package:sweetncoloursadmin/models/user.dart';
import 'package:sweetncoloursadmin/services/database.dart';

class DashMenu extends StatefulWidget {
  final int index;
  const DashMenu({super.key,required this.index});

  @override
  State<DashMenu> createState() => _DashMenuState();
}

class _DashMenuState extends State<DashMenu> {
  
  final buttonLabel=["Products","Pending Orders","Orders","Analytics"];
  final buttonIcon=[FontAwesomeIcons.cakeCandles,Icons.shopping_bag,FontAwesomeIcons.boxArchive,FontAwesomeIcons.chartLine];
  final  buttonColor=[
    [
      const Color.fromRGBO(132,90,254,1),
      const Color.fromRGBO(174,46,255,1),
    ],
    [
      const Color.fromRGBO(254,71,228,1),
      const Color.fromRGBO(255,137,237,1)
    ],
    [
      const Color.fromRGBO(19,188,240,1),
      const Color.fromRGBO(116,211,241,1),
    ],
    [
      const Color.fromRGBO(245,161,50,1),
      const Color.fromRGBO(239,188,123,1)
    ]
  ];
    
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserObj?>(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(14)),
        gradient:LinearGradient(
          begin: Alignment.bottomLeft,
          end:Alignment.topRight,
          colors:[buttonColor[widget.index][0],buttonColor[widget.index][1]],
        ),
       
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment:CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: 25,
            width: 25,
            decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            color:Colors.white,
          
          ),
            child: Center(child: Icon(buttonIcon[widget.index],size:14,color:buttonColor[widget.index][0]))),
          
          Column(
            crossAxisAlignment:CrossAxisAlignment.start,
            children: [
              Container(
                child: (widget.index==0)?StreamProvider<List<Products>?>.value(
                  value:DatabaseService(user?.uid, user?.email,"All").getProducts,
                  initialData: null,
                  child:const ProductsCount()): StreamProvider<List<Orders>?>.value(
                  value:DatabaseService(user?.uid, user?.email,"").getPendingOrders,
                  initialData: null,
                  child:const PendingOrdersCount()),
            
              )
              //Text(buttonLabel[widget.index],style:TextStyle(color:Colors.white,fontSize: 14,fontWeight:FontWeight.bold)),
            ],
          ),
          
          
          Text(buttonLabel[widget.index],style:const TextStyle(color:Colors.white,fontSize: 12,)),
        ],
      ),
    );
  }
}
class PendingOrdersCount extends StatelessWidget {
  const PendingOrdersCount({super.key});

  @override
  Widget build(BuildContext context) {
    final pendingorder = Provider.of<List<Orders>?>(context);
    
    return Text("${(pendingorder==null)?0:pendingorder.length}",style:const TextStyle(color:Colors.white,fontSize: 16,fontWeight:FontWeight.bold));
  }
}
class ProductsCount extends StatelessWidget {
  const ProductsCount({super.key});

  @override
  Widget build(BuildContext context) {
    final count = Provider.of<List<Products>?>(context);
    return Text("${(count==null)?0:count.length}",style:const TextStyle(color:Colors.white,fontSize: 16,fontWeight:FontWeight.bold));
  }
}