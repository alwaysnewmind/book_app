import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String groupName;

  const ChatScreen({super.key, required this.groupName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class ChatMessage {
  final String id;
  final String text;
  final bool isMe;
  final DateTime time;
  final String status;
  final String? replyTo;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.time,
    required this.status,
    this.replyTo,
  });
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {

  // 🎨 LUXURY COLOR SYSTEM
  static const Color bgPrimary = Color(0xFF1F1533);
  static const Color bgSecondary = Color(0xFF2A1E47);
  static const Color bgDeep = Color(0xFF140F26);

  static const Color goldPrimary = Color(0xFFF5C84C);
  static const Color goldDark = Color(0xFFE6B93E);
  static const Color goldGlow = Color(0xFFFFD76A);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFCFC8E8);
  static const Color textMuted = Color(0xFF9F96C8);

  static const Color cardFill = Color(0xFF251A3F);
  static const Color cardBorder = Color(0xFF3A2D5C);

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<ChatMessage> messages = [];
  bool isTyping = false;
  bool showScrollButton = false;
  bool isRecording = false;
  ChatMessage? replyingTo;

  late AnimationController _recordController;

  @override
  void initState() {
    super.initState();

    _recordController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat(reverse: true);

    _scrollController.addListener(() {
      if (_scrollController.offset <
          _scrollController.position.maxScrollExtent - 300) {
        if (!showScrollButton) {
          setState(() => showScrollButton = true);
        }
      } else {
        if (showScrollButton) {
          setState(() => showScrollButton = false);
        }
      }
    });

    _loadDummyMessages();
  }

  void _loadDummyMessages() {
    messages = [
      ChatMessage(
        id: "1",
        text: "Has anyone read Atomic Habits?",
        isMe: false,
        time: DateTime.now().subtract(const Duration(minutes: 5)),
        status: "seen",
      ),
      ChatMessage(
        id: "2",
        text: "Yes! It's amazing 🔥",
        isMe: true,
        time: DateTime.now().subtract(const Duration(minutes: 4)),
        status: "seen",
      ),
      ChatMessage(
        id: "3",
        text: "Any fantasy book recommendations?",
        isMe: false,
        time: DateTime.now().subtract(const Duration(minutes: 2)),
        status: "sent",
      ),
    ];
  }

  void sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: _controller.text.trim(),
      isMe: true,
      time: DateTime.now(),
      status: "sent",
      replyTo: replyingTo?.text,
    );

    setState(() {
      messages.add(newMessage);
      _controller.clear();
      replyingTo = null;
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  String _formatTime(DateTime time) {
    return "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
  }

  void _startRecording() => setState(() => isRecording = true);
  void _stopRecording() => setState(() => isRecording = false);

  @override
  void dispose() {
    _recordController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgPrimary,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [bgPrimary, bgSecondary, bgDeep],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              Expanded(child: _buildChatContainer()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Icon(Icons.arrow_back, color: textSecondary),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: goldPrimary,
              boxShadow: [
                BoxShadow(
                  color: goldGlow.withOpacity(0.3),
                  blurRadius: 15,
                )
              ],
            ),
            child: const Icon(Icons.menu_book, color: bgPrimary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Writers Hub",
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "1,248 members • 342 online",
                  style: TextStyle(
                    color: textMuted,
                    fontSize: 12,
                  ),
                )
              ],
            ),
          ),
          const Icon(Icons.call, color: goldPrimary),
          const SizedBox(width: 16),
          const Icon(Icons.more_vert, color: textSecondary),
        ],
      ),
    );
  }

  Widget _buildChatContainer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: Container(
          decoration: BoxDecoration(
            color: cardFill.withOpacity(0.95),
            borderRadius: BorderRadius.circular(35),
            border: Border.all(color: cardBorder),
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(20),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessage(messages[index]);
                  },
                ),
              ),
              if (showScrollButton) _scrollButton(),
              _inputSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    return GestureDetector(
      onLongPress: () => setState(() => replyingTo = message),
      child: Align(
        alignment:
            message.isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          constraints: const BoxConstraints(maxWidth: 280),
          decoration: BoxDecoration(
            color: message.isMe ? goldPrimary : cardFill,
            borderRadius: BorderRadius.circular(22),
            border: message.isMe
                ? null
                : Border.all(color: cardBorder),
            boxShadow: message.isMe
                ? [
                    BoxShadow(
                      color: goldGlow.withOpacity(0.3),
                      blurRadius: 20,
                    )
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (message.replyTo != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: bgPrimary.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    message.replyTo!,
                    style: const TextStyle(
                        fontSize: 12, color: textSecondary),
                  ),
                ),
              Text(
                message.text,
                style: TextStyle(
                  color: message.isMe ? bgPrimary : textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _formatTime(message.time),
                style: const TextStyle(
                  fontSize: 10,
                  color: textMuted,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _scrollButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: FloatingActionButton(
        mini: true,
        backgroundColor: goldPrimary,
        onPressed: _scrollToBottom,
        child: const Icon(Icons.arrow_downward, color: bgPrimary),
      ),
    );
  }

  Widget _inputSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onLongPressStart: (_) => _startRecording(),
            onLongPressEnd: (_) => _stopRecording(),
            child: AnimatedBuilder(
              animation: _recordController,
              builder: (context, child) {
                return Transform.scale(
                  scale: isRecording
                      ? 1 + (_recordController.value * 0.2)
                      : 1,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: goldPrimary,
                      boxShadow: [
                        BoxShadow(
                          color: goldGlow.withOpacity(0.3),
                          blurRadius: 15,
                        )
                      ],
                    ),
                    child:
                        const Icon(Icons.mic, color: bgPrimary),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: bgPrimary.withOpacity(0.6),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: cardBorder),
              ),
              child: TextField(
                controller: _controller,
                style:
                    const TextStyle(color: textSecondary),
                decoration: const InputDecoration(
                  hintText: "Type your message...",
                  hintStyle:
                      TextStyle(color: textMuted),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: sendMessage,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: goldPrimary,
                boxShadow: [
                  BoxShadow(
                    color: goldGlow.withOpacity(0.3),
                    blurRadius: 15,
                  )
                ],
              ),
              child:
                  const Icon(Icons.send, color: bgPrimary),
            ),
          ),
        ],
      ),
    );
  }
}