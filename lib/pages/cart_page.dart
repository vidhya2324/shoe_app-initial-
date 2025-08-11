import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/cart_provider.dart';
import 'package:shop_app/pages/buy_pages.dart';
import 'package:shop_app/pages/home_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context).cart;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>  HomePage()),
            );
          },
        ),
      ),
      body: cart.isEmpty
          ? const Center(child: Text("Your cart is empty"))
          : ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final cartItem = cart[index];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(cartItem['imageUrl'] as String),
                  ),
                  title: Text(
                    cartItem['title'].toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  subtitle: Text('Size: ${cartItem['sizes']}'),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ✅BUY BUTTON
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BuyPage(singleItem: cartItem),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.attach_money,
                          color: Colors.green,
                        
                        ),
                      ),

                      //  DELETE BUTTON
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                  "Delete Product",
                                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.black)
                                ),
                                content: const Text(
                                  'Are you sure you want to remove the product from your cart?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'No',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Provider.of<CartProvider>(
                                        context,
                                        listen: false,
                                      ).removeProduct(cartItem);
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Product removed from cart",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                            ),
                                          ),
                                          duration: Duration(seconds: 1),
                                          backgroundColor: Color.fromRGBO(
                                            235,
                                            250,
                                            249,
                                            1,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Yes',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 232, 25, 18),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
