import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GrafikPage extends StatefulWidget {
  final Map<String, dynamic> user;

  const GrafikPage({super.key, required this.user});

  @override
  State<GrafikPage> createState() => _GrafikPageState();
}

class _GrafikPageState extends State<GrafikPage> {
  List<PerformanceData> _attackData = [];
  List<PerformanceData> _senderData = [];
  List<PerformanceData> _userData = [];
  List<PerformanceData> _ddosData = [];
  List<PerformanceData> _loginData = [];
  bool _isLoading = true;
  String _selectedTimeRange = 'monthly';
  String _selectedChartType = 'attack';

  @override
  void initState() {
    super.initState();
    _loadPerformanceData();
  }

  Future<void> _loadPerformanceData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final response = await http.get(
        Uri.parse('http://146.190.80.13:2188/performance-data?range=$_selectedTimeRange'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _processPerformanceData(data);
      } else {
        _generateSampleData();
      }
    } catch (e) {
      print('Error loading performance data: $e');
      _generateSampleData();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _processPerformanceData(Map<String, dynamic> data) {
    final List<PerformanceData> attackData = [];
    final List<PerformanceData> senderData = [];
    final List<PerformanceData> userData = [];
    final List<PerformanceData> ddosData = [];
    final List<PerformanceData> loginData = [];

    final monthlyData = data['monthly'] ?? {};
    
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May'];
    
    for (int i = 0; i < months.length; i++) {
      final month = months[i];
      final monthData = monthlyData[month.toLowerCase()] ?? {};
      
      attackData.add(PerformanceData(
        period: month,
        value: (monthData['attack'] ?? (100 + i * 20)).toDouble(),
      ));
      
      senderData.add(PerformanceData(
        period: month,
        value: (monthData['sender'] ?? (50 + i * 15)).toDouble(),
      ));
      
      userData.add(PerformanceData(
        period: month,
        value: (monthData['user'] ?? (30 + i * 10)).toDouble(),
      ));
      
      ddosData.add(PerformanceData(
        period: month,
        value: (monthData['ddos'] ?? (80 + i * 25)).toDouble(),
      ));
      
      loginData.add(PerformanceData(
        period: month,
        value: (monthData['login'] ?? (200 + i * 50)).toDouble(),
      ));
    }

    setState(() {
      _attackData = attackData;
      _senderData = senderData;
      _userData = userData;
      _ddosData = ddosData;
      _loginData = loginData;
    });
  }

  void _generateSampleData() {
    final List<PerformanceData> attackData = [];
    final List<PerformanceData> senderData = [];
    final List<PerformanceData> userData = [];
    final List<PerformanceData> ddosData = [];
    final List<PerformanceData> loginData = [];

    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May'];
    
    for (int i = 0; i < months.length; i++) {
      attackData.add(PerformanceData(
        period: months[i],
        value: (100 + i * 20).toDouble(),
      ));
      
      senderData.add(PerformanceData(
        period: months[i],
        value: (50 + i * 15).toDouble(),
      ));
      
      userData.add(PerformanceData(
        period: months[i],
        value: (30 + i * 10).toDouble(),
      ));
      
      ddosData.add(PerformanceData(
        period: months[i],
        value: (80 + i * 25).toDouble(),
      ));
      
      loginData.add(PerformanceData(
        period: months[i],
        value: (200 + i * 50).toDouble(),
      ));
    }

    setState(() {
      _attackData = attackData;
      _senderData = senderData;
      _userData = userData;
      _ddosData = ddosData;
      _loginData = loginData;
    });
  }

  List<PerformanceData> get _currentData {
    switch (_selectedChartType) {
      case 'attack':
        return _attackData;
      case 'sender':
        return _senderData;
      case 'user':
        return _userData;
      case 'ddos':
        return _ddosData;
      case 'login':
        return _loginData;
      default:
        return _attackData;
    }
  }

  String get _currentChartTitle {
    switch (_selectedChartType) {
      case 'attack':
        return 'WhatsApp Attack Performance';
      case 'sender':
        return 'WhatsApp Sender Performance';
      case 'user':
        return 'User Management Activity';
      case 'ddos':
        return 'DDOS Attack Performance';
      case 'login':
        return 'User Login Activity';
      default:
        return 'System Performance';
    }
  }

  Color get _currentChartColor {
    switch (_selectedChartType) {
      case 'attack':
        return const Color(0xFFFF0040);
      case 'sender':
        return const Color(0xFF00FF88);
      case 'user':
        return const Color(0xFF0088FF);
      case 'ddos':
        return const Color(0xFFFF8800);
      case 'login':
        return const Color(0xFFAA00FF);
      default:
        return const Color(0xFFFF0040);
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
          'System Analytics',
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
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A0025),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFFF0040).withOpacity(0.3)),
            ),
            child: Row(
              children: [
                _buildTimeRangeButton('daily', 'Hari'),
                const SizedBox(width: 8),
                _buildTimeRangeButton('weekly', 'Minggu'),
                const SizedBox(width: 8),
                _buildTimeRangeButton('monthly', 'Bulan'),
              ],
            ),
          ),
          
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A0025),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFFF0040).withOpacity(0.3)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildChartTypeButton('attack', 'Attack', FontAwesomeIcons.whatsapp),
                  const SizedBox(width: 8),
                  _buildChartTypeButton('sender', 'Sender', FontAwesomeIcons.whatsapp),
                  const SizedBox(width: 8),
                  _buildChartTypeButton('user', 'User', Icons.person_rounded),
                  const SizedBox(width: 8),
                  _buildChartTypeButton('ddos', 'DDOS', Icons.security_rounded),
                  const SizedBox(width: 8),
                  _buildChartTypeButton('login', 'Login', Icons.login_rounded),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFFFF0040)),
                  )
                : Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A0025),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: const Color(0xFFFF0040).withOpacity(0.3)),
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
                        Text(
                          _currentChartTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16, top: 10, bottom: 10),
                            child: LineChart(
                              LineChartData(
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false,
                                  horizontalInterval: 50,
                                  getDrawingHorizontalLine: (value) {
                                    return FlLine(
                                      color: const Color(0xFF333333).withOpacity(0.5),
                                      strokeWidth: 1,
                                    );
                                  },
                                ),
                                titlesData: FlTitlesData(
                                  show: true,
                                  rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 30,
                                      interval: 1,
                                      getTitlesWidget: (double value, TitleMeta meta) {
                                        if (value.toInt() >= 0 && value.toInt() < _currentData.length) {
                                          return Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              _currentData[value.toInt()].period,
                                              style: const TextStyle(
                                                color: Color(0xFF888888),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          );
                                        }
                                        return const Text('');
                                      },
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      interval: 50,
                                      reservedSize: 42,
                                      getTitlesWidget: (double value, TitleMeta meta) {
                                        return Text(
                                          value.toInt().toString(),
                                          style: const TextStyle(
                                            color: Color(0xFF888888),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                minX: 0,
                                maxX: (_currentData.length - 1).toDouble(),
                                minY: 0,
                                maxY: _getMaxY(),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: _currentData.asMap().entries.map((entry) {
                                      return FlSpot(entry.key.toDouble(), entry.value.value);
                                    }).toList(),
                                    isCurved: true,
                                    color: _currentChartColor,
                                    barWidth: 3,
                                    isStrokeCapRound: true,
                                    dotData: FlDotData(
                                      show: true,
                                      getDotPainter: (spot, percent, barData, index) {
                                        return FlDotCirclePainter(
                                          radius: 6,
                                          color: Colors.white,
                                          strokeWidth: 2,
                                          strokeColor: _currentChartColor,
                                        );
                                      },
                                    ),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      color: _currentChartColor.withOpacity(0.1),
                                    ),
                                  ),
                                ],
                                lineTouchData: LineTouchData(
                                  touchTooltipData: LineTouchTooltipData(
                                    getTooltipColor: (touchedSpot) => _currentChartColor,
                                    tooltipRoundedRadius: 8,
                                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                                      return touchedBarSpots.map((barSpot) {
                                        return LineTooltipItem(
                                          '${barSpot.y.toInt()}',
                                          const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                        );
                                      }).toList();
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A0025),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFFF0040).withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Total Attack', '${_attackData.isNotEmpty ? _attackData.last.value.toInt() : 0}', const Color(0xFFFF0040)),
                _buildStatItem('Active Senders', '${_senderData.isNotEmpty ? _senderData.last.value.toInt() : 0}', const Color(0xFF00FF88)),
                _buildStatItem('Users', '${_userData.isNotEmpty ? _userData.last.value.toInt() : 0}', const Color(0xFF0088FF)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _getMaxY() {
    if (_currentData.isEmpty) return 100;
    
    double maxValue = _currentData
        .map((data) => data.value)
        .reduce((a, b) => a > b ? a : b);
    
    return (maxValue * 1.2).ceilToDouble();
  }

  Widget _buildTimeRangeButton(String value, String label) {
    final isSelected = _selectedTimeRange == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTimeRange = value;
          });
          _loadPerformanceData();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFF0040) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.transparent : const Color(0xFFFF0040).withOpacity(0.3),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF888888),
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChartTypeButton(String value, String label, IconData icon) {
    final isSelected = _selectedChartType == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedChartType = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? _getButtonColor(value) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.transparent : _getButtonColor(value).withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? Colors.white : _getButtonColor(value), size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : _getButtonColor(value),
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getButtonColor(String type) {
    switch (type) {
      case 'attack':
        return const Color(0xFFFF0040);
      case 'sender':
        return const Color(0xFF00FF88);
      case 'user':
        return const Color(0xFF0088FF);
      case 'ddos':
        return const Color(0xFFFF8800);
      case 'login':
        return const Color(0xFFAA00FF);
      default:
        return const Color(0xFFFF0040);
    }
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF888888),
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class PerformanceData {
  final String period;
  final double value;

  PerformanceData({required this.period, required this.value});
}
