import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'providers/water_provider.dart';

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  _AIAssistantScreenState createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();
  final Box _historyBox = Hive.box('chat_history');
  final Map<String, String> _systemPrompt = {
    'role': 'system',
    'content': 'You are Hydrosmart AI, a helpful water-saving assistant for Morocco.'
  };

  List<Map<String, String>> _messages = [];
  String? _currentChatKey;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _setupInitialChat();
  }

  void _setupInitialChat() {
    setState(() {
      _messages = [
        {'role': 'assistant', 'content': 'Hello! How can I help you save water today?'}
      ];
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(0.0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  String _getDisplayDate(String timestamp) {
    final date = DateTime.parse(timestamp);
    final now = DateTime.now();
    if (date.day == now.day && date.month == now.month && date.year == now.year) {
      return "Today";
    }
    return DateFormat('yMMMd').format(date);
  }

  void _renameChat(String key) {
    final chat = _historyBox.get(key);
    final TextEditingController renameController = TextEditingController(text: chat['title']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF001529),
        title: Text("Rename Chat", style: GoogleFonts.poppins(color: Colors.white, fontSize: 18)),
        content: TextField(
          controller: renameController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "New title...",
            hintStyle: TextStyle(color: Colors.white38),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.cyanAccent)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent),
            onPressed: () {
              if (renameController.text.trim().isNotEmpty) {
                setState(() {
                  chat['title'] = renameController.text.trim();
                  _historyBox.put(key, chat);
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Save", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _deleteChat(dynamic key) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF001529),
        title: Text("Delete Chat?", style: GoogleFonts.poppins(color: Colors.white)),
        content: const Text("This conversation will be gone forever.",
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")
          ),
          TextButton(
            onPressed: () async {
              await _historyBox.delete(key);

              setState(() {
                if (_currentChatKey == key.toString()) {
                  _currentChatKey = null;
                  _messages = [
                    {'role': 'assistant', 'content': 'Chat deleted. How can I help you now?'}
                  ];
                }
              });

              if (mounted) Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }


  void _saveCurrentChat() {
    if (_messages.length <= 1) return;
    String title = DateFormat('MMM dd, h:mm a').format(DateTime.now());
    final chatData = {
      'title': _currentChatKey != null ? _historyBox.get(_currentChatKey)['title'] : title,
      'messages': _messages,
      'timestamp': DateTime.now().toIso8601String(),
    };
    _currentChatKey ??= DateTime.now().millisecondsSinceEpoch.toString();
    _historyBox.put(_currentChatKey, chatData);
  }

  void _loadChat(String key) {
    final savedChat = _historyBox.get(key);
    setState(() {
      _currentChatKey = key;
      _messages = List<Map<String, String>>.from(
          (savedChat['messages'] as List).map((m) => Map<String, String>.from(m))
      );
    });
    Navigator.pop(context);
  }

  void _startNewChat() {
    _saveCurrentChat();
    setState(() {
      _currentChatKey = null;
      _messages = [{'role': 'assistant', 'content': 'New session. How can I help?'}];
    });
    if (Scaffold.of(context).isDrawerOpen) Navigator.pop(context);
  }

  Future<void> _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;
    final userText = _controller.text;
    final waterData = Provider.of<WaterProvider>(context, listen: false);

    setState(() {
      _messages.insert(0, {"role": "user", "content": userText});
      _isLoading = true;
    });
    _controller.clear();
    _scrollToBottom();

    try {
      final apiKey = dotenv.env['GROQ_API_KEY'] ?? "";
      List<Map<String, String>> historyForAI = [
        _systemPrompt,
        {'role': 'system', 'content': 'Context: Usage ${waterData.currentUsage}L/${waterData.weeklyGoal}L.'},
        ..._messages.reversed
      ];

      final response = await http.post(
        Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
        headers: {'Authorization': 'Bearer $apiKey', 'Content-Type': 'application/json'},
        body: jsonEncode({'model': 'llama-3.3-70b-versatile', 'messages': historyForAI}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _messages.insert(0, {"role": "assistant", "content": data['choices'][0]['message']['content']});
          _isLoading = false;
        });
        _saveCurrentChat();
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: _buildChatDrawer(),
      appBar: AppBar(
        title: Text("AI Assistant", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.history_rounded, color: Colors.cyanAccent),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF0D47A1), Color(0xFF001529)], begin: Alignment.topCenter),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                reverse: true,
                itemCount: _messages.length,
                padding: const EdgeInsets.only(top: 100, bottom: 20, left: 10, right: 10),
                itemBuilder: (context, index) => _buildMessageBubble(_messages[index]),
              ),
            ),
            if (_isLoading) _buildTypingIndicator(),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildChatDrawer() {
    final allKeys = _historyBox.keys.toList().reversed.toList();

    final filteredKeys = allKeys.where((key) {
      final chat = _historyBox.get(key);
      final title = (chat['title'] ?? "").toString().toLowerCase();
      return title.contains(_searchQuery.toLowerCase());
    }).toList();

    return Drawer(
      backgroundColor: const Color(0xFF001529),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: _startNewChat,
                icon: const Icon(Icons.add, color: Colors.black),
                label: const Text("New Chat", style: TextStyle(color: Colors.black)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search chats...",
                  hintStyle: const TextStyle(color: Colors.white38),
                  prefixIcon: const Icon(Icons.search, color: Colors.white38),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white38, size: 18),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = "";
                      });
                    },
                  )
                      : null,
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const Divider(color: Colors.white24, height: 30),

            Expanded(
              child: filteredKeys.isEmpty
                  ? Center(child: Text(_searchQuery.isEmpty ? "No chats yet" : "No results found", style: const TextStyle(color: Colors.white38)))
                  : ListView.builder(
                itemCount: filteredKeys.length,
                itemBuilder: (context, index) {
                  final key = filteredKeys[index];
                  final chat = _historyBox.get(key);
                  return ListTile(
                    leading: const Icon(Icons.chat_bubble_outline, color: Colors.cyanAccent, size: 18),
                    title: Text(chat['title'] ?? "Untitled", style: const TextStyle(color: Colors.white70), maxLines: 1),
                    subtitle: Text(_getDisplayDate(chat['timestamp']), style: const TextStyle(color: Colors.white38, fontSize: 10)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.white38), onPressed: () => _renameChat(key.toString())),
                        IconButton(icon: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent), onPressed: () => _deleteChat(key.toString())),
                      ],
                    ),
                    onTap: () => _loadChat(key.toString()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, String> msg) {
    bool isAI = msg["role"] == "assistant";
    return Align(
      alignment: isAI ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isAI ? Colors.white10 : Colors.cyanAccent.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: MarkdownBody(data: msg["content"]!, styleSheet: MarkdownStyleSheet(p: GoogleFonts.poppins(color: Colors.white))),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return const Padding(padding: EdgeInsets.only(left: 20, bottom: 10), child: Text("Typing...", style: TextStyle(color: Colors.white38)));
  }

  Widget _buildInputArea() {
    return GlassmorphicContainer(
      width: double.infinity, height: 90, borderRadius: 0, blur: 20, alignment: Alignment.center, border: 0,
      linearGradient: LinearGradient(colors: [Colors.black38, Colors.black38]),
      borderGradient: const LinearGradient(colors: [Colors.transparent, Colors.transparent]),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(hintText: "Ask something...", filled: true, fillColor: Colors.white.withOpacity(0.05), border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none)),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            IconButton(icon: const Icon(Icons.send_rounded, color: Colors.cyanAccent), onPressed: _sendMessage),
          ],
        ),
      ),
    );
  }
}