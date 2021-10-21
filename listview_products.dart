import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class MyApp6 extends StatelessWidget {
  const MyApp6({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:HomePage6(),
    );
  }
}

class HomePage6 extends StatefulWidget {
  const HomePage6({Key? key}) : super(key: key);

  @override
  _HomePage6State createState() => _HomePage6State();
}

class _HomePage6State extends State<HomePage6> {

  late Future<List<Product>> lsProducts;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lsProducts = Product.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Shop Flutter"),),
      body: FutureBuilder(
        future: lsProducts,
        builder:(BuildContext context,
            AsyncSnapshot<dynamic> snapshot){
          if(snapshot.hasData){
            List<Product> data = snapshot.data;
            return ListView.builder(
                itemCount:data.length,
                itemBuilder:(context,index){
                  var product = data[index];
                  return ListTile(
                      leading:Image.network(product.image),
                      title: Text(product.title,style: TextStyle(color: Colors.blueGrey),),
                      subtitle: Text(product.price.toString()+"-\$".toString(),style: TextStyle(color: Colors.red),),
                      trailing: IconButton(onPressed: () => showBox(context),
                        color: Colors.red,
                        padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                        icon: Icon(Icons.add_shopping_cart_outlined)),
                  );
                });
          }
          else
            return Center(child: CircularProgressIndicator());
        },
      ),

    );
  }
}
showBox(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Nhập số lượng mua:'),
        content: TextField(
          onChanged: (value) { },
          decoration: InputDecoration(hintText: "Số lượng"),
        ),
        actions: <Widget>[
          TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel', style: TextStyle(color:Colors.red),),
          ),
          TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK',),
          ),
        ],
      );
    },
  );
}



class Rating{
  final double rate;
  final int count;

  Rating(this.rate, this.count);

}
class Product{
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Map rating;

  Product(this.id, this.title, this.price, this.description, this.category, this.image,this.rating);


  static Future<List<Product>> fetchData() async {
    String url="https://fakestoreapi.com/products";
    var client = http.Client();
    var response = await client.get(Uri.parse(url));
    List<Product> lsProducts = [];
    if(response.statusCode == 200){
      var result = response.body;
      var jsonData = jsonDecode(result);
      for(var item in jsonData){
        var id =item['id'];
        var title=item['title'];
        var price=item['price'];
        var description=item['description'];
        var category = item['category'];
        var image = item['image'];
        var rating = item['rating'];
        Product p = new Product(id, title, price, description, category, image,rating);
        lsProducts.add(p);
      }
      return lsProducts;
    }else{
      print(response.statusCode);
      throw Exception("Loi lay du lieu");
    }
  }

}
