



import 'package:flutter/material.dart';
import 'main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;
  final ScrollController _scrollController = ScrollController();
  List<Message> messages = [];
  String userName = 'User'; // Default value in case fetching fails
  bool isAnonymous = false; // Determines if the chat is anonymous

  @override
  void initState() {
    super.initState();
    _loadUserName(); // Fetch the user's name from Supabase
    _loadMessages();
    _subscribeToMessages();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Function to load the user's name from the 'profiles' table
  Future<void> _loadUserName() async {
    try {
      final user = supabase.auth.currentUser;

      if (user == null) {
        print('No user is logged in');
        return;
      }

      final response = await supabase
          .from('profiles')
          .select('name')
          .eq('id', user.id)
          .single();

      if (response != null) {
        setState(() {
          userName = response['name'] ?? 'User';
        });
      } else {
        print('User profile not found');
      }
    } catch (error) {
      print('Error fetching user name: $error');
    }
  }

  // Function to load messages from Supabase
  Future<void> _loadMessages() async {
    try {
      final List<dynamic> response = await supabase
          .from('messages')
          .select()
          .order('created_at', ascending: true);

      setState(() {
        messages = response.map((item) => Message.fromMap(item)).toList();
      });

      // Scroll to the bottom after messages are loaded
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (error) {
      print('Error fetching messages: $error');
    }
  }

  // Function to subscribe to message changes in real-time
  void _subscribeToMessages() {
    supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: true)
        .listen((List<Map<String, dynamic>> data) {
          setState(() {
            messages = data.map((item) => Message.fromMap(item)).toList();
          });

          // Scroll to the bottom when new messages arrive
          _scrollToBottom();
        });
  }

  // Function to send a message
  Future<void> _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      final newMessage = Message(
        name: isAnonymous ? 'Anonymous' : userName,
        text: _controller.text,
        isMe: true,
      );

      // Add the new message to the list immediately
      setState(() {
        messages.add(newMessage);
      });

      final newMessageMap = {
        'name': isAnonymous
            ? 'Anonymous'
            : userName, // Use "Anonymous" or user's name
        'text': _controller.text,
        'created_at': DateTime.now().toIso8601String(),
      };

      try {
        // Send the message to Supabase
        await supabase.from('messages').insert(newMessageMap).select();
        _controller.clear();

        // Scroll to the bottom after sending the message
        _scrollToBottom();
      } catch (error) {
        print('Error sending message: $error');
      }
    }
  }

  // Function to scroll to the bottom of the chat
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true; // Allows the navigation to happen
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Chat"),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/newchat.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              // Selection row for Anonymous or Identity chat
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isAnonymous = true;
                        });
                      },
                      child: Text("Chat Anonymous"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isAnonymous ? Colors.blue : Colors.grey,
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isAnonymous = false;
                        });
                      },
                      child: Text("Chat with Identity"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            !isAnonymous ? Colors.blue : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController, // Attach the ScrollController
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return MessageBubble(message: messages[index]);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                    border: Border.all(
                      color: Colors.purple,
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: "Type a message...",
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20.0),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send, color: Colors.blue),
                        onPressed: _sendMessage,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Message {
  final String name;
  final String text;
  final bool isMe;

  Message({required this.name, required this.text, required this.isMe});

  // Convert from map for Supabase data
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      name: map['name'] as String,
      text: map['text'] as String,
      isMe:
          map['name'] == currentUserEmail, // Compare with current user's email
    );
  }
}

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            message.name,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(30.0),
            color: isMe ? Colors.blue[100] : Colors.grey[200],
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                message.text,
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}