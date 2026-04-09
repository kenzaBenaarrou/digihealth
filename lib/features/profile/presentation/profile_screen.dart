import 'package:digihealth/features/authentication/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: const Color(0xFF051024),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTopBar(),
              20.verticalSpace,
              _buildProfileHeader(user),
              30.verticalSpace,
              _buildStatsRow(),
              30.verticalSpace,
              _buildSettingsSection(ref),
              30.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'PROFIL',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.sp),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.cyanAccent, width: 2),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.settings_outlined,
              color: Colors.cyanAccent,
              size: 24.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(user) {
    final fullName = '${user?.firstName ?? ''} ${user?.lastName ?? ''}'.trim();
    final displayName =
        fullName.isNotEmpty ? fullName.toUpperCase() : 'UTILISATEUR';

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(4.sp),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.cyanAccent, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.cyanAccent.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 50.r,
            backgroundColor: const Color(0xFF0A1A2E),
            child: Icon(
              Icons.person,
              size: 50.sp,
              color: Colors.cyanAccent,
            ),
          ),
        ),
        16.verticalSpace,
        Text(
          displayName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        8.verticalSpace,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Colors.cyanAccent.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.cyanAccent),
          ),
          child: Text(
            'MÉDECIN CHEF',
            style: TextStyle(
              color: Colors.cyanAccent,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
        8.verticalSpace,
        Text(
          'Centre de Santé Central',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Expanded(
            child: _buildStatBox('PATIENTS', '2,543', Icons.people_outline),
          ),
          16.horizontalSpace,
          Expanded(
            child: _buildStatBox(
                'CONSULTATIONS', '8,234', Icons.medical_services_outlined),
          ),
          16.horizontalSpace,
          Expanded(
            child: _buildStatBox('PROGRAMMES', '12', Icons.assignment_outlined),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1A2E),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.cyanAccent, size: 28.sp),
          12.verticalSpace,
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          4.verticalSpace,
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 10.sp,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PARAMÈTRES',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          16.verticalSpace,
          _buildSettingItem(
            icon: Icons.person_outline,
            title: 'Informations personnelles',
            onTap: () {},
          ),
          _buildSettingItem(
            icon: Icons.lock_outline,
            title: 'Sécurité et mot de passe',
            onTap: () {},
          ),
          _buildSettingItem(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            onTap: () {},
          ),
          _buildSettingItem(
            icon: Icons.language_outlined,
            title: 'Langue',
            trailing: 'Français',
            onTap: () {},
          ),
          _buildSettingItem(
            icon: Icons.help_outline,
            title: 'Aide et support',
            onTap: () {},
          ),
          _buildSettingItem(
            icon: Icons.info_outline,
            title: 'À propos',
            onTap: () {},
          ),
          16.verticalSpace,
          _buildLogoutButton(ref),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? trailing,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[800]!,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.cyanAccent, size: 24.sp),
            16.horizontalSpace,
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
            ),
            if (trailing != null)
              Text(
                trailing,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14.sp,
                ),
              ),
            8.horizontalSpace,
            Icon(
              Icons.chevron_right,
              color: Colors.grey[600],
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(authNotifierProvider.notifier).logout();
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFFF6B6B), width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout,
              color: const Color(0xFFFF6B6B),
              size: 20.sp,
            ),
            12.horizontalSpace,
            Text(
              'DÉCONNEXION',
              style: TextStyle(
                color: const Color(0xFFFF6B6B),
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
