import 'package:flutter/material.dart';
import 'package:shop_app/global_variables.dart';
import 'package:shop_app/widgets/product_card.dart';
import 'package:shop_app/pages/product_details_page.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final List<String> filters = [
    'All',
    'Nike',
    'Addidas',
    'Bata',
    'Auto',
    'Max',
    'VKC',
  ];

  late String selectedFilters;
  int currentPage = 0;

  // ✅ Search controller
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    selectedFilters = filters[0];

    // ✅ Listen to changes in the search field
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // ✅ FILTER BY brand + search query
    final filteredProducts = products.where((product) {
      final companyMatch =
          selectedFilters == 'All' ||
          product['company'].toString().toLowerCase() ==
              selectedFilters.toLowerCase();

      final titleMatch = product['title'].toString().toLowerCase().contains(
        searchQuery.toLowerCase(),
      );

      return companyMatch && titleMatch;
    }).toList();

    return SafeArea(
      child: Column(
        children: [
          // 🟡 Header + Search
          Container(
            height: 90,
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                const Text(
                  "Shoes \nCollection",
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Material(
                    elevation: 6,
                    borderRadius: BorderRadius.circular(20),
                    child: TextField(
                      controller: searchController, // ✅ Controller added
                      cursorWidth: 2,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: "Search Shoes...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          size: 20,
                          color: Colors.black,
                        ),
                        filled: true,
                        fillColor: Colors.white12,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 🟡 Filter Chips
          SizedBox(
            height: 100,
            child: ListView.builder(
              itemCount: filters.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final filter = filters[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedFilters = filter;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Chip(
                      backgroundColor: selectedFilters == filter
                          ? Colors.yellow
                          : const Color.fromRGBO(245, 247, 249, 1),
                      side: const BorderSide(
                        color: Color.fromRGBO(245, 247, 249, 1),
                      ),
                      label: Text(
                        filter,
                        style: const TextStyle(color: Colors.black),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // 🟡 Product list
          Expanded(
            child: size.width > 650
                ? GridView.builder(
                    itemCount: filteredProducts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2,
                        ),
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailsPage(product: product),
                            ),
                          );
                        },
                        child: ProductCard(
                          title: product['title'] as String,
                          price: product['price'] as double,
                          image: product['imageUrl'] as String,
                          backgroundColor: index.isEven
                              ? const Color.fromRGBO(216, 240, 253, 1)
                              : const Color.fromRGBO(245, 247, 249, 1),
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailsPage(product: product),
                            ),
                          );
                        },
                        child: ProductCard(
                          title: product['title'] as String,
                          price: product['price'] as double,
                          image: product['imageUrl'] as String,
                          backgroundColor: index.isEven
                              ? const Color.fromRGBO(216, 240, 253, 1)
                              : const Color.fromRGBO(245, 247, 249, 1),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
