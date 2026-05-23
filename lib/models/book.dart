import 'package:hive/hive.dart';

class Book {
  final String id;
  final String title;
  final List<String> authors;
  final String description;
  final String thumbnail;
  final String publishedDate;

  Book({
    required this.id,
    required this.title,
    required this.authors,
    required this.description,
    required this.thumbnail,
    required this.publishedDate,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final info = json['volumeInfo'] ?? {};
    final imageLinks = info['imageLinks'] as Map<String, dynamic>? ?? {};
    String thumb = imageLinks['thumbnail'] as String? ?? '';
    if (thumb.startsWith('http:')) {
      thumb = thumb.replaceFirst('http:', 'https:');
    }
    return Book(
      id: json['id'] ?? '',
      title: info['title'] ?? 'No Title',
      authors: List<String>.from(info['authors'] ?? ['Unknown']),
      description: info['description'] ?? 'No description available.',
      thumbnail: thumb,
      publishedDate: info['publishedDate'] ?? 'N/A',
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'authors': authors,
        'description': description,
        'thumbnail': thumbnail,
        'publishedDate': publishedDate,
      };

  factory Book.fromMap(Map<dynamic, dynamic> map) => Book(
        id: map['id'] ?? '',
        title: map['title'] ?? '',
        authors: List<String>.from(map['authors'] ?? []),
        description: map['description'] ?? '',
        thumbnail: map['thumbnail'] ?? '',
        publishedDate: map['publishedDate'] ?? '',
      );
}

class BookAdapter extends TypeAdapter<Book> {
  @override
  final int typeId = 0;

  @override
  Book read(BinaryReader reader) => Book.fromMap(reader.readMap());

  @override
  void write(BinaryWriter writer, Book obj) => writer.writeMap(obj.toMap());
}
