import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweetncoloursadmin/models/product.dart';
import 'package:sweetncoloursadmin/models/user.dart';
import 'package:sweetncoloursadmin/prod.dart';
import 'package:sweetncoloursadmin/services/database.dart';

class AddProductToCategory extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final String cat_title;
   const AddProductToCategory(this.cat_title, {super.key});

  @override
  State<AddProductToCategory> createState() => _AddProductToCategoryState();
}

class _AddProductToCategoryState extends State<AddProductToCategory> {
  
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserObj?>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [Center(
        child:Column(
          children: [
            const SizedBox(height: 40,),
            const Text("Select Product", style: TextStyle(color:Color.fromRGBO(215,15,100, 1), fontSize: 20,),),
            const SizedBox(height: 20,),
            SizedBox(
              height: 400,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                      padding: const EdgeInsets.fromLTRB(20,0,20,20),
                      child: StreamProvider<List<Products>?>.value(
                        value:DatabaseService(user?.uid, user?.email,"All").getProducts,
                        initialData: null,
                        child: ProdGrid(false,widget.cat_title))),
              ),
            ),

            Padding(
              padding:const EdgeInsets.all(20),
              child: SizedBox(
                          width: double.maxFinite,
                          child: ElevatedButton(onPressed: ()async{
                              
                          }, 
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(215,15,100, 1),),
                            padding: MaterialStateProperty.all(const EdgeInsets.only(top: 15, bottom: 15)),
                            elevation: MaterialStateProperty.all(0.0),
                            
                          ),
                          child:const Text('Done'),
                          
                          ),
                        ),
            ),
          ],
        )
      ),]
    );
  }
}