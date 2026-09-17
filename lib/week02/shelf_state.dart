import 'models.dart';

sealed class ShelfState {}

class Empty extends ShelfState {}

class Ready extends ShelfState {
  final List<Book> books;
  Ready(this.books);
}

class Broken extends ShelfState {
  final String message;
  Broken(this.message);
}

String describe(ShelfState state) => switch (state) {
  Ready(:final books) => 'Shelf is ready with ${books.length} book(s).',
  Empty() => 'The shelf is empty.',
  Broken(:final message) => 'Shelf is broken: $message',
};

({int count, double avgPages}) statsOf(List<Book> books) {
  final count = books.length;
  final total = books.fold<int>(0, (sum, b) => sum + b.pages);
  return (count: count, avgPages: count > 0 ? total / count : 0.0);
}
