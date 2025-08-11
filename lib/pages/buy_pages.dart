import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/cart_provider.dart';

class BuyPage extends StatelessWidget {
  final Map<String, dynamic>? singleItem; // For direct buy

  const BuyPage({super.key, this.singleItem});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final items = singleItem != null ? [singleItem!] : cartProvider.cart;
    final totalPrice = items.fold(
      0.0,
      (sum, item) => sum + (item['price'] as double),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: items.isEmpty
            ? const Center(child: Text("No items to checkout."))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order Summary",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return ListTile(
                          leading: Image.asset(item['imageUrl'], height: 40),
                          title: Text(
                            item['title'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Size: ${item['sizes']}'),
                          trailing: Text('\$${item['price']}'),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(thickness: 1.5),
                  const SizedBox(height: 10),
                  Text(
                    'Total Items: ${items.length}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text(
                              'Confirm Order',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 23,
                                color: Colors.black,
                              ),
                            ),
                            content: const Text(
                              'Are you sure you want to place this order?',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close dialog
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Order Placed!',
                                        style: TextStyle(
                                          color: Colors.green,
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
                                    ),
                                  );
                                  if (singleItem == null) {
                                    cartProvider.clearCart();
                                  }
                                  Navigator.pop(context, true); // Close BuyPage
                                },
                                child: const Text(
                                  'Confirm',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Confirm & Pay',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
