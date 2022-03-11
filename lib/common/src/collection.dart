import 'dart:collection';

class PagedCollection<T> {
  final CollectionPage<T> firstPage;

  PagedCollection({
    required this.firstPage,
  }) : _pages = [firstPage];

  int get pageSize => firstPage.size;

  final List<CollectionPage<T>> _pages;

  Future<T> operator [](int index) async {
    final pageIndex = index ~/ pageSize;
    final indexInPage = index - pageIndex * pageSize;



    if (pageIndex >= _pages.length) {
      final nextPage = _pages.last.getNext();

      _pages.add(nextPage);
    }

    return _pages[pageIndex].futureItems.then((page) => page[indexInPage]);
  }

  Stream<int> get length => _pages.last.itemsCount;
}

abstract class CollectionPage<T> {
  final int size;

  CollectionPage(this.size);

  Stream<int> get itemsCount;

  Future<UnmodifiableListView<T>> get futureItems;

  CollectionPage<T> getNext();
}
