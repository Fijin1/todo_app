import 'package:flutter_riverpod/flutter_riverpod.dart';

class Quote {
  final String text;
  final String author;
  final String authorImage;

  Quote({
    required this.text,
    required this.author,
    required this.authorImage,
  });
}

final quoteProvider = Provider<Quote>((ref) {
  return Quote(
    text: 'The memories is a shield and life helper.',
    author: 'Samira Al-Beyrouth',
    authorImage:
        'https://example.com/profile.jpg', // Replace with actual image URL
  );
});
