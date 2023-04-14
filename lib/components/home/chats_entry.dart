import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';

import 'package:nostrim/utils/color.dart';

class ChatsEntry extends StatelessWidget {
  const ChatsEntry({
    Key? key,
    required this.name,
    required this.picture,
    this.lastMessage,
    required this.lastTime,
    this.type = "user",
    this.sending = "İsimsiz Hesap",
    this.seeing = 0,
    this.pinned = false,
    this.mute = false,
    this.badge = "",
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  final String name;
  final ImageProvider<Object> picture;
  final String? lastMessage;
  final String? sending;
  final String lastTime;
  final String type;
  final int seeing;
  final bool pinned;
  final bool mute;
  final String badge;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Text(name),
          if (mute) SizedBox(width: 5),
          if (mute)
            Icon(
              Icons.volume_off_rounded,
              color: Colors.grey.shade400,
              size: 15,
            ),
        ],
      ),
      subtitle: type == "user"
          ? Text(lastMessage ?? "")
          : Row(
              children: [
                Text(
                  "${sending}: ",
                  style: TextStyle(color: PacificBlue),
                ),
                Text(
                  lastMessage ?? "",
                ),
              ],
            ),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (seeing == 1 || seeing == 2)
                Icon(
                  seeing == 2
                      ? Icons.done_all_rounded
                      : Icons.done_rounded,
                  color: Colors.green,
                  size: 20,
                ),
              if (seeing == 1 || seeing == 2) SizedBox(width: 10),
              Text(
                lastTime,
                style: TextStyle(color: Colors.grey.shade500),
              ),
            ],
          ),
          SizedBox(
              height: pinned && badge == ""
                  ? 10
                  : badge != ""
                      ? 5
                      : 30),
          if (badge != "")
            badges.Badge(
              badgeColor: Colors.grey.shade400,
              position: badges.BadgePosition(bottom: -3, end: 0),
              toAnimate: false,
              badgeContent: Text(
                '45',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          if (pinned && badge == "")
            Icon(Icons.push_pin_rounded, size: 20, color: Colors.grey.shade500)
        ],
      ),
      leading: SizedBox.fromSize(
        size: Size(50, 50),
        child: CircleAvatar(
          backgroundImage: picture,
          backgroundColor: Colors.grey,
        ),
      ),
      onTap: () {},
    );
  }
}
