import 'models.dart';

class Library {
  final List<LibraryItem> items = [];
  late final DateTime openedAt;
  String? _cachedReport;

  void add(LibraryItem item) => items.add(item);

  void open() {
    openedAt = DateTime.now();
  }

  Book? findByTitle(String title) {
    for (final item in items) {
      if (item is Book && item.title == title) return item;
    }
    return null;
  }

  String countryOf(String title) =>
      findByTitle(title)?.author.country ?? 'unknown';

  List<String> get allTitles => items.map((item) => item.title).toList();

  List<Book> get booksAfter2010 =>
      items.whereType<Book>().where((b) => b.year > 2010).toList();

  // fold, а не reduce: reduce падает на пустом списке, fold — нет.
  double get averagePages {
    final books = items.whereType<Book>().toList();
    if (books.isEmpty) return 0;
    final total = books.fold<int>(0, (sum, b) => sum + b.pages);
    return total / books.length;
  }

  Map<String, int> get authorCounts =>
      items.whereType<Book>().fold<Map<String, int>>(
        {},
        (map, b) => map..update(b.author.name, (v) => v + 1, ifAbsent: () => 1),
      );

  Set<String> get authorNames =>
      items.whereType<Book>().map((b) => b.author.name).toSet();

  Set<Genre> get genres => items.whereType<Book>().map((b) => b.genre).toSet();

  String get report => _cachedReport ??= _buildReport();

  String _buildReport() {
    final books = items.whereType<Book>().toList();
    final displayList = <String>[
      'CATALOGUE',
      for (final b in books) '${b.title} (${b.year})',
      ...authorNames,
      if (books.any((b) => b.pages == 0)) '(incomplete data)',
    ];

    return '''
Titles: $allTitles
Books after 2010: ${booksAfter2010.map((b) => b.title).join(', ')}
Average pages: ${averagePages.toStringAsFixed(1)}
Author counts: $authorCounts
Author names: $authorNames
Genres: $genres
---
${displayList.join('\n')}
''';
  }
}
