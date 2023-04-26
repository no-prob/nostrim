import '../src/contact.dart';

class MessageEntry {
  String messageContent;
  String messageType;
  Contact? peer;
  DateTime? timestamp;
  MessageEntry({required this.messageContent, required this.messageType});
}
