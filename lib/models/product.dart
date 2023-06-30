class Products{
  final String name;
  final String price;
  final String description;
   final String details;
  final String image;
  Products(this.name,this.price,this.description,this.details,this.image,);
  
}
class OrderedProducts{
  final String name;
  final String price;
  final String image;
  final String qty;
 OrderedProducts(this.name,this.price,this.image,this.qty);
  
}

class CategoryModel{
  final String? title;
  CategoryModel(this.title);
}

class ProductFromCategoryModel{
  // ignore: non_constant_identifier_names
  final String? prod_id;
  ProductFromCategoryModel(this.prod_id);
}
class Orders
{
  final String? customerId;
  final String? orderId;
  Orders(this.customerId,this.orderId);
}
class OrderModel{
  final String  time;
  final String total;
  final String loc;
  final String status;
  final String uid;
  OrderModel(this.time,this.total,this.loc,this.status,this.uid);
}
/**
 * 
 * class OrderItemsModel{
  final String id;
  final String loc;
  final String status;
  final String  time;
  final String total;
  OrderItemsModel(this.id,this.loc,this.status,this.time,this.total);
}
 */
