import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Repository/ProductRepository.dart';
import '../ViewModel/product view model.dart';

import '../ViewModel/product_state.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final ProductVM _viewModel = ProductVM(inJectAuthRepoContract());
  String _searchQuery = '';
  Map<int, bool> isFavoriteMap = {}; // Map to track favorite state for each product

  @override
  void initState() {
    super.initState();
    _viewModel.fetchProducts();
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void toggleFavorite(int productId) {
    setState(() {
      if (isFavoriteMap.containsKey(productId)) {
        isFavoriteMap[productId] = !isFavoriteMap[productId]!;
      } else {
        isFavoriteMap[productId] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: BlocProvider(
        create: (context) => _viewModel,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: _updateSearchQuery,
                      decoration: InputDecoration(
                        labelText: 'Search for Product by title',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(26.0), // Adjust the radius as needed
                          borderSide: BorderSide(
                            color: Color(0xff013967), // Set border color here
                            width: 2.0, // Set border width here
                          ),
                        ),
                        prefixIcon: Icon(Icons.search,color: Color(0xff013967),),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.shopping_cart_rounded),
                    onPressed: () {
                      // Add onPressed functionality for the cart icon
                    },
                    color: Color(0xff013967),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<ProductVM, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is ProductSuccess) {
                    var filteredProducts =
                    state.response.products?.where((product) {
                      return product.title!
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase());
                    }).toList();

                    if (filteredProducts == null || filteredProducts.isEmpty) {
                      return Center(child: Text('No products found.'));
                    }

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio:
                        0.75, // Adjust the aspect ratio as needed
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        double originalPrice = product.price ?? 0.0;
                        double discountPercentage =
                            product.discountPercentage ?? 0.0;
                        double discountedPrice = originalPrice -
                            (originalPrice * (discountPercentage / 100));

                        bool isFavorite = isFavoriteMap.containsKey(product.id) ? isFavoriteMap[product.id]! : false;

                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: Stack(
                                    children: [
                                      Image.network(
                                        product.thumbnail ?? '',
                                        fit: BoxFit.fill,
                                      ),
                                      Positioned(
                                        top: 8.0,
                                        right: 8.0,
                                        child: GestureDetector(
                                          onTap: () {
                                            toggleFavorite(product.id!);
                                          },
                                          child: Icon(
                                            isFavorite
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: isFavorite
                                                ? Color(0xff013967)
                                                : Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  product.title ?? '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  product.description ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    if (discountPercentage > 0)
                                      Text(
                                        'EGP${discountedPrice.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    Text(
                                      'EGP${originalPrice.toStringAsFixed(2)}',
                                      style: discountPercentage > 0
                                          ? TextStyle(
                                        decoration:
                                        TextDecoration.lineThrough,
                                        color: Color(0Xff0066BB),
                                      )
                                          : null,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.0),
                                buildRatingStar(product.rating ?? 0),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is ProductError) {
                    return Center(child: Text('Error: ${state.message}'));
                  } else {
                    return Center(child: Text('No products found.'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRatingStar(double rating) {
    IconData starIcon = Icons.star_border;
    Color starColor = Colors.grey;

    if (rating > 0) {
      starIcon = Icons.star;
      starColor = Colors.yellow;
    }

    return Row(
      children: [
        Text("Review(${rating})"),
        Icon(starIcon, color: starColor),
        Padding(
          padding: const EdgeInsets.only(left: 27),
          child: Icon(Icons.add_circle_outlined, color: Color(0xff013967)),
        ),
      ],
    );
  }
}
