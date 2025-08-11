import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/cart_provider.dart';
import 'package:shop_app/pages/buy_pages.dart';

class ProductDetailsPage extends StatefulWidget {
  final Map<String, Object> product;
  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int? selectedSize = 0;

  void onTap() {
    if (selectedSize != 0) {
      Provider.of<CartProvider>(context, listen: false).addProduct({
        'id': widget.product['id'],
        'title': widget.product['title'],
        'price': widget.product['price'],
        'imageUrl': widget.product['imageUrl'],
        'company': widget.product['company'],
        'sizes': selectedSize,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Product Added Successfully!",
            style: TextStyle(
              color: Colors.green,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Color.fromRGBO(235, 250, 249, 1),
          duration: Duration(seconds: 1),
        ),
      );
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please! Select a Size",
            style: TextStyle(
              color: Colors.red,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Color.fromRGBO(235, 250, 249, 1),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Details"),
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        centerTitle: true,
        leading: BackButton(),
        //actions: [IconButton(onPressed: () {}, icon: BackButton())],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                Text(
                  widget.product['title'] as String,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Image.asset(
                      widget.product['imageUrl'] as String,
                      height: 250,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  width: 350,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(235, 250, 249, 1),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 16,
                  ),
                  child: Column(
                    children: [
                      Text(
                        '\$${widget.product['price'] as double}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              (widget.product['sizes'] as List<int>).length,
                          itemBuilder: (context, index) {
                            final size =
                                (widget.product['sizes'] as List<int>)[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedSize = size;
                                  });
                                },
                                child: Chip(
                                  label: Text(size.toString()),
                                  backgroundColor: selectedSize == size
                                      ? Colors.yellow
                                      : null,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          ElevatedButton.icon(
                            onPressed: onTap,
                            icon: const Icon(
                              Icons.shopping_cart,
                              color: Colors.black,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellowAccent,
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            label: const Text(
                              "Add to Cart",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // import and other code remains same...
                          ElevatedButton.icon(
                            onPressed: () {
                              if (selectedSize != 0) {
                                final singleProduct = {
                                  'id': widget.product['id'],
                                  'title': widget.product['title'],
                                  'price': widget.product['price'],
                                  'imageUrl': widget.product['imageUrl'],
                                  'company': widget.product['company'],
                                  'sizes': selectedSize,
                                };

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BuyPage(singleItem: singleProduct),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Please! Select a Size",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    backgroundColor: Color.fromRGBO(
                                      235,
                                      250,
                                      249,
                                      1,
                                    ),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.attach_money,
                              color: Colors.white,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            label: const Text(
                              "Buy Now",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}
