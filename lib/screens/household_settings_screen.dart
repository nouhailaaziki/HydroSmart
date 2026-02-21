import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/water_provider.dart';
import '../providers/auth_provider.dart';
import '../models/household_member_model.dart';
import '../utils/validators.dart';

class HouseholdSettingsScreen extends StatefulWidget {
  const HouseholdSettingsScreen({Key? key}) : super(key: key);

  @override
  State<HouseholdSettingsScreen> createState() => _HouseholdSettingsScreenState();
}

class _HouseholdSettingsScreenState extends State<HouseholdSettingsScreen> {
  final _uuid = const Uuid();
  List<HouseholdMember> _members = [];
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  void _loadMembers() {
    final waterProvider = context.read<WaterProvider>();
    setState(() {
      _members = List.from(waterProvider.householdMembers);
    });
  }

  void _addMember() {
    setState(() {
      _members.add(HouseholdMember(
        id: _uuid.v4(),
        age: 25,
      ));
    });
  }

  void _removeMember(int index) {
    if (_members.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must have at least one household member'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _members.removeAt(index);
    });
  }

  Future<void> _saveChanges() async {
    try {
      final waterProvider = context.read<WaterProvider>();
      final authProvider = context.read<AuthProvider>();

      await waterProvider.updateHouseholdMembers(_members);
      await authProvider.updateHouseholdMembers(_members);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Household information updated!'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() => _isEditing = false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Household Settings'),
        actions: [
          if (!_isEditing)
            IconButton(
              onPressed: () => setState(() => _isEditing = true),
              icon: const Icon(Icons.edit),
            )
          else
            IconButton(
              onPressed: _saveChanges,
              icon: const Icon(Icons.check),
            ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.navyMid, AppColors.backgroundDark],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            // Household Size
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.family_restroom,
                    color: AppColors.primary,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Household Size',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_members.length} ${_members.length == 1 ? 'member' : 'members'}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Members List
            Text(
              'Household Members',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            ...List.generate(_members.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildMemberCard(index),
              );
            }),

            if (_isEditing) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _addMember,
                icon: const Icon(Icons.add),
                label: const Text('Add Member'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],

            const SizedBox(height: 32),

            // Estimated Consumption Info
            Consumer<WaterProvider>(
              builder: (context, waterProvider, _) {
                final profile = waterProvider.getHouseholdProfile();
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.analytics_outlined,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Estimated Consumption',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildEstimateRow('Daily', '${profile['estimatedDaily'].toStringAsFixed(1)} L'),
                      _buildEstimateRow('Weekly', '${profile['estimatedWeekly'].toStringAsFixed(1)} L'),
                      _buildEstimateRow('Monthly', '${profile['estimatedMonthly'].toStringAsFixed(1)} L'),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberCard(int index) {
    final member = _members[index];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              member.age <= 12 ? Icons.child_care :
              member.age <= 17 ? Icons.person_outline :
              member.age <= 64 ? Icons.person : Icons.elderly,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name ?? 'Member ${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                if (_isEditing)
                  SizedBox(
                    width: 100,
                    child: TextFormField(
                      initialValue: member.age.toString(),
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Age',
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      onChanged: (value) {
                        final age = int.tryParse(value);
                        if (age != null && age >= 0 && age <= 120) {
                          setState(() {
                            _members[index] = member.copyWith(age: age);
                          });
                        }
                      },
                    ),
                  )
                else
                  Text(
                    '${member.age} years old',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
          if (_isEditing && _members.length > 1)
            IconButton(
              onPressed: () => _removeMember(index),
              icon: const Icon(Icons.remove_circle_outline),
              color: Colors.red,
            ),
        ],
      ),
    );
  }

  Widget _buildEstimateRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
