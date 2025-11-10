import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:quick_bid/l10n/app_localizations.dart';

class PayQrScreen extends StatelessWidget {
  final Map<String, dynamic> lot;
  final Map<String, dynamic> artist;
  final String name;
  final String phone;
  final String email;

  const PayQrScreen({
    super.key,
    required this.lot,
    required this.artist,
    required this.name,
    required this.phone,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text(
          loc.buy,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Заголовок
                Text(
                  "${loc.lots} ${lot['title'] ?? ''}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 16.h),

                // QR-код
                AnimatedScale(
                  duration: const Duration(milliseconds: 500),
                  scale: 1.0,
                  child: QrImageView(
                    data:
                        "lot:${Uri.encodeComponent(lot['title']?.toString() ?? '')}"
                        "|name:${Uri.encodeComponent(name)}"
                        "|phone:${Uri.encodeComponent(phone)}"
                        "|email:${Uri.encodeComponent(email)}"
                        "|amount:${lot['startingPrice']?.toString() ?? '0'}"
                        "|recipient:${Uri.encodeComponent(artist['phone']?.toString() ?? artist['name']?.toString() ?? '')}",
                    version: QrVersions.auto,
                    size: 180.w,
                    backgroundColor: Colors.white,
                  ),
                ),
                SizedBox(height: 20.h),

                // Данные пользователя
                _buildInfoRow(loc.name, name, isDark),
                _buildInfoRow(loc.phoneNumber, phone, isDark),
                _buildInfoRow(loc.emailreq, email, isDark),

                SizedBox(height: 20.h),
                Divider(
                  color: isDark ? Colors.white24 : Colors.grey.shade300,
                  thickness: 1,
                ),
                SizedBox(height: 12.h),

                // Информация о лоте
                _buildInfoRow(loc.lots, lot['title'] ?? '-', isDark),
                _buildInfoRow(
                  loc.owner,
                  artist['name'] ?? artist['phone'] ?? '-',
                  isDark,
                ),
                _buildInfoRow(
                  loc.price,
                  "${lot['startingPrice'] ?? '-'} KGS",
                  isDark,
                ),
                SizedBox(height: 28.h),

                // Кнопка подтверждения
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[800],
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 48.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  icon: const Icon(Icons.check_circle_outline),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(loc.sold),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  label: Text(
                    loc.buy,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$title:",
            style: TextStyle(
              fontSize: 14.sp,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14.sp,
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
