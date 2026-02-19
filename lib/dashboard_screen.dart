import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'providers/water_provider.dart';
import 'providers/auth_provider.dart';
import 'models/challenge_model.dart';
import 'models/usage_record_model.dart';
import 'screens/achievements_screen.dart';

class HydrosmartDashboard extends StatelessWidget {
  static const double _yAxisInterval = 250.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            SizedBox(height: 30),
            _buildMainGoalCard(context),
            SizedBox(height: 20),
            _buildUsageChart(),
            SizedBox(height: 20),
            _buildQuickStats(context),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return "Good Morning";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon";
    } else if (hour >= 17 && hour < 21) {
      return "Good Evening";
    } else {
      return "Good Night";
    }
  }

  Widget _buildHeader(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final waterProvider = Provider.of<WaterProvider>(context);
    final userName = authProvider.user?.name ?? "User";

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${_getGreeting()}, $userName", style: GoogleFonts.poppins(color: Colors.white70, fontSize: 16)),
            Text("Hydrosmart", style: GoogleFonts.poppins(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 16),
                SizedBox(width: 4),
                Text(
                  "${waterProvider.totalPoints} points",
                  style: GoogleFonts.poppins(color: Colors.amber, fontSize: 14, fontWeight: FontWeight.w600),
                ),
                SizedBox(width: 12),
                Icon(Icons.local_fire_department, color: Colors.orangeAccent, size: 16),
                SizedBox(width: 4),
                Text(
                  "${waterProvider.currentStreak} day streak",
                  style: GoogleFonts.poppins(color: Colors.orangeAccent, fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
        CircleAvatar(backgroundColor: Colors.white24, child: Icon(Icons.person, color: Colors.white)),
      ],
    );
  }

  Widget _buildMainGoalCard(BuildContext context) {
    // Access the live data
    final waterData = Provider.of<WaterProvider>(context);

    // Calculate current period consumption from meter readings
    double currentPeriodConsumption = 0.0;
    String periodLabel = "Weekly Progress";

    if (waterData.currentChallenge != null && waterData.currentChallenge!.isActive) {
      // Use challenge-based progress
      final challenge = waterData.currentChallenge!;
      currentPeriodConsumption = waterData.meterReadings
          .where((r) => r.timestamp.isAfter(challenge.startDate))
          .map((r) => r.dailyConsumption ?? 0.0)
          .fold(0.0, (sum, consumption) => sum + consumption);

      periodLabel = challenge.type == ChallengeType.weekly
          ? "Weekly Progress"
          : "Monthly Progress";
    } else {
      // Fallback to weekly calculation
      final weekAgo = DateTime.now().subtract(const Duration(days: 7));
      currentPeriodConsumption = waterData.meterReadings
          .where((r) => r.timestamp.isAfter(weekAgo))
          .map((r) => r.dailyConsumption ?? 0.0)
          .fold(0.0, (sum, consumption) => sum + consumption);
    }

    final goal = waterData.currentChallenge?.targetConsumption ?? waterData.weeklyGoal;
    final isOverLimit = currentPeriodConsumption > goal;

    return GlassmorphicContainer(
      width: MediaQuery.of(context).size.width - 40,
      height: 200,
      borderRadius: 20,
      blur: 20,
      alignment: Alignment.center,
      border: 2,
      linearGradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)]),
      borderGradient: LinearGradient(colors: [Colors.white24, Colors.white10]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(periodLabel, style: GoogleFonts.poppins(color: Colors.white)),
          SizedBox(height: 10),
          Text(
              "${currentPeriodConsumption.toStringAsFixed(1)}L / ${goal.toStringAsFixed(0)}L",
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)
          ),
          Text(
              isOverLimit ? "Over Limit! ⚠️" : "Status: On Track ✅",
              style: GoogleFonts.poppins(
                  color: isOverLimit ? Colors.redAccent : Colors.greenAccent
              )
          ),
        ],
      ),
    );
  }

  double _calculateMaxYAxisValue(List<UsageRecord> usageRecords) {
    if (usageRecords.isEmpty) {
      return 100;
    }
    final maxUsage = usageRecords.fold<double>(0, (max, record) => record.usage > max ? record.usage : max);
    return (maxUsage / _yAxisInterval).ceil() * _yAxisInterval + _yAxisInterval;
  }

  Widget _buildUsageChart() {
    return Consumer<WaterProvider>(
      builder: (context, waterProvider, _) {
        final last7Days = waterProvider.getLastSevenDays();
        final maxY = _calculateMaxYAxisValue(last7Days);

        return Container(
          height: 220,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Daily Usage (Last 7 Days)",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.cyanAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Liters",
                      style: GoogleFonts.poppins(
                        color: Colors.cyanAccent,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Expanded(
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: _yAxisInterval,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.white.withOpacity(0.1),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() >= 0 && value.toInt() < last7Days.length) {
                              final date = last7Days[value.toInt()].date;
                              final dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
                              return Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Text(
                                  dayNames[date.weekday % 7],
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 10,
                                  ),
                                ),
                              );
                            }
                            return Text('');
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: _yAxisInterval,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${value.toInt()}L',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 10,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: (last7Days.length - 1).toDouble(),
                    minY: 0,
                    maxY: maxY,
                    lineBarsData: [
                      LineChartBarData(
                        spots: last7Days.asMap().entries.map((entry) {
                          return FlSpot(entry.key.toDouble(), entry.value.usage);
                        }).toList(),
                        isCurved: true,
                        gradient: LinearGradient(
                          colors: [Colors.cyanAccent, Colors.blueAccent],
                        ),
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: Colors.cyanAccent,
                              strokeWidth: 2,
                              strokeColor: Colors.white,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              Colors.cyanAccent.withOpacity(0.3),
                              Colors.cyanAccent.withOpacity(0.0),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    final waterData = Provider.of<WaterProvider>(context);

    // Calculate daily average display
    String dailyAvgDisplay;
    if (waterData.hasHistoricalDataForAverage()) {
      final avgConsumption = waterData.getDailyAverageConsumption();
      dailyAvgDisplay = '${avgConsumption.toStringAsFixed(2)}m³';
    } else {
      dailyAvgDisplay = '0.00m³';
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _statTile(
                !waterData.leakDetectionEnabled ? "OFF" : (waterData.isLeakDetected ? "ALERT" : "Secure"),
                "Leak Status",
                waterData.leakDetectionEnabled ? (waterData.isLeakDetected ? Icons.warning : Icons.check_circle) : Icons.do_not_disturb_on,
                waterData.leakDetectionEnabled ? (waterData.isLeakDetected ? Colors.redAccent : Colors.greenAccent) : Colors.grey
            )),
            SizedBox(width: 15),
            Expanded(child: _statTile(dailyAvgDisplay, "Daily Avg", Icons.water_drop, Colors.blueAccent)),
          ],
        ),
        SizedBox(height: 15),
        _buildAchievementsCard(context, waterData),
      ],
    );
  }

  Widget _buildAchievementsCard(BuildContext context, WaterProvider waterData) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AchievementsScreen()),
        );
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.amber.withOpacity(0.2),
              Colors.orange.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.amber.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.emoji_events, color: Colors.amber, size: 28),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Achievements",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "${waterData.unlockedAchievements.length}/${waterData.achievements.length} unlocked",
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _statTile(String val, String label, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(15)),
      child: Column(children: [
        Icon(icon, color: color),
        Text(val, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
        Text(label, style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12)),
      ]),
    );
  }
}