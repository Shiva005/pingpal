import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key});

  static final List<Map<String, dynamic>> friends = [
    {
      "name": "Eleanor Pena",
      "avatar": "https://i.pravatar.cc/150?img=1",
      "lastMessage": "That's awesome!",
      "time": "20:00",
      "unreadCount": 3,
      "isOnline": true,
    },
    {
      "name": "Bessie Cooper",
      "avatar": "https://i.pravatar.cc/150?img=2",
      "lastMessage": "She usually has to ...",
      "time": "19:00",
      "unreadCount": 3,
      "isOnline": false,
    },
    {
      "name": "John Doe",
      "avatar": "https://i.pravatar.cc/150?img=3",
      "lastMessage": "She usually has to ...",
      "time": "10:00",
      "unreadCount": 0,
      "isOnline": false,
    },
    {
      "name": "David Willson",
      "avatar": "https://i.pravatar.cc/150?img=4",
      "lastMessage": "She usually has to ...",
      "time": "10:00",
      "unreadCount": 0,
      "isOnline": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.cardBackground,
        elevation: 0,
        title: const Text(
          "All Friends",
          style: TextStyle(color: AppTheme.textWhite),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: friends.length,
        itemBuilder: (context, index) {
          final friend = friends[index];
          final bool isOnline = friend["isOnline"] ?? false;

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.cardBackground, width: 1.7),
            ),
            child: Row(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    image: DecorationImage(
                      image: NetworkImage(friend["avatar"]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      friend["name"],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textGray,
                      ),
                    ),
                    Text(
                      isOnline ? "Online" : "Offline",
                      style: TextStyle(
                        fontSize: 14,
                        color: isOnline ? Colors.green : Colors.grey,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    // Open chat with this friend later
                  },
                  icon: const Icon(Icons.chat_bubble_outline, color: AppTheme.primaryBlue),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
