import "package:flutter/material.dart";

class MyAppBar extends StatelessWidget  implements PreferredSizeWidget {
  final String _title;
  const MyAppBar(this._title, {super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          title: Text(
           _title,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}