
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweetncoloursadmin/category.dart';
import 'package:sweetncoloursadmin/dashmenu.dart';
import 'package:sweetncoloursadmin/drawer.dart';
import 'package:sweetncoloursadmin/models/product.dart';
import 'package:sweetncoloursadmin/orders.dart';
import 'package:sweetncoloursadmin/prod.dart';
import 'package:sweetncoloursadmin/prodauth/addcategory.dart';
import 'package:sweetncoloursadmin/prodauth/addprod.dart';
import 'package:sweetncoloursadmin/prodauth/addprodtocategory.dart';
import 'package:sweetncoloursadmin/shared/loading.dart';
import 'package:sweetncoloursadmin/vieworderdet.dart';

import '../models/user.dart';
import '../services/database.dart';
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool showOrders=false;
  String? order_id;
  String? customer_id;
  List<bool> showWidgets=[false,false,false,true];
  // ignore: non_constant_identifier_names
  String? cat_title="All";
  String? selectedCAtegory="All";
  
  void showOrderDetails()
  {
    setState(() {
      showOrders=!showOrders;
    });
  }
  void setCatTitle(String? cat)
  {
    setState(() {
      cat_title=cat;
      selectedCAtegory=cat;
    });
  }
 void getOrderDetails(String? order_id, String?  customer_id)
 {
    setState(() {
      this.order_id=order_id;
      this.customer_id=customer_id;
      print(this.order_id);
      print(this.customer_id);
    });
 }
  void showPanel(int index)
  {
          setState(() {
            showWidgets[index]=true;
          });
          for(int i=0; i<showWidgets.length; i++)
          {
            if(i!=index)
            {
              showWidgets[i]=false;
              
            }
          }
          if(index<2)
          {
            showBottomSheet ();
          }
          
  }
  void showBottomSheet ()
  {
     showModalBottomSheet(context: context,
    shape:const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top:Radius.circular(15))),
     isScrollControlled: true,
     builder: (context)
    {
       if(showWidgets[0]==true && cat_title=="All")
      {
        return const AddProducts();
      } else if(showWidgets[0]==true && cat_title!="All")
      {
        return AddProductToCategory("$cat_title");
      }else if(showWidgets[1]==true)
      {
        return const AddCategory();
      }else{
        return const Loading();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserObj?>(context);
    return StreamBuilder<UserData?>(
      stream:DatabaseService(user?.uid,user?.email,null).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData)
        {
            UserData? userData=snapshot.data;
            if(userData?.accType=="admin")
            {
              return (showOrders==true)?OrderDetials(showOrderDetails:showOrderDetails,order_id: this.order_id,customer_id: this.customer_id,):Scaffold(
          //Color.fromRGBO(215,15,100, 1)
           backgroundColor:Colors.white,
          drawer:const MyDrawer(),
          appBar:  AppBar(
            elevation: 0,
            leading: Builder( builder: (BuildContext context) { return IconButton(
              onPressed:(){Scaffold.of(context).openDrawer();}, 
              icon: Icon(Icons.menu,color: Colors.grey[600],size: 20,)); }),
          
          backgroundColor:Colors.white,
          actions: <Widget>[
            IconButton(onPressed: (){}, icon: const Icon(Icons.notifications, color:Colors.white,size: 18,)),
          ],
          ),
          body:SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(children: [
              
              Padding(
                padding: const EdgeInsets.only(left:20,right:20),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, 
                  crossAxisSpacing:14,
                  mainAxisSpacing: 14,
                  mainAxisExtent:106,),
                  itemCount: 4,
                  itemBuilder: (_,index)
                  {
                    return InkWell(child: DashMenu(index:index),onTap:(){
                      if(index==0)
                      {
                        showPanel(3);
                      }else if(index==1)
                      {
                        showPanel(2);

                      }else if(index==2)
                      {

                      }else if(index==3)
                      {

                      }
                    });
                  }
                  
                ),
              ),
              
              Container(
                child: (showWidgets[2]==true)?StreamProvider<List<Orders>?>.value(
                  value:DatabaseService(user?.uid, user?.email,"").getPendingOrders,
                  initialData: null,
                  child: OrdersPanel(showOrderDetails: showOrderDetails, getOrderDetails:getOrderDetails)):Column(
                  children: [
                    const SizedBox(height: 10,),
                    StreamProvider<List<CategoryModel>?>.value(
                    value:DatabaseService(user?.uid, user?.email,null).getCategory,
                    initialData: null,
                    child:Category(showPanel,setCatTitle,selectedCAtegory),),
                    const SizedBox(height:6,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20,0,20,20),
                  child: StreamProvider<List<Products>?>.value(
                    value:DatabaseService(user?.uid, user?.email,cat_title).getProducts,
                    initialData: null,
                    child: ProdGrid(true,""))),
                  ],
                ),
              ),
              
              
              
            ],),
          ),
          floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showPanel(0);
        },
        label:const Text("+ Add Product"),
        backgroundColor: const Color.fromRGBO(132,90,254,1),
      ),
          
        );
            }else
            {
              return const Text("USer");
            }
        }else{
          return const Loading();
        }
        
      }
    );
  }
}