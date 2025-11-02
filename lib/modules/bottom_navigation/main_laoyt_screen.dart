import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quick_bid/modules/artists/presentation/artists_page.dart';
import 'package:quick_bid/modules/stars/stars_screen.dart';
import 'package:quick_bid/core/theme/app_provider.dart';
import 'package:quick_bid/l10n/app_localizations.dart';
import 'package:quick_bid/modules/homepage/presentation/home__page.dart';
import 'package:quick_bid/modules/lots/presentation/lots_page.dart';
import 'package:quick_bid/modules/profile/profile_screen.dart';
import 'package:quick_bid/modules/artists/domain/entity/artists_entity.dart';

class MainLayoutScreen extends StatefulWidget {
  final ArtistEntity? artistToShow;

  const MainLayoutScreen({super.key, this.artistToShow});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context);
    final isDark = app.themeMode == ThemeMode.dark;
    final loc = AppLocalizations.of(context)!;

    final List<Widget> _pages = [
      widget.artistToShow != null
          ? ArtistDetailScreen(artist: widget.artistToShow!)
          : const HomePageScreen(),
      const LotsPage(),
      const StarsScreen(),
      const ProfileScreen(), // просто экран профиля
    ];

    final List<_NavItem> _navItems = [
      _NavItem(icon: Icons.home_outlined, label: loc.home),
      _NavItem(icon: Icons.gavel, label: loc.lots),
      _NavItem(icon: Icons.star_outline_sharp, label: loc.actors),
      _NavItem(icon: Icons.person_outline, label: loc.profile),
    ];

    return Scaffold(
      body: _pages[selectedIndex],
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        color: isDark ? Colors.black : Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            _navItems.length,
            (index) => _buildNavItem(index, _navItems, isDark),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, List<_NavItem> navItems, bool isDark) {
    final item = navItems[index];
    final bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromARGB(255, 181, 177, 177)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(
              item.icon,
              color: isSelected
                  ? Colors.amber
                  : (isDark ? Colors.white70 : Colors.black54),
              size: 24.sp,
            ),
            if (isSelected) ...[
              SizedBox(width: 6.w),
              Text(
                item.label,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  _NavItem({required this.icon, required this.label});
}
