import 'package:fluttertask/Model/ProductResponse.dart';

import 'ApiManager.dart';

class ProductDataSource{
  ApiManager apiManager;
  ProductDataSource({required this.apiManager});
  Future<ProductResponse> fetchProducts() async {
    return apiManager.fetchProducts();
  }

}
ProductDataSource inJectAuthDataSource() {
  return ProductDataSource(apiManager: ApiManager.getInstance());
}


