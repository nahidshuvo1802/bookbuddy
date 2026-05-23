import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/book.dart';
import '../services/api_client.dart';
import '../services/api_url.dart';

final bookControllerProvider =
    StateNotifierProvider<BookController, BookState>((ref) {
  return BookController();
});

class BookState {
  final List<Book> books;
  final bool isLoading;
  final bool isLoadingMore;
  final String error;
  final String query;
  final int startIndex;
  final bool hasMore;

  const BookState({
    this.books = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error = '',
    this.query = 'programming',
    this.startIndex = 0,
    this.hasMore = true,
  });

  BookState copyWith({
    List<Book>? books,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    String? query,
    int? startIndex,
    bool? hasMore,
  }) {
    return BookState(
      books: books ?? this.books,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error ?? this.error,
      query: query ?? this.query,
      startIndex: startIndex ?? this.startIndex,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class BookController extends StateNotifier<BookState> {
  BookController() : super(const BookState());

  static const _pageSize = 20;

  Future<void> fetchBooks() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, error: '');
    try {
      final url = ApiUrl.volumes(state.query, 0, maxResults: _pageSize);
      final data = await ApiClient.get(url);
      final items = data['items'] as List<dynamic>? ?? [];
      final books = items.map((e) => Book.fromJson(e)).toList();
      state = state.copyWith(
        books: books,
        isLoading: false,
        startIndex: _pageSize,
        hasMore: items.length == _pageSize,
      );
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true, error: '');
    try {
      final url =
          ApiUrl.volumes(state.query, state.startIndex, maxResults: _pageSize);
      final data = await ApiClient.get(url);
      final items = data['items'] as List<dynamic>? ?? [];
      final newBooks = items.map((e) => Book.fromJson(e)).toList();
      state = state.copyWith(
        books: [...state.books, ...newBooks],
        isLoadingMore: false,
        startIndex: state.startIndex + _pageSize,
        hasMore: items.length == _pageSize,
      );
    } on ApiException catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e.message);
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(startIndex: 0, hasMore: true);
    await fetchBooks();
  }

  Future<void> search(String query) async {
    final cleanQuery = query.trim();
    final targetQuery = cleanQuery.isEmpty ? 'programming' : cleanQuery;
    if (targetQuery == state.query && state.books.isNotEmpty && state.error.isEmpty) {
      return;
    }
    state = BookState(query: targetQuery);
    await fetchBooks();
  }
}
