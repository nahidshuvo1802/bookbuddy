import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/book_controller.dart';
import 'book_detail_view.dart';
import 'widgets/book_card.dart';
import 'widgets/error_widget.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  bool _showSearch = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(bookControllerProvider.notifier).fetchBooks();
    });
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchTextChanged);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(bookControllerProvider.notifier).loadMore();
    }
  }

  void _onSearchTextChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final query = _searchController.text.trim();
    ref.read(bookControllerProvider.notifier).search(query);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: _showSearch
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search books...',
                  border: InputBorder.none,
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _onSearch();
                          },
                        )
                      : null,
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _onSearch(),
              )
            : const Text('BookBuddy'),
        actions: [
          IconButton(
            icon: Icon(_showSearch ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _showSearch = !_showSearch;
                if (!_showSearch) {
                  _searchController.clear();
                  _onSearch();
                }
              });
            },
          ),
        ],
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(BookState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error.isNotEmpty && state.books.isEmpty) {
      return ErrorDisplayWidget(
        message: state.error,
        onRetry: () => ref.read(bookControllerProvider.notifier).refresh(),
      );
    }

    if (state.books.isEmpty) {
      return const ErrorDisplayWidget(message: 'No books found.');
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(bookControllerProvider.notifier).refresh(),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: state.books.length + (state.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.books.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final book = state.books[index];
          return BookCard(
            book: book,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BookDetailView(book: book),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
