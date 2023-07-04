import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweetncoloursadmin/models/product.dart';
import 'package:sweetncoloursadmin/models/user.dart';
import 'package:sweetncoloursadmin/services/database.dart';
class ProductTile extends StatelessWidget {
  
  final Products? prod;
  final bool isHome;
  // ignore: non_constant_identifier_names
  final String cat_title;
  const ProductTile(this.prod, this.isHome, this.cat_title, {super.key});
  
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserObj?>(context);
    return  Container(
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
          child: Column(
            crossAxisAlignment:CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(topLeft:Radius.circular(3.0),topRight: Radius.circular(3.0) ),
                child: Image.network("${prod?.image}",
                height:130,
                width: double.infinity,
                fit:BoxFit.cover,)),
              Padding(
                padding:const EdgeInsets.fromLTRB(8, 8, 8, 0),
                 child: Column(
                  crossAxisAlignment:CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    
                  const SizedBox(height:6),
                  RichText(
                  overflow: TextOverflow.ellipsis,
                  strutStyle: const StrutStyle(fontSize: 12.0),
                  text: TextSpan(
                      style: TextStyle(color: Colors.grey[900]),
                      text: "${prod?.name}"),
                ),
                  const SizedBox(height:6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text("₱ ${(prod==null)?0:double.parse(prod!.price).toStringAsFixed(2)}", style: const TextStyle(color:Color.fromRGBO(132,90,254,1),),),
                      (isHome==false)?IconButton(onPressed: ()async{
                                 dynamic result=await DatabaseService(null,null,cat_title).updateProductData("${user?.uid}", "${prod?.name}");
                                    if(result!=null)
                                    {
                                    }
                        }, icon:const Icon(Icons.add_rounded, color: Color.fromRGBO(215,15,100, 1),size: 18, ),)
                        :IconButton(onPressed: ()async{
                                  
                        }, icon:Icon(Icons.visibility, color:Colors.grey[700],size: 18, ),),
                    ],
                  )
                  
                  
                 ])
              ),
              
            ],
          ),
        );
  }
}