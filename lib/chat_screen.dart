import 'package:flutter/material.dart';
import 'groq_api_service.dart';
import 'chat_header.dart';
import 'message.dart';
import 'message_input.dart';
import 'typing_indicator.dart';

class ChatScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onToggleDarkMode;

  const ChatScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<MessageModel> _messages = [
    MessageModel(
      id: '1',
      text: "Hi there! I'm Grok, created by xAI. How can I help you today?",
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
    ),
  ];
  bool _isTyping = false;
  final ScrollController _scrollController = ScrollController();
  final GroqApiService _apiService = GroqApiService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _handleSendMessage(String text) async {
    final userMessage = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _isTyping = true;
    });

    _scrollToBottom();

    final response = await _apiService.getResponse(text);

    if (response.startsWith('API Error:') || response.startsWith('Network Error:')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isTyping = false;
      });
      return;
    }

    final botMessage = MessageModel(
      id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
      text: response,
      isUser: false,
      timestamp: DateTime.now(),
    );

    setState(() {
      _isTyping = false;
      _messages.add(botMessage);
    });

    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ChatHeader(
              botName: 'Grok',
              isDarkMode: widget.isDarkMode,
              onToggleDarkMode: widget.onToggleDarkMode,
              onBackClick: () {
                // Handle back click, e.g., Navigator.pop(context)
              },
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_isTyping && index == _messages.length) {
                    return const TypingIndicator();
                  }
                  return MessageWidget(message: _messages[index]);
                },
              ),
            ),
            MessageInput(onSendMessage: _handleSendMessage),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}