import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class IPTrackPage extends StatefulWidget {
  const IPTrackPage({super.key});

  @override
  State<IPTrackPage> createState() => _IPTrackPageState();
}

class _IPTrackPageState extends State<IPTrackPage> {
  final TextEditingController _ipController = TextEditingController();
  bool _isLoading = false;
  String _result = '';
  Map<String, String> _ipDetails = {};

  Future<void> _trackIP() async {
    final ip = _ipController.text.isEmpty ? '8.8.8.8' : _ipController.text;

    setState(() {
      _isLoading = true;
      _result = '';
      _ipDetails.clear();
    });

    try {
      final response = await http.get(
        Uri.parse('https://ipwhois.app/json/$ip'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        if (data['success'] == true) {
          _ipDetails = {
            'IP Address': data['ip']?.toString() ?? ip,
            'City': data['city']?.toString() ?? 'Unknown',
            'Region': data['region']?.toString() ?? 'Unknown',
            'Country': '${data['country'] ?? 'Unknown'} (${data['country_code'] ?? 'N/A'})',
            'ISP': data['isp']?.toString() ?? 'Unknown',
            'Organization': data['org']?.toString() ?? 'Unknown',
            'Timezone': data['timezone']?.toString() ?? 'Unknown',
            'Coordinates': '${data['latitude'] ?? 'N/A'}, ${data['longitude'] ?? 'N/A'}',
          };
          
          setState(() {
            _result = '✅ IP tracked successfully!';
          });
        } else {
          setState(() {
            _result = '❌ ${data['message'] ?? 'Unable to track IP'}';
          });
        }
      } else {
        setState(() {
          _result = '❌ HTTP Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _result = '❌ Tracking error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
                    Icon(Icons.my_location_rounded, color: Color(0xFFFF0040), size: 24),
                    SizedBox(width: 10),
                    Text(
                      'IP Location Tracker',
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
                  controller: _ipController,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    labelText: 'Enter IP Address (optional)',
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
                    prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFFFF0040), size: 20),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _trackIP,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF0040),
                      foregroundColor: Colors.black,
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
                            child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.track_changes_rounded, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'TRACK LOCATION',
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
                if (_result.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: _result.contains('✅') 
                          ? Colors.green.withOpacity(0.15)
                          : const Color(0xFFFF0040).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _result.contains('✅') ? Colors.green : const Color(0xFFFF0040),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _result,
                          style: TextStyle(
                            color: _result.contains('✅') ? Colors.green : const Color(0xFFFF0040),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        if (_ipDetails.isNotEmpty) ...[
                          const SizedBox(height: 15),
                          const Text(
                            'Location Information:',
                            style: TextStyle(
                              color: Color(0xFFFF0040),
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ..._ipDetails.entries.map((entry) => Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 120,
                                  child: Text(
                                    '${entry.key}:',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    entry.value,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )).toList(),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}