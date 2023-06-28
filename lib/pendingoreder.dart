import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/product.dart';

class PendingOrdersCount extends StatelessWidget {
  final bool darkFont;
  const PendingOrdersCount({super.key, required this.darkFont});

  @override
  Widget build(BuildContext context) {
    final pendingorder = Provider.of<List<Orders>?>(context);
    
    return Text("${(pendingorder==null)?0:pendingorder.length}",style:TextStyle(color:(darkFont==true)?Color.fromRGBO(255, 80, 164, 1):Colors.white,fontSize: 16,fontWeight:FontWeight.bold));
  }
}