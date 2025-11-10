import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quick_bid/l10n/app_localizations.dart';

class ProfileHeader extends StatefulWidget {
  final bool isDark;
  final AppLocalizations loc;
  const ProfileHeader({super.key, required this.isDark, required this.loc});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 130.h,
      color: widget.isDark ? Colors.black : Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              widget.loc.profile,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: widget.isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
          Divider(color: widget.isDark ? Colors.white24 : Colors.black12),
          SizedBox(height: 10.h),
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: widget.isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : const Color.fromARGB(255, 240, 241, 242),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.person_2_outlined,
                  color: Colors.amber,
                ),
              ),
              SizedBox(width: 20.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.loc.profile,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: widget.isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "+996555156851",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: widget.isDark ? Colors.white70 : Colors.black,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                color: widget.isDark ? Colors.white70 : Colors.black54,
                size: 16.sp,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
