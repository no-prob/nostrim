import '../src/contact.dart';

class MessageEntry {
  String content;
  String type;
  Contact contact;
  DateTime timestamp;
  int index;
  MessageEntry({
    required this.content,
    required this.type,
    required this.contact,
    required this.timestamp,
    required this.index,
  });
}
