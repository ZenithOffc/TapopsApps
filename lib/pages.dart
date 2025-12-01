import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'tools/attack_tools.dart';
import 'tools/network_tools.dart';
import 'tools/music_tools.dart';
import 'tools/grafik.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final Map<String, dynamic> user;

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late VideoPlayerController _controller;
  double _dragPosition = 0.0;
  
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/banner.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
        _controller.setVolume(0.0);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A0015),
              Color(0xFF1A0025),
              Color(0xFF0A0015),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: const Center(
                  child: Column(
                    children: [
                      Text(
                        'Tapops',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFFF0040),
                          letterSpacing: 3,
                          shadows: [
                            Shadow(
                              color: Color(0xFFFF0040),
                              blurRadius: 15,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'developer @Zenithoffc',
                        style: TextStyle(
                          color: Color(0xFF888888),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                height: 280,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: const Color(0xFFFF0040), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF0040).withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(23),
                  child: _controller.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        )
                      : Container(
                          color: const Color(0xFF0A0015),
                          child: const Center(
                            child: CircularProgressIndicator(color: Color(0xFFFF0040)),
                          ),
                        ),
                ),
              ),

              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 30),
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF6A0DAD),
                      Color(0xFF8B008B),
                      Color(0xFFFF0040),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildUserInfoItem(Icons.person_rounded, 'Username:', widget.user['username'] ?? 'dinzzx1'),
                    _buildUserInfoItem(Icons.verified_user_rounded, 'Role:', widget.user['role'] ?? 'User'),
                    _buildUserInfoItem(Icons.calendar_month_rounded, 'Expired:', widget.user['expired'] ?? 'Never'),
                    _buildUserInfoItem(FontAwesomeIcons.whatsapp, 'My Sender:', widget.user['sender'] ?? '0'),
                  ],
                ),
              ),

              Container(
                height: 2,
                margin: const EdgeInsets.only(bottom: 25),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      const Color(0xFFFF0040),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFFF0040),
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: _buildQuickActions(),
              ),
              
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildQuickActions() {
    final role = widget.user['role']?.toString().toLowerCase() ?? 'user';
    final List<Widget> actions = [
      _buildActionButton(FontAwesomeIcons.whatsapp, 'WhatsApp Attack', () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AttackPage(user: widget.user)));
      }),
      _buildActionButton(FontAwesomeIcons.whatsapp, 'Sender Manager', () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => SenderManagerPage(user: widget.user)));
      }),
      _buildActionButton(Icons.analytics_rounded, 'System Analytics', () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => GrafikPage(user: widget.user)));
      }),
    ];
    
    if (role == 'owner' || role == 'admin' || role == 'reseller') {
      actions.add(_buildActionButton(Icons.person_add_rounded, 'User Manager', () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => UserManagerPage(userRole: role)));
      }));
    }
    
    return actions;
  }

  Widget _buildUserInfoItem(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFFF0040), size: 22),
          const SizedBox(width: 15),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value.replaceAll('}', ''),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A0025),
              Color(0xFF2A0035),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFFF0040).withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 15,
              spreadRadius: 1,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFF0040).withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFF0040).withOpacity(0.3)),
              ),
              child: Icon(icon, color: const Color(0xFFFF0040), size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 13,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SenderManagerPage extends StatefulWidget {
  final Map<String, dynamic> user;

  const SenderManagerPage({super.key, required this.user});

  @override
  State<SenderManagerPage> createState() => _SenderManagerPageState();
}

class _SenderManagerPageState extends State<SenderManagerPage> {
  int _currentTab = 0;
  final TextEditingController _botNumberController = TextEditingController();
  bool _isLoading = false;
  List<dynamic> _senders = [];
  String? _pairingCode;
  bool _showPairingCode = false;
  String _connectionStatus = 'Waiting for pairing...';
  Timer? _pairingTimer;

  @override
  void initState() {
    super.initState();
    _loadSenders();
  }

  @override
  void dispose() {
    _pairingTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadSenders() async {
    try {
      final response = await http.get(
        Uri.parse('http://178.128.98.124:2061/senders?username=${widget.user['username']}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _senders = data['senders'] ?? [];
        });
      }
    } catch (e) {
      print('Error loading senders: $e');
    }
  }

  Widget _buildPairingCodeSection() {
    if (!_showPairingCode || _pairingCode == null) {
      return const SizedBox();
    }

    Color statusColor = Colors.orange;
    if (_connectionStatus.contains('Connected')) {
      statusColor = Colors.green;
    } else if (_connectionStatus.contains('Error') || _connectionStatus.contains('Failed')) {
      statusColor = const Color(0xFFFF0040);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFF0040).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'WhatsApp Pairing Code',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Use this code to pair your WhatsApp account in the WhatsApp app',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFF0040).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFF0040)),
            ),
            child: Center(
              child: Text(
                _formatPairingCode(_pairingCode!),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _connectionStatus,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (!_connectionStatus.contains('Connected') && !_connectionStatus.contains('Error'))
            const LinearProgressIndicator(
              backgroundColor: Colors.black,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF0040)),
            ),
        ],
      ),
    );
  }

  String _formatPairingCode(String code) {
    if (code.length == 8) {
      return '${code.substring(0, 4)}-${code.substring(4)}';
    }
    return code;
  }

  Future<void> _addSender() async {
    if (_botNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter bot number'),
          backgroundColor: Color(0xFFFF0040),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://146.190.80.13:2188/addsender'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'botNumber': _botNumberController.text,
          'username': widget.user['username'],
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['pairingCode'] != null) {
          setState(() {
            _pairingCode = data['pairingCode'];
            _showPairingCode = true;
            _connectionStatus = 'Connecting to WhatsApp...';
          });
          _startPairingStatusCheck(_botNumberController.text);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('WhatsApp sender added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        _botNumberController.clear();
        _loadSenders();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add WhatsApp sender'),
            backgroundColor: Color(0xFFFF0040),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: const Color(0xFFFF0040),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _startPairingStatusCheck(String botNumber) {
    const checkInterval = Duration(seconds: 3);
    int checkCount = 0;
    const maxChecks = 60;

    _pairingTimer?.cancel();
    _pairingTimer = Timer.periodic(checkInterval, (Timer timer) async {
      if (checkCount >= maxChecks) {
        timer.cancel();
        if (mounted) {
          setState(() {
            _connectionStatus = 'Connection timeout. Please try again.';
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Pairing timeout. Please try again.'),
              backgroundColor: Color(0xFFFF0040),
            ),
          );
        }
        return;
      }

      try {
        final response = await http.get(
          Uri.parse('http://146.190.80.13:2188/check-session?botNumber=${Uri.encodeComponent(botNumber)}'),
        );

        if (mounted) {
          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            
            if (data['connected'] == true) {
              timer.cancel();
              setState(() {
                _connectionStatus = 'Connected Successfully!';
              });
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('WhatsApp connected successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
              
              _loadSenders();
              
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) {
                  setState(() {
                    _showPairingCode = false;
                  });
                }
              });
              
            } else if (data['connecting'] == true) {
              setState(() {
                _connectionStatus = 'Connecting to WhatsApp... (${checkCount + 1}/$maxChecks)';
              });
            } else if (data['error'] != null) {
              timer.cancel();
              setState(() {
                _connectionStatus = 'Error: ${data['error']}';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Connection error: ${data['error']}'),
                  backgroundColor: const Color(0xFFFF0040),
                ),
              );
            }
          } else {
            timer.cancel();
            setState(() {
              _connectionStatus = 'Failed to check connection status';
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to check connection status'),
                backgroundColor: Color(0xFFFF0040),
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          timer.cancel();
          setState(() {
            _connectionStatus = 'Network error: $e';
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Network error: $e'),
              backgroundColor: const Color(0xFFFF0040),
            ),
          );
        }
      }
      checkCount++;
    });
  }

  Future<void> _deleteSender(String senderId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://146.190.80.13:2188/sender/$senderId'),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sender deleted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        _loadSenders();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete sender'),
            backgroundColor: Color(0xFFFF0040),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: const Color(0xFFFF0040),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0015),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFFFF0040)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Sender Manager',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A0025),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                _buildTabButton(0, 'Add Sender'),
                _buildTabButton(1, 'My Senders'),
              ],
            ),
          ),
          Expanded(
            child: _currentTab == 0 ? _buildAddSenderTab() : _buildSendersListTab(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String text) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _currentTab == index ? const Color(0xFFFF0040) : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _currentTab == index ? Colors.white : const Color(0xFF888888),
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddSenderTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildPairingCodeSection(),
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: const Color(0x101A0025),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: const Color(0x30FFFFFF)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.6),
                  blurRadius: 30,
                  spreadRadius: 2,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              children: [
                const Row(
                  children: [
                    Icon(FontAwesomeIcons.whatsapp, color: Color(0xFFFF0040), size: 28),
                    SizedBox(width: 12),
                    Text(
                      'ADD WHATSAPP SENDER',
                      style: TextStyle(
                        color: Color(0xFFFF0040),
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                TextField(
                  controller: _botNumberController,
                  style: const TextStyle(
                    color: Colors.white, 
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Bot Number (e.g., 6281234567890)',
                    labelStyle: const TextStyle(
                      color: Color(0xFF888888),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color(0x20FFFFFF),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Color(0xFFFF0040),
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Color(0x30FFFFFF),
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.phone_android_rounded,
                      color: Color(0xFFFF0040),
                      size: 22,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _addSender,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF0040),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 8,
                      shadowColor: const Color(0xFFFF0040).withOpacity(0.5),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(FontAwesomeIcons.whatsapp, size: 20),
                              SizedBox(width: 12),
                              Text(
                                'ADD SENDER',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSendersListTab() {
    return _senders.isEmpty
        ? const Center(
            child: Text(
              'No senders found',
              style: TextStyle(
                color: Color(0xFF888888),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _senders.length,
            itemBuilder: (context, index) {
              final sender = _senders[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A0025),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color(0xFFFF0040).withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(FontAwesomeIcons.whatsapp, color: Color(0xFFFF0040), size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sender['botNumber'] ?? 'Unknown',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Status: ${sender['status'] ?? 'Unknown'}',
                            style: const TextStyle(
                              color: Color(0xFF888888),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => _deleteSender(sender['id']),
                      icon: const Icon(Icons.delete_rounded, color: Color(0xFFFF0040)),
                    ),
                  ],
                ),
              );
            },
          );
  }
}

class UserManagerPage extends StatefulWidget {
  final String userRole;

  const UserManagerPage({super.key, required this.userRole});

  @override
  State<UserManagerPage> createState() => _UserManagerPageState();
}

class _UserManagerPageState extends State<UserManagerPage> {
  int _currentTab = 0;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  String _selectedRole = '';
  bool _isLoading = false;
  List<dynamic> _users = [];

  List<String> get _availableRoles {
    switch (widget.userRole) {
      case 'owner':
        return ['admin', 'reseller', 'user'];
      case 'admin':
        return ['reseller', 'user'];
      case 'reseller':
        return ['user'];
      default:
        return [];
    }
  }

  bool _canDeleteUser(String targetUserRole) {
    switch (widget.userRole) {
      case 'owner':
        return targetUserRole != 'owner';
      case 'admin':
        return targetUserRole == 'reseller' || targetUserRole == 'user';
      case 'reseller':
        return targetUserRole == 'user';
      default:
        return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final response = await http.get(
        Uri.parse('http://146.190.80.13:2188/users'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _users = data['users'] ?? [];
        });
      }
    } catch (e) {
      print('Error loading users: $e');
    }
  }

  Future<void> _addUser() async {
    if (_usernameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _selectedRole.isEmpty ||
        _expiryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Color(0xFFFF0040),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://146.190.80.13:2188/adduser'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': _usernameController.text,
          'password': _passwordController.text,
          'role': _selectedRole,
          'expiry': _expiryController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        _usernameController.clear();
        _passwordController.clear();
        _expiryController.clear();
        setState(() {
          _selectedRole = '';
        });
        _loadUsers();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create user'),
            backgroundColor: Color(0xFFFF0040),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: const Color(0xFFFF0040),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteUser(String username, String userRole) async {
    if (!_canDeleteUser(userRole)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You do not have permission to delete this user'),
          backgroundColor: Color(0xFFFF0040),
        ),
      );
      return;
    }

    try {
      final response = await http.delete(
        Uri.parse('http://146.190.80.13:2188/user/$username'),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User deleted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        _loadUsers();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete user'),
            backgroundColor: Color(0xFFFF0040),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: const Color(0xFFFF0040),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0015),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFFFF0040)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'User Manager',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A0025),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                _buildTabButton(0, 'Add User'),
                _buildTabButton(1, 'User List'),
              ],
            ),
          ),
          Expanded(
            child: _currentTab == 0 ? _buildAddUserTab() : _buildUsersListTab(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String text) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _currentTab == index ? const Color(0xFFFF0040) : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _currentTab == index ? Colors.white : const Color(0xFF888888),
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddUserTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: const Color(0x101A0025),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: const Color(0x30FFFFFF)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.6),
                  blurRadius: 30,
                  spreadRadius: 2,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              children: [
                const Row(
                  children: [
                    Icon(Icons.person_add_rounded, color: Color(0xFFFF0040), size: 28),
                    SizedBox(width: 12),
                    Text(
                      'ADD NEW USER',
                      style: TextStyle(
                        color: Color(0xFFFF0040),
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                TextField(
                  controller: _usernameController,
                  style: const TextStyle(
                    color: Colors.white, 
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: const TextStyle(
                      color: Color(0xFF888888),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color(0x20FFFFFF),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Color(0xFFFF0040),
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Color(0x30FFFFFF),
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.person_rounded,
                      color: Color(0xFFFF0040),
                      size: 22,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(
                    color: Colors.white, 
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(
                      color: Color(0xFF888888),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color(0x20FFFFFF),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Color(0xFFFF0040),
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Color(0x30FFFFFF),
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.lock_rounded,
                      color: Color(0xFFFF0040),
                      size: 22,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0x20FFFFFF),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: const Color(0x30FFFFFF)),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedRole.isEmpty ? null : _selectedRole,
                    hint: const Text(
                      'Select Role',
                      style: TextStyle(
                        color: Color(0xFF888888),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    isExpanded: true,
                    dropdownColor: const Color(0xFF1A0025),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    items: _availableRoles.map((role) {
                      return DropdownMenuItem(
                        value: role,
                        child: Text(role.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value!;
                      });
                    },
                    underline: const SizedBox(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _expiryController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    color: Colors.white, 
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Expiry Days (1-365)',
                    labelStyle: const TextStyle(
                      color: Color(0xFF888888),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color(0x20FFFFFF),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Color(0xFFFF0040),
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Color(0x30FFFFFF),
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.calendar_month_rounded,
                      color: Color(0xFFFF0040),
                      size: 22,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _addUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF0040),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 8,
                      shadowColor: const Color(0xFFFF0040).withOpacity(0.5),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person_add_rounded, size: 20),
                              SizedBox(width: 12),
                              Text(
                                'CREATE USER',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersListTab() {
    return _users.isEmpty
        ? const Center(
            child: Text(
              'No users found',
              style: TextStyle(
                color: Color(0xFF888888),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _users.length,
            itemBuilder: (context, index) {
              final user = _users[index];
              final userRole = user['role']?.toString().toLowerCase() ?? 'user';
              final canDelete = _canDeleteUser(userRole);
              
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A0025),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color(0xFFFF0040).withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.person_rounded, color: Color(0xFFFF0040), size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user['username'] ?? 'Unknown',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Role: ${user['role'] ?? 'Unknown'} | Expired: ${user['expired'] ?? 'Unknown'}',
                            style: const TextStyle(
                              color: Color(0xFF888888),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (canDelete)
                      IconButton(
                        onPressed: () => _deleteUser(user['username'], userRole),
                        icon: const Icon(Icons.delete_rounded, color: Color(0xFFFF0040)),
                      ),
                  ],
                ),
              );
            },
          );
  }
}

class ToolsPage extends StatefulWidget {
  const ToolsPage({super.key});

  @override
  State<ToolsPage> createState() => _ToolsPageState();
}

class _ToolsPageState extends State<ToolsPage> {
  int _selectedToolIndex = 0;
  bool _isDrawerOpen = false;

  final List<Map<String, dynamic>> _tools = [
    {
      'name': 'IP TRACK',
      'icon': Icons.my_location_rounded,
      'page': const IPTrackPage(),
    },
    {
      'name': 'DDOS ATTACK',
      'icon': Icons.security_rounded,
      'page': const DDoSPage(),
    },
    {
      'name': 'MUSIC PLAYER',
      'icon': Icons.music_note_rounded,
      'page': const MusicPlayerPage(),
    },
  ];

  void _toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });
  }

  void _selectTool(int index) {
    setState(() {
      _selectedToolIndex = index;
      _isDrawerOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0015),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFF0040).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFF0040).withOpacity(0.3)),
            ),
            child: const Icon(Icons.menu_rounded, color: Color(0xFFFF0040), size: 24),
          ),
          onPressed: _toggleDrawer,
        ),
        title: const Text(
          'Premium Tools',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0A0015),
                  Color(0xFF1A0025),
                  Color(0xFF0A0015),
                ],
              ),
            ),
          ),
          
          Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: _isDrawerOpen ? 120 : 0,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF1A0025),
                      Color(0xFF2A0035),
                    ],
                  ),
                  border: Border(
                    right: BorderSide(color: const Color(0xFFFF0040).withOpacity(0.3)),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: _isDrawerOpen
                    ? ListView.builder(
                        padding: const EdgeInsets.only(top: 20),
                        itemCount: _tools.length,
                        itemBuilder: (context, index) {
                          final tool = _tools[index];
                          return GestureDetector(
                            onTap: () => _selectTool(index),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: _selectedToolIndex == index 
                                    ? const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFFFF0040),
                                          Color(0xFF8B008B),
                                        ],
                                      )
                                    : null,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: _selectedToolIndex == index 
                                      ? Colors.transparent 
                                      : const Color(0xFFFF0040).withOpacity(0.2),
                                ),
                                boxShadow: _selectedToolIndex == index
                                    ? [
                                        BoxShadow(
                                          color: const Color(0xFFFF0040).withOpacity(0.4),
                                          blurRadius: 10,
                                          spreadRadius: 1,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    tool['icon'],
                                    color: _selectedToolIndex == index ? Colors.white : const Color(0xFFFF0040),
                                    size: 24,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    tool['name'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: _selectedToolIndex == index ? Colors.white : const Color(0xFFFF0040),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : const SizedBox.shrink(),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF0A0015),
                        Color(0xFF1A0025),
                      ],
                    ),
                  ),
                  child: _tools[_selectedToolIndex]['page'],
                ),
              ),
            ],
          ),
          if (_isDrawerOpen)
            Positioned(
              left: 120,
              right: 0,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: _toggleDrawer,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}