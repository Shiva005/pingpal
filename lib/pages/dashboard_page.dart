import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pingpal/pages/chat_list.dart';
import 'package:pingpal/pages/map.dart';
import 'package:pingpal/pages/pingpals.dart';
import 'package:pingpal/pages/pingtrail.dart';
import 'package:pingpal/pages/settings.dart';

import '../theme/app_theme.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const PingtrailPage(),
    const PingpalsPage(),
    const MapPage(),
    const ChatListPage(),
    const SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: _pages[_selectedIndex],
      bottomNavigationBar: _buildNavBar(),
    );
  }

  Widget _buildNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(FontAwesomeIcons.route, 'Pingtrail', 0),
              _buildNavItem(FontAwesomeIcons.users, 'Pingpals', 1),
              _buildCenterMapButton(),
              _buildNavItem(FontAwesomeIcons.message, 'Chat', 3),
              _buildNavItem(FontAwesomeIcons.gear, 'Settings', 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isActive = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(isActive ? 10 : 8),
            decoration: BoxDecoration(
              color: isActive
                  ? AppTheme.primaryBlue.withOpacity(0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: FaIcon(
              icon,
              size: 20,
              color: isActive ? AppTheme.primaryBlue : AppTheme.textGray,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? AppTheme.primaryBlue : AppTheme.textGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterMapButton() {
    final bool isActive = _selectedIndex == 2;

    return GestureDetector(
      onTap: () => _onItemTapped(2),
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(
                  colors: [AppTheme.primaryBlue, AppTheme.accentBlue],
                )
              : null,
          color: isActive ? null : AppTheme.inputBackground,
          shape: BoxShape.circle,
          border: Border.all(
            color: isActive ? Colors.transparent : AppTheme.borderColor,
            width: 2,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: FaIcon(
            FontAwesomeIcons.mapLocationDot,
            size: 24,
            color: isActive ? Colors.white : AppTheme.textGray,
          ),
        ),
      ),
    );
  }
}
