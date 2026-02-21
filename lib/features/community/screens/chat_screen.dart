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
  final String status; // sent, seen
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
        AnimationController(vsync: this, duration: Duration(seconds: 1))
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
        time: DateTime.now().subtract(Duration(minutes: 5)),
        status: "seen",
      ),
      ChatMessage(
        id: "2",
        text: "Yes! It's amazing 🔥",
        isMe: true,
        time: DateTime.now().subtract(Duration(minutes: 4)),
        status: "seen",
      ),
      ChatMessage(
        id: "3",
        text: "Any fantasy book recommendations?",
        isMe: false,
        time: DateTime.now().subtract(Duration(minutes: 2)),
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
    Future.delayed(Duration(milliseconds: 200), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  String _formatTime(DateTime time) {
    return "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
  }

  void _startRecording() {
    setState(() => isRecording = true);
  }

  void _stopRecording() {
    setState(() => isRecording = false);
  }

  @override
  void dispose() {
    _recordController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF7B4DFF),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 15),
            Expanded(child: _buildGlassChat()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Icon(Icons.arrow_back, color: Colors.white),
          SizedBox(width: 15),
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.menu_book, color: Color(0xFF7B4DFF)),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.groupName,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                Text("1,248 members • 342 online",
                    style: TextStyle(color: Colors.white70, fontSize: 12))
              ],
            ),
          ),
          Icon(Icons.call, color: Colors.white),
          SizedBox(width: 15),
          Icon(Icons.more_vert, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildGlassChat() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.all(20),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return _buildMessage(messages[index]);
                    },
                  ),
                ),
                if (isTyping) _typingIndicator(),
                if (showScrollButton) _scrollButton(),
                _inputSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    return GestureDetector(
      onLongPress: () {
        setState(() => replyingTo = message);
      },
      child: Align(
        alignment:
            message.isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 6),
          padding: EdgeInsets.all(12),
          constraints: BoxConstraints(maxWidth: 280),
          decoration: BoxDecoration(
            gradient: message.isMe
                ? LinearGradient(
                    colors: [Color(0xFF8F6BFF), Color(0xFF6A4DFF)])
                : null,
            color: message.isMe ? null : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (message.replyTo != null)
                Container(
                  padding: EdgeInsets.all(6),
                  margin: EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    message.replyTo!,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              Text(
                message.text,
                style: TextStyle(
                    color:
                        message.isMe ? Colors.white : Colors.black87),
              ),
              SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatTime(message.time),
                    style: TextStyle(
                        fontSize: 10,
                        color: message.isMe
                            ? Colors.white70
                            : Colors.black54),
                  ),
                  SizedBox(width: 4),
                  if (message.isMe)
                    Icon(
                      message.status == "seen"
                          ? Icons.done_all
                          : Icons.check,
                      size: 14,
                      color: Colors.white70,
                    )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _typingIndicator() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          CircularProgressIndicator(strokeWidth: 2),
          SizedBox(width: 10),
          Text("Someone is typing...")
        ],
      ),
    );
  }

  Widget _scrollButton() {
    return FloatingActionButton(
      mini: true,
      backgroundColor: Color(0xFF7B4DFF),
      onPressed: _scrollToBottom,
      child: Icon(Icons.arrow_downward),
    );
  }

  Widget _inputSection() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          if (replyingTo != null)
            Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(child: Text(replyingTo!.text)),
                  GestureDetector(
                    onTap: () => setState(() => replyingTo = null),
                    child: Icon(Icons.close),
                  )
                ],
              ),
            ),
          Row(
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
                      child: CircleAvatar(
                        backgroundColor: isRecording
                            ? Colors.red
                            : Color(0xFF7B4DFF),
                        child: Icon(Icons.mic, color: Colors.white),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                        hintText: "Write a message...",
                        border: InputBorder.none),
                  ),
                ),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: sendMessage,
                child: CircleAvatar(
                  backgroundColor: Color(0xFF7B4DFF),
                  child: Icon(Icons.send, color: Colors.white),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}