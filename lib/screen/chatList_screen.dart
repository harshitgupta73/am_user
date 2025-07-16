import 'package:flutter/material.dart';

import '../modals/chat_modal.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<Chat> chats = [
    Chat(
      id: '1',
      name: 'Alex Johnson',
      lastMessage: 'Hey, are we still meeting tomorrow?',
      time: '10:30 AM',
      avatarUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
      isOnline: true,
      isRead: false,
    ),
    Chat(
      id: '2',
      name: 'Sarah Williams',
      lastMessage: 'I sent you the project files',
      time: 'Yesterday',
      avatarUrl: 'https://randomuser.me/api/portraits/women/2.jpg',
      isOnline: false,
      isRead: false,
    ),
    Chat(
      id: '3',
      name: 'Michael Brown',
      lastMessage: 'Thanks for your help with the presentation!',
      time: 'Yesterday',
      avatarUrl: 'https://randomuser.me/api/portraits/men/3.jpg',
      isOnline: true,
      isRead: true,
    ),
    Chat(
      id: '4',
      name: 'Emily Davis',
      lastMessage: 'Let me know when you arrive',
      time: 'Monday',
      avatarUrl: 'https://randomuser.me/api/portraits/women/4.jpg',
      isOnline: false,
      isRead: true,
    ),
    Chat(
      id: '5',
      name: 'David Wilson',
      lastMessage: 'The meeting has been rescheduled to 3 PM',
      time: 'Sunday',
      avatarUrl: 'https://randomuser.me/api/portraits/men/5.jpg',
      isOnline: false,
      isRead: false,
    ),
    Chat(
      id: '6',
      name: 'Jessica Taylor',
      lastMessage: 'Did you see the latest updates?',
      time: 'Friday',
      avatarUrl: 'https://randomuser.me/api/portraits/women/6.jpg',
      isOnline: true,
      isRead: true,
    ),
    Chat(
      id: '7',
      name: 'Daniel Anderson',
      lastMessage: 'I need those reports by EOD',
      time: 'Thursday',
      avatarUrl: 'https://randomuser.me/api/portraits/men/7.jpg',
      isOnline: false,
      isRead: false,
    ),
  ];

  List<Chat> filteredChats = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredChats = chats; // Initialize with all chats
    _searchController.addListener(_filterChats); // Listen for changes to the search input
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter chats based on the search query
  void _filterChats() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        filteredChats = chats; // Show all chats when the query is empty
      } else {
        filteredChats = chats.where((chat) {
          return chat.name.toLowerCase().contains(query) ||
              chat.lastMessage.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search chats...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: isDarkMode
                    ? Colors.grey[800]
                    : Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
              style: TextStyle(
                color: isDarkMode ? Colors.black : Colors.black,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredChats.length,
              itemBuilder: (context, index) {
                final chat = filteredChats[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[900] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(chat.avatarUrl),
                          radius: 25,
                        ),
                        if (chat.isOnline)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isDarkMode
                                      ? Colors.grey[900]!
                                      : Colors.grey[100]!,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    title: Text(
                      chat.name,
                      style: TextStyle(
                        fontWeight: chat.isRead ? FontWeight.normal : FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      chat.lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: chat.isRead ? FontWeight.normal : FontWeight.bold,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          chat.time,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (!chat.isRead)
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: const Text(
                              '1',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                      ],
                    ),
                    onTap: () {
                      // Mark as read when tapped
                      setState(() {
                        chats = chats.map((c) => c.id == chat.id
                            ? Chat(
                          id: chat.id,
                          name: chat.name,
                          lastMessage: chat.lastMessage,
                          time: chat.time,
                          avatarUrl: chat.avatarUrl,
                          isOnline: chat.isOnline,
                          isRead: true,
                        )
                            : c).toList();
                        _filterChats();
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
