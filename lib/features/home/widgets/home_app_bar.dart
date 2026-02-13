import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;

  const HomeAppBar({
    super.key,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: const [
          Icon(Icons.menu_book_rounded),
          SizedBox(width: 8),
          Text("Reader App"),
        ],
      ),

      // 🔥 if actions passed → use them
      // else → show default profile icon
      actions: actions ??
          [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: CircleAvatar(
                child: Icon(Icons.person),
              ),
            ),
          ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
