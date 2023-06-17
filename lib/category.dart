import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweetncoloursadmin/categorylist.dart';
import 'package:sweetncoloursadmin/models/product.dart';

class Category extends StatefulWidget {
  Function showPanel;
  Function setCatTitle;
  String? selectedCAtegory;
   Category(this.showPanel,this.setCatTitle(String title),this.selectedCAtegory, {super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<List<CategoryModel>?>(context);
    return Padding(
      
                padding: const EdgeInsets.fromLTRB(6,10,20,10),
                child: Row(
                  
                  children:[
                    IconButton(onPressed: (){widget.showPanel(1);}, icon:const Icon(Icons.add_rounded, color:Color.fromRGBO(132,90,254,1) , ),),
                    Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                        TextButton(onPressed: (){ widget.setCatTitle("All");},child:Text("All" , style: TextStyle(color:(widget.selectedCAtegory=="All")?const Color.fromRGBO(132,90,254,1):Colors.grey[850]),)),
                        Container(
                          height:50,
                          padding:const EdgeInsets.all(6),
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: (categories!=null)?categories.length:0,
                            itemBuilder: (_,index)
                            {
                              if(categories!=null)
                              {
                                return CategoryList(categories[index],widget.setCatTitle,widget.selectedCAtegory);
                              }
                            },
                          ),
                        ),
                        
                      ]),
                    ),
                  ),] 
                ),
              );
  }
}