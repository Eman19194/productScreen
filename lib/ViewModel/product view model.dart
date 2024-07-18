import 'package:bloc/bloc.dart';
import 'package:fluttertask/Model/ProductResponse.dart';
import 'package:fluttertask/ViewModel/product_state.dart';

import '../Repository/ProductRepository.dart';

class ProductVM extends Cubit<ProductState> {
  final ProductRepository _repository;

  ProductVM(this._repository) : super(ProductInitial());

  Future<ProductResponse> fetchProducts() async {
    try {
      emit(ProductLoading(loadingMessage: "Loading..."));
      var response = await _repository.fetchProducts();

      if (response.products!.isEmpty) {
        emit(ProductError('Empty response'));
      } else {
        emit(ProductSuccess(response: response));
        print("VMMMM>>>>>>>${response.products?.first.description}");
      }
      return response;
    } catch (e) {
      emit(ProductError('Error fetching products: $e'));
      throw Exception('Failed to fetch products: $e');
    }
  }
}
