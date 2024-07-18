import '../Model/ProductResponse.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {
  String? loadingMessage ;
  ProductLoading({required this.loadingMessage});
}

class ProductSuccess extends ProductState{
  /// response
  ProductResponse response ;
  ProductSuccess({required this.response});
}

class ProductError extends ProductState {
  final String message;

  ProductError(this.message);
}
