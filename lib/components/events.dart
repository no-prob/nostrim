import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewEvents with ChangeNotifier {
  // Idea is for this class to get the new messages and
  // notify the chatsList and the conversationLists
  // terms:
  // ChatsList - list of all the chats - Messages screen
  // ChatsEntry - an entry in the ChatsList
  // ConversationList - contains the conversation exchange of a single chat - screen (name of chat peer)
  // ConversationEntry - an entry in the ConversationList
  // ChannelsList - list of all the channels - Channels screen
  // ChannelsEntry - an entry in the ChannelsList
  // ChannelConversationList - contains the conversation exchange of a single channel - Channels screen
  // ChannelConversationEntry - an entry in the ChannelConversationList (name of the channel)
  int value = 0;

  void increment() {
    value += 1;
    notifyListeners();
  }
}

