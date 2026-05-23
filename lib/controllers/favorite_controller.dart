import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/book.dart';

final favoriteControllerProvider =
    StateNotifierProvider<FavoriteController, List<Book>>((ref) {
  return FavoriteController();
});

class FavoriteController extends StateNotifier<List<Book>> {
  late Box<Book> _box;

  FavoriteController() : super([]) {
    _init();
  }

  Future<void> _init() async {
    _box = Hive.box<Book>('favorites');
    state = _box.values.toList();
  }

  bool isFavorite(String id) => state.any((b) => b.id == id);

  Future<void> toggleFavorite(Book book) async {
    if (isFavorite(book.id)) {
      await _box.delete(book.id);
    } else {
      await _box.put(book.id, book);
    }
    state = _box.values.toList();
  }
}
