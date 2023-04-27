import '../src/contact.dart';

class MessageEntry {
  String content;
  String type;
  Contact contact;
  DateTime timestamp;
  MessageEntry({
    required this.content,
    required this.type,
    required this.contact,
    required this.timestamp
 });
}
