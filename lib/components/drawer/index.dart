import 'package:flutter/material.dart';

import 'drawer_list_tile.dart';
import 'drawer_user_list_tile.dart';

class DrawerScreen extends StatefulWidget {
  DrawerScreen({Key? key}) : super(key: key);

  @override
  DrawerScreenState createState() => DrawerScreenState();
}

class DrawerScreenState extends State<DrawerScreen> {
  bool showOtherUsers = false;
  int selectedUser = 0;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("ofarukbicer"),
            accountEmail: Text("npub..."),
            onDetailsPressed: () {
              setState(() {
                showOtherUsers = showOtherUsers ? false : true;
              });
            },
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://avatars.githubusercontent.com/u/75714882"),
              backgroundColor: Colors.grey.shade400,
            ),
            currentAccountPictureSize: Size(60, 60),
            otherAccountsPictures: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.dark_mode_rounded,
                  /* Icons.light_mode_rounded */
                  color: Colors.white,
                ),
              )
            ],
          ),
          if (showOtherUsers)
            DrawerUserListTile(
              name: "ofarukbicer",
              picture: "https://avatars.githubusercontent.com/u/75714882",
              selected: selectedUser == 0 ? true : false,
              onTap: () {
                setState(() {
                  selectedUser = 0;
                });
              },
            ),
          if (showOtherUsers)
            DrawerUserListTile(
              name: "keyifleroslun",
              picture:
                  "https://avatars.githubusercontent.com/u/57468649",
              selected: selectedUser == 2 ? true : false,
              onTap: () {
                setState(() {
                  selectedUser = 2;
                });
              },
            ),
          if (showOtherUsers)
            DrawerUserListTile(
              name: "New User Identity",
              icon: Icons.person_add_outlined,
              onTap: () {},
            ),
          if (showOtherUsers) Divider(),
          DrawerListTile(
            title: "Messages",
            icon: Icons.person_outline_rounded,
            onTap: () {print('messages');},
          ),
          DrawerListTile(
            title: "Channels",
            icon: Icons.people_outline_rounded,
            onTap: () {},
          ),
          DrawerListTile(
            title: "Bookmarks",
            icon: Icons.bookmark_border_rounded,
            onTap: () {},
          ),
          DrawerListTile(
            title: "Settings",
            icon: Icons.settings_outlined,
            onTap: () {},
          ),
          Divider(),
          DrawerListTile(
            title: "Invite Friends",
            icon: Icons.person_add_alt_outlined,
            onTap: () {},
          ),
          DrawerListTile(
            title: "Nostrim Features",
            icon: Icons.info_outline_rounded,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
