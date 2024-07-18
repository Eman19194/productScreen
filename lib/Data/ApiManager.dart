import 'dart:convert';

import '../Model/ProductResponse.dart';
import 'package:http/http.dart' as http;
class ApiManager {
  ApiManager._();

  static ApiManager? _instance;

  factory ApiManager.getInstance() {
    _instance ??= ApiManager._();
    return _instance!;
  }
  Future<ProductResponse> fetchProducts() async {
    Uri url = Uri.parse('https://dummyjson.com/products');  // Corrected URI construction
    var response = await http.get(url);

    if (response.statusCode == 200) {

     var res=ProductResponse.fromJson(jsonDecode(response.body));
       return ProductResponse.fromJson(jsonDecode(response.body));


    } else {

      var errorMessage =
          ProductResponse.fromJson(jsonDecode(response.body)).products?.first.id;
      print('Error message: $errorMessage');
      throw errorMessage as Object;
    }
  }

}
