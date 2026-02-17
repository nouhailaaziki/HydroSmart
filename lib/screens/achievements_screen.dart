import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/water_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../models/achievement_model.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: _buildAchievementsList(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final waterProvider = Provider.of<WaterProvider>(context);
    
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: AppColors.textWhite),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Text(
                  'Achievements',
                  style: AppTextStyles.heading2,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: 48), // Balance the back button
            ],
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.textWhite.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  icon: Icons.star,
                  value: '${waterProvider.totalPoints}',
                  label: 'Total Points',
                  color: Colors.amber,
                ),
                Container(width: 1, height: 40, color: AppColors.textWhite.withOpacity(0.2)),
                _buildStatItem(
                  icon: Icons.emoji_events,
                  value: '${waterProvider.unlockedAchievements.length}/${waterProvider.achievements.length}',
                  label: 'Unlocked',
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.heading3,
        ),
        Text(
          label,
          style: AppTextStyles.small,
        ),
      ],
    );
  }

  Widget _buildAchievementsList(BuildContext context) {
    final waterProvider = Provider.of<WaterProvider>(context);
    final achievements = waterProvider.achievements;
    
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        return _buildAchievementCard(achievements[index]);
      },
    );
  }

  Widget _buildAchievementCard(Achievement achievement) {
    final isLocked = !achievement.isUnlocked;
    
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.textWhite.withOpacity(isLocked ? 0.05 : 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLocked 
              ? AppColors.textWhite.withOpacity(0.1)
              : AppColors.primary.withOpacity(0.5),
          width: isLocked ? 1 : 2,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isLocked
                    ? AppColors.textWhite.withOpacity(0.1)
                    : AppColors.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  achievement.icon,
                  style: TextStyle(
                    fontSize: 32,
                    color: isLocked ? AppColors.textWhite38 : AppColors.textWhite,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          achievement.title,
                          style: AppTextStyles.heading3.copyWith(
                            fontSize: 18,
                            color: isLocked ? AppColors.textWhite54 : AppColors.textWhite,
                          ),
                        ),
                      ),
                      if (!isLocked) ...[
                        Icon(Icons.check_circle, color: AppColors.success, size: 24),
                      ] else ...[
                        Icon(Icons.lock_outline, color: AppColors.textWhite38, size: 20),
                      ],
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    achievement.description,
                    style: AppTextStyles.caption.copyWith(
                      color: isLocked ? AppColors.textWhite38 : AppColors.textWhite70,
                    ),
                  ),
                  if (!isLocked && achievement.unlockedAt != null) ...[
                    SizedBox(height: 8),
                    Text(
                      'Unlocked ${_formatDate(achievement.unlockedAt!)}',
                      style: AppTextStyles.small.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return 'just now';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
