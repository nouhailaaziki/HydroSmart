import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'providers/water_provider.dart';
import 'providers/auth_provider.dart';

class HydrosmartDashboard extends StatelessWidget {
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
    final userName = authProvider.user?.name ?? "User";
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${_getGreeting()}, $userName", style: GoogleFonts.poppins(color: Colors.white70, fontSize: 16)),
            Text("Hydrosmart", style: GoogleFonts.poppins(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
          ],
        ),
        CircleAvatar(backgroundColor: Colors.white24, child: Icon(Icons.person, color: Colors.white)),
      ],
    );
  }

  Widget _buildMainGoalCard(BuildContext context) {
    // Access the live data
    final waterData = Provider.of<WaterProvider>(context);

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
          Text("Weekly Progress", style: GoogleFonts.poppins(color: Colors.white)),
          SizedBox(height: 10),
          Text(
              "${waterData.currentUsage.toStringAsFixed(1)}L / ${waterData.weeklyGoal.toInt()}L",
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)
          ),
          Text(
              waterData.currentUsage > waterData.weeklyGoal ? "Over Limit! ⚠️" : "Status: On Track ✅",
              style: GoogleFonts.poppins(
                  color: waterData.currentUsage > waterData.weeklyGoal ? Colors.redAccent : Colors.greenAccent
              )
          ),
        ],
      ),
    );
  }

  Widget _buildUsageChart() {
    return Container(
      height: 180,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(20)),
      child: LineChart(LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [LineChartBarData(
            spots: [FlSpot(0, 2), FlSpot(1, 1.5), FlSpot(2, 4), FlSpot(3, 3)],
            isCurved: true,
            color: Colors.cyanAccent,
            barWidth: 4,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: true, color: Colors.cyanAccent.withOpacity(0.1)),
          )])),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    final waterData = Provider.of<WaterProvider>(context);
    return Row(
      children: [
        // Inside _buildQuickStats
        Expanded(child: _statTile(
            !waterData.leakDetectionEnabled ? "OFF" : (waterData.isLeakDetected ? "ALERT" : "Secure"),
            "Leak Status",
            waterData.leakDetectionEnabled ? (waterData.isLeakDetected ? Icons.warning : Icons.check_circle) : Icons.do_not_disturb_on,
            waterData.leakDetectionEnabled ? (waterData.isLeakDetected ? Colors.redAccent : Colors.greenAccent) : Colors.grey
        )),
        SizedBox(width: 15),
        Expanded(child: _statTile("2.1L", "Daily Avg", Icons.water_drop, Colors.blueAccent)),
      ],
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