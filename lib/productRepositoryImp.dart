import 'package:bloc_ing/productModel.dart';
import 'package:bloc_ing/productRepository.dart';

class InMemoryProductRepository implements ProductRepository {
  final List<Product> _storage = [];
  int _counter = 0;

  InMemoryProductRepository() {
    // Seed with some sample data
    _storage.addAll([
      Product(id: _nextId(), title: 'Keyboard', description: 'Mechanical keyboard', price: 69.99),
      Product(id: _nextId(), title: 'Mouse', description: 'Wireless mouse', price: 29.99),
      Product(id: _nextId(), title: 'Monitor', description: '27" 144Hz', price: 299.99),
    ]);
  }

  String _nextId() {
    _counter++;
    return _counter.toString();
  }

  // Simulate network delay
  Future<T> _withDelay<T>(T value) async {
    await Future.delayed(Duration(milliseconds: 350));
    return value;
  }

  @override
  Future<Product> create(Product product) async {
    final newProduct = product.copyWith(id: _nextId());
    _storage.insert(0, newProduct);
    return _withDelay(newProduct);
  }

  @override
  Future<void> delete(String id) async {
    _storage.removeWhere((p) => p.id == id);
    return _withDelay(null);
  }

  @override
  Future<List<Product>> fetchAll() async {
    return _withDelay(List<Product>.from(_storage));
  }

  @override
  Future<Product> update(Product product) async {
    final idx = _storage.indexWhere((p) => p.id == product.id);
    if (idx == -1) throw Exception('Product not found');
    _storage[idx] = product;
    return _withDelay(product);
  }
}

