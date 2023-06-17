import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sweetncoloursadmin/shared/loading.dart';

import '../models/user.dart';
import '../services/database.dart';

class AddProducts extends StatefulWidget {
  const AddProducts({super.key});
  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  final _formKey=GlobalKey<FormState>();
  bool loading=false;
  String name = '';
  String price = '';
  String description = '';
  String details = '';
  String image = '';
  String error=' ';
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserObj?>(context);
    return loading? const Loading():Column(
        mainAxisSize: MainAxisSize.min,
        children:[Center(
          child: Column(
            children:[
              const SizedBox(
                    height: 40,
                  ),
                const Text("Add Product", style: TextStyle(color:Color.fromRGBO(215,15,100, 1), fontSize: 20,),),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:50,vertical:10),
                child: Form(
                key: _formKey,
                  child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10),
                        fillColor: Colors.grey[50],
                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(3))),
                      hintText:"Product name",
                    ),
                    validator: (val){
                      if(val!.isEmpty)
                      {
                          return "required";
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        name = val;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType:const TextInputType.numberWithOptions(decimal:true, signed:false,),
                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                  ],
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10),
                        fillColor: Colors.grey[50],
                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(3))),
                      hintText:"Price",
                    ),
                    validator: (val){
                      if(val!.isEmpty)
                      {
                          return "required";
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        price = val;
                      });
                    },
                  ),
                 
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    decoration: InputDecoration(
                      
                      contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                        fillColor: Colors.grey[50],
                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(3))),
                      hintText:"Details",
                    ),
                    validator: (val){
                      if(val!.isEmpty)
                      {
                          return "required";
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        details = val;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    decoration: InputDecoration(
                      
                      contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                        fillColor: Colors.grey[50],
                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(3))),
                      hintText:"Description",
                    ),
                    validator: (val){
                      if(val!.isEmpty)
                      {
                          return "required";
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        description = val;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10),
                        fillColor: Colors.grey[50],
                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(3))),
                      hintText:"Product image",
                    ),
                    validator: (val){
                      if(val!.isEmpty)
                      {
                          return "required";
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        image = val;
                      });
                    },
                  ),
                  const SizedBox(height: 20,),
                    SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(onPressed: ()async{
                          if(_formKey.currentState!.validate())
                            {
                              setState(() {
                                loading=true;
                              });
                               dynamic result=await DatabaseService(user?.uid,user?.email,null).addAndUpdateProducts(name, price, image, description,details);
                              if(result==null)
                              {
                                setState(() {
                                  error='saved';
                                  loading=false;
                                });
                              }
                            }
                      }, 
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(215,15,100, 1),),
                        padding: MaterialStateProperty.all(const EdgeInsets.only(top: 15, bottom: 15)),
                        elevation: MaterialStateProperty.all(0.0),
                        
                      ),
                      child:const Text('Proceed'),
                      
                      ),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  
                      const SizedBox(height:20),
                      Text(
                        error,
                        style: const TextStyle(
                          color:Colors.red,
                          fontSize: 14,
                        ),
                      )
                ],
                            )
                            ),
              ),] 
          ),
        ),] );
  }
}
