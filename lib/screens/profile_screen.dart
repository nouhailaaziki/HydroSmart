import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/water_provider.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/validators.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _familySizeController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isEditMode = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;
    
    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _familySizeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    // Simulate save delay
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isSaving = false;
      _isEditMode = false;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile updated successfully!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final waterProvider = Provider.of<WaterProvider>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildProfileAvatar(),
                      SizedBox(height: 24),
                      _buildStatsCards(waterProvider),
                      SizedBox(height: 24),
                      _buildProfileForm(authProvider),
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

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.textWhite),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              'Profile',
              style: AppTextStyles.heading2,
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            icon: Icon(
              _isEditMode ? Icons.close : Icons.edit,
              color: AppColors.textWhite,
            ),
            onPressed: () {
              setState(() {
                _isEditMode = !_isEditMode;
                if (!_isEditMode) {
                  _loadUserData(); // Reset on cancel
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person, size: 50, color: Colors.black),
            ),
            if (_isEditMode)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.camera_alt, size: 20, color: Colors.black),
                    onPressed: () {
                      // Handle avatar change
                    },
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 16),
        Text(
          _nameController.text.isEmpty ? 'User' : _nameController.text,
          style: AppTextStyles.heading2,
        ),
        Text(
          _emailController.text,
          style: AppTextStyles.caption,
        ),
      ],
    );
  }

  Widget _buildStatsCards(WaterProvider waterProvider) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.textWhite.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: Icons.star,
                value: '${waterProvider.totalPoints}',
                label: 'Points',
                color: Colors.amber,
              ),
              _buildStatItem(
                icon: Icons.local_fire_department,
                value: '${waterProvider.currentStreak}',
                label: 'Day Streak',
                color: Colors.orangeAccent,
              ),
              _buildStatItem(
                icon: Icons.water_drop,
                value: '${waterProvider.totalWaterSaved.toInt()}L',
                label: 'Saved',
                color: AppColors.primary,
              ),
            ],
          ),
          SizedBox(height: 16),
          Divider(color: AppColors.textWhite.withOpacity(0.2)),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: Icons.emoji_events,
                value: '${waterProvider.unlockedAchievements.length}',
                label: 'Achievements',
                color: Colors.amber,
              ),
              _buildStatItem(
                icon: Icons.calendar_today,
                value: 'Jan 2024',
                label: 'Member Since',
                color: AppColors.info,
              ),
            ],
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
        Icon(icon, color: color, size: 28),
        SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.heading3.copyWith(fontSize: 18),
        ),
        Text(
          label,
          style: AppTextStyles.small,
        ),
      ],
    );
  }

  Widget _buildProfileForm(AuthProvider authProvider) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomInput(
            controller: _nameController,
            labelText: 'Full Name',
            prefixIcon: Icon(Icons.person_outline, color: AppColors.primary),
            readOnly: !_isEditMode,
            enabled: _isEditMode,
          ),
          SizedBox(height: 16),
          CustomInput(
            controller: _emailController,
            labelText: 'Email Address',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icon(Icons.email_outlined, color: AppColors.primary),
            readOnly: !_isEditMode,
            enabled: _isEditMode,
          ),
          SizedBox(height: 16),
          CustomInput(
            controller: _familySizeController,
            labelText: 'Family Size',
            hintText: 'Number of family members',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            prefixIcon: Icon(Icons.group_outlined, color: AppColors.primary),
            readOnly: !_isEditMode,
            enabled: _isEditMode,
          ),
          SizedBox(height: 16),
          CustomInput(
            controller: _phoneController,
            labelText: 'Phone Number',
            hintText: '+1 234 567 8900',
            keyboardType: TextInputType.phone,
            prefixIcon: Icon(Icons.phone_outlined, color: AppColors.primary),
            readOnly: !_isEditMode,
            enabled: _isEditMode,
          ),
          if (_isEditMode) ...[
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Cancel',
                    onPressed: () {
                      setState(() {
                        _isEditMode = false;
                        _loadUserData();
                      });
                    },
                    type: ButtonType.outlined,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: CustomButton(
                    text: 'Save',
                    onPressed: _saveProfile,
                    isLoading: _isSaving,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
