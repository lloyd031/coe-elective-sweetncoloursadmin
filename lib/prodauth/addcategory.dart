import 'package:flutter/material.dart';
import 'package:sweetncoloursadmin/services/database.dart';
import 'package:sweetncoloursadmin/shared/loading.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
 
  final _formKey=GlobalKey<FormState>();
  bool loading=false;
  String title = '';
  String error=' ';
  @override
  Widget build(BuildContext context) {
    return loading? const Loading():Column(
        mainAxisSize: MainAxisSize.min,
        children:[Center(
          child: Column(
            children:[
              const SizedBox(
                    height: 40,
                  ),
                const Text("Create new Category", style: TextStyle(color:Color.fromRGBO(215,15,100, 1), fontSize: 20,),),
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
                      hintText:"Title",
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
                        title = val;
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
                               dynamic result=await DatabaseService(null,null,null).addAndUpdateCategory(title);
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