import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:task212/model/post_product_model.dart';
import 'package:task212/model/product_model.dart';
import 'package:http/http.dart' as http;

class DemoPage extends StatefulWidget {
  const DemoPage({Key? key}) : super(key: key);

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  // controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  var offlineData = [];

  String url = "http://10.0.2.2:8000/api/products";

  // post request method
  Future<void> makePostRequestOffline(PostProduct product) async {
    final json = {
      'name': product.name,
      'category': product.category,
      'quantity': product.quantity,
    };
    final response = await http.post(Uri.parse(url), body: json);
    print('Status code: ${response.statusCode}');
    print('Body: ${response.body}');
  }

// get request method
  Future<List<Product>> getRequest() async {
    //replace your restFull API here.

    final response = await http.get(Uri.parse(url));

    var responseData = json.decode(response.body);
    print(responseData);

    //Creating a list to store input data;
    List<Product> products = [];
    for (var singleProduct in responseData["data"]) {
      Product product = Product(
        id: singleProduct["id"],
        name: singleProduct["name"],
        category: singleProduct["category"],
        quantity: singleProduct["quantity"],
      );

      //Adding product to the list.
      products.add(product);
    }
    return products;
  }

  // post request method
  Future<void> makePostRequest(
      {String? name, String? category, String? quantity}) async {
    final json = {
      'name': name,
      'category': category,
      'quantity': quantity,
    };
    final response = await http.post(Uri.parse(url), body: json);
    print('Status code: ${response.statusCode}');
    print('Body: ${response.body}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: AlertDialog(
                    title: const Text('Add new Product'),
                    actions: [
                      TextField(
                        controller: nameController,
                        decoration:
                            const InputDecoration(hintText: 'Enter name'),
                      ),
                      TextField(
                        controller: categoryController,
                        decoration:
                            const InputDecoration(hintText: 'Enter Category'),
                      ),
                      TextField(
                        controller: quantityController,
                        decoration:
                            const InputDecoration(hintText: 'Enter Quantity'),
                        keyboardType: TextInputType.number,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                              onPressed: () async {
                                bool internetConnected =
                                    await InternetConnectionChecker()
                                        .hasConnection;
                                if (internetConnected == true) {
                                  setState(() {
                                    print("internet connected");
                                    makePostRequest(
                                            name: nameController.text,
                                            category: categoryController.text,
                                            quantity: quantityController.text)
                                        .then((value) {
                                      return Navigator.of(context).pop();
                                    }).then((value) => setState(() {
                                              getRequest();
                                            }));
                                  });
                                } else {
                                  print("internet Not connected");

                                  var offlineProduct = PostProduct.fromJson({
                                    'name': nameController.text,
                                    'category': categoryController.text,
                                    'quantity': quantityController.text
                                  });

                                  offlineData ?? [];
                                  offlineData.add(offlineProduct);
                                  print("offline product $offlineProduct");
                                  print("offline data $offlineData");
                                  Navigator.of(context).pop();
                                }
                              },
                              child: const Text(
                                "Save",
                                style: TextStyle(color: Colors.white),
                              )),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(color: Colors.red),
                              ))
                        ],
                      )
                    ],
                  ),
                );
              },
            );
          },
          backgroundColor: Colors.white,
          child: const Icon(Icons.add)),
      appBar: AppBar(
        title: const Text('Blog'),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: FutureBuilder(
          future: getRequest(),
          builder: (BuildContext ctx, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (ctx, index) => ListTile(
                  title: Text(snapshot.data[index].name),
                  subtitle: Text(snapshot.data[index].category),
                  trailing: CircleAvatar(
                    backgroundColor: Colors.white70,
                    radius: 20,
                    child: Text(snapshot.data[index].quantity.toString()),
                  ),
                  contentPadding: const EdgeInsets.only(bottom: 5.0),
                ),
              );
            }
          },
        ),
      ),
      bottomSheet: !offlineData.isEmpty
          ? GestureDetector(
              onTap: () async {
                bool internetConnected =
                    await InternetConnectionChecker().hasConnection;

                setState(() {
                  if (internetConnected == true) {
                    // for (int i = 0; i == offlineData.length; i++)
                      makePostRequestOffline(offlineData[0]).then((value) {
                        print("we are done here");
                        offlineData = [];
                      });
                  }
                });
              },
              child: Container(
                  width: double.infinity,
                  height: 60,
                  color: Colors.red,
                  child: Center(
                    child: Text("upload offline Data"),
                  )),
            )
          : Container(
              height: 1,
            ),
    );
  }
}
