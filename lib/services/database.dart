
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sweetncoloursadmin/models/product.dart';
import 'package:sweetncoloursadmin/models/user.dart';
class DatabaseService
{
  final String? uid;
  final String? email;
  // ignore: non_constant_identifier_names
  String? cat_title;
  DatabaseService(this.uid,this. email,this.cat_title);

  //collection reference
  final CollectionReference accountDetails =FirebaseFirestore.instance.collection('acc');
  Future updateUserData(String fn, String ln,String profile,String accType) async{
    
    return await accountDetails.doc(uid).set({
      'fn':fn,
      'ln':ln,
      'profile':profile,
      'accType':accType,
    });
  }

  //add products to database
  final CollectionReference prodDetails =FirebaseFirestore.instance.collection('products');
  Future addAndUpdateProducts(String name, String price,String img,String description,String details) async{
    return await prodDetails.doc("$uid$name").set({
      'name':name,
      'price':price,
      'image':img,
      'description':description,
      'details':details,
      'categories':['All'],
    });
  }
  Future updateProductData(String uid,String name) async
  {
    return await prodDetails.doc("$uid$name").update({'categories':FieldValue.arrayUnion(["$cat_title"])});
  }
  
  
  //add category to firebase
  final CollectionReference prodCategory =FirebaseFirestore.instance.collection('category');
  Future addAndUpdateCategory(String title) async{
    return await prodCategory.doc().set({
      'title':title,
    });
  }
  
  
  //get accounts stream
  Stream<UserData?> get userData
  {
      return accountDetails.doc(uid).snapshots().map(_userDataFromSnapshot);  
  }
  //
  UserData? _userDataFromSnapshot(DocumentSnapshot snapshot)
  {
    
    return UserData(uid, snapshot.get("fn"), snapshot.get("ln"), snapshot.get("profile"),email,snapshot.get("accType"));
  }
  //product list from snapshot
  List<Products> _productListFromSnapShot(QuerySnapshot snapshot)
  {
    return snapshot.docs.map((doc){
      
      return Products(doc.get('name'),doc.get('price'),doc.get('description'),doc.get('details'),doc.get('image'));
    }).toList();
  }
  
  //get prod stream
  Stream<List<Products>> get getProducts{
    return prodDetails.where('categories',arrayContains: "$cat_title").snapshots().map(_productListFromSnapShot);
  }
  
  //get prod stream

  //category list from snapshot
  List<CategoryModel> _categoryListFromSnapShot(QuerySnapshot snapshot)
  {
    return snapshot.docs.map((doc){
      return CategoryModel(doc.get('title'));
    }).toList();
  }
  //get category stream
  Stream<List<CategoryModel>> get getCategory{
    return prodCategory.snapshots().map(_categoryListFromSnapShot);
  }


  
  
}
class FetchOrderFromCustomer
{
  final String? status;
  final String? uid;
  final String? orderId;
  FetchOrderFromCustomer(this.orderId,this.uid,this.status);
  final CollectionReference order =FirebaseFirestore.instance.collection('order');
    OrderModel? _orderListFromCartSnapShot(DocumentSnapshot snapshot)
  {
    
      return OrderModel(snapshot.get('time'),snapshot.get('total'),snapshot.get('loc'),snapshot.get('status'),snapshot.get('uid'));
  
  }
      //get order stream
  
  Stream<OrderModel?> get getOrders{
    return order.doc(uid).collection("order").doc(orderId).snapshots().map(_orderListFromCartSnapShot);
  }
  
 
  List<Orders> _OrderctListFromSnapShot(QuerySnapshot snapshot)
  {
    return snapshot.docs.map((doc){
      
      return Orders(doc.get('customer_id'),doc.get('order_id'),doc.id);
    }).toList();
  }
    //get pendiing orders
    final CollectionReference orders =FirebaseFirestore.instance.collection('ordertoadmin');
    Stream<List<Orders>> get getOrdersFromCustomer{
        return orders.where("status",isEqualTo:status).snapshots().map(_OrderctListFromSnapShot);
      }
  
 List<OrderedProducts> _pendingOrderItemtListFromSnapShot(QuerySnapshot snapshot)
  {
    return snapshot.docs.map((doc){
      //this.name,this.price,this.description,this.details,this.image,this.qty
      return OrderedProducts(doc.get("name"),doc.get("price"),doc.get("image"),doc.get("quantity"));
    }).toList();
  }
    //get pendiing orders

    Stream<List<OrderedProducts>> get getOrdersItem{
        return order.doc(uid).collection("order").doc(orderId).collection("products").snapshots().map(_pendingOrderItemtListFromSnapShot);
      }

      

      Future updateOrderStatus(String status) async
  {
    return order.doc(uid).collection("order").doc(orderId).update({'status':"$status"});
  }
  Future updateOrderStatusInAdmin(String status) async
  {
    return orders.doc(orderId).update({'status':"$status"});
  }
  
  
  
  
}
