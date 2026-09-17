// ignore_for_file: avoid_print

import 'data.dart';
import 'models.dart';
import 'catalogue.dart';
import 'shelf_state.dart';

void main() {
  final library = Library();
  for (final json in rawBooks) {
    library.add(Book.fromJson(json));
  }
  library.open();

  print(library.report);

  final books = library.items.whereType<Book>().toList();
  final stats = statsOf(books);
  print('\n--- statsOf (record) ---');
  print('count: ${stats.count}, avg: ${stats.avgPages.toStringAsFixed(1)}');

  print('\n--- describe(ShelfState) ---');
  print(describe(Empty()));
  print(describe(Ready(books)));
  print(describe(Broken('shelf fell down')));

  print('\n--- queries ---');
  print('countryOf("Clean Code") = ${library.countryOf('Clean Code')}');
  print('countryOf("Nope")        = ${library.countryOf('Nope')}');
  print('findByTitle("Refactoring") = ${library.findByTitle('Refactoring')}');
  print('findByTitle("Nope")        = ${library.findByTitle('Nope')}');
}
