import 'package:fluttertask/Data/ProductDataSource.dart';
import 'package:fluttertask/Model/ProductResponse.dart';



class ProductRepository {
  final ProductDataSource _dataSource;

  ProductRepository(this._dataSource);

  Future<ProductResponse> fetchProducts() async {
    return await _dataSource.fetchProducts();
  }
}
ProductRepository inJectAuthRepoContract() {

  return ProductRepository(inJectAuthDataSource());
}


