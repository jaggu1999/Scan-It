class Product{
  String proname;
  String manu;
  int count;
  Product({this.proname,this.manu,this.count});
  factory Product.fromJson(Map<String,dynamic> json){
    return Product(
      proname: json['pro_name'] as String,
      manu: json['manu_date'] as String,
      count: json['count_id'] as int,
    );
  }
}