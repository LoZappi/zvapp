import '../models/request.dart';

class RequestsRepo {
  final List<Request> _items = [];

  // ✅ sempre pronto (niente loading infinito)
  bool get ready => true;

  List<Request> get items => List.unmodifiable(_items);

  Future<void> add(Request r) async {
    _items.add(r);
  }

  Future<void> clear() async {
    _items.clear();
  }

  Future<void> save() async {
    // Persist data - placeholder for local storage implementation
  }

  Future<void> deleteById(String id) async {
    _items.removeWhere((r) => r.id == id);
  }
}
