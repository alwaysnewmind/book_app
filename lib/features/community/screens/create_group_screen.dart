import 'package:flutter/material.dart';
import 'chat_screen.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFC9B6FF),
              Color(0xFF8F6BFF),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              const Expanded(child: _GroupList()),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF7B4DFF),
        onPressed: () {
          _showCreateGroupSheet(context);
        },
        child: const Icon(Icons.group_add),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            "Groups",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateGroupSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return const _CreateGroupSheet();
      },
    );
  }
}

class _GroupList extends StatelessWidget {
  const _GroupList();

  @override
  Widget build(BuildContext context) {
    final groups = [
      {
        "name": "Book Lovers",
        "members": "12 Members",
        "lastMsg": "Next week we start new novel!"
      },
      {
        "name": "Fantasy Readers",
        "members": "8 Members",
        "lastMsg": "Chapter 5 discussion tonight 🔥"
      },
      {
        "name": "Writers Hub",
        "members": "15 Members",
        "lastMsg": "Share your drafts here"
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                blurRadius: 8,
                color: Colors.black12,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 26,
                backgroundColor: Color(0xFF7B4DFF),
                child: Icon(Icons.group, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group["name"]!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      group["members"]!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      group["lastMsg"]!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ChatScreen(groupName:"name",),
                    ),
                  );
                },
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: Color(0xFF7B4DFF),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class _CreateGroupSheet extends StatelessWidget {
  const _CreateGroupSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Create New Group",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const TextField(
            decoration: InputDecoration(
              labelText: "Group Name",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          const TextField(
            decoration: InputDecoration(
              labelText: "Description",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7B4DFF),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Create Group"),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}