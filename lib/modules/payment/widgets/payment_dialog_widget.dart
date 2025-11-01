import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_bid/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_bid/l10n/app_localizations.dart';

void showBuyModal({
  required BuildContext context,
  required dynamic lot,
  required dynamic artist,
  required String langCode,
}) {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final loc = AppLocalizations.of(context)!;
  final isDark = Theme.of(context).brightness == Brightness.dark;
  bool agreed = false;

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            insetPadding: EdgeInsets.symmetric(
              horizontal: 5.w,
              vertical: 20.h,
            ), // почти весь экран
            backgroundColor: isDark ? Colors.grey[900] : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.99,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 40.h), // отступ для крестика
                        Text(
                          "${loc.buy} ${lot.title[langCode] ?? ''}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                _buildInputField(
                                  nameController,
                                  loc.name,
                                  Icons.person_outline,
                                ),
                                SizedBox(height: 12.h),
                                _buildInputField(
                                  phoneController,
                                  loc.phoneNumber,
                                  Icons.phone_outlined,
                                  keyboardType: TextInputType.phone,
                                ),
                                SizedBox(height: 12.h),
                                _buildInputField(
                                  emailController,
                                  loc.emailreq,
                                  Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                SizedBox(height: 12.h),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: agreed,
                                      onChanged: (value) {
                                        setState(() {
                                          agreed = value ?? false;
                                        });
                                      },
                                    ),
                                    Expanded(
                                      child: Text(
                                        loc.buyAgreement,
                                        style: TextStyle(
                                          color:
                                              isDark
                                                  ? Colors.white70
                                                  : Colors.black87,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        ElevatedButton(
                          onPressed:
                              agreed
                                  ? () {
                                    if (phoneController.text.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(loc.phoneNumber),
                                        ),
                                      );
                                      return;
                                    }
                                    Navigator.pop(context);
                                    GoRouter.of(context).push(
                                      '/payqr/${Uri.encodeComponent(lot.id.toString())}?'
                                      'title=${Uri.encodeComponent(lot.title[langCode] ?? '')}&'
                                      'price=${lot.startingPrice}&'
                                      'artist=${Uri.encodeComponent(artist.name[langCode] ?? '')}&'
                                      'name=${Uri.encodeComponent(nameController.text)}&'
                                      'phone=${Uri.encodeComponent(phoneController.text)}&'
                                      'email=${Uri.encodeComponent(emailController.text)}',
                                    );
                                  }
                                  : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber[800],
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                          ),
                          child: Text(loc.confirm),
                        ),
                      ],
                    ),
                  ),
                  // Крестик в правом верхнем углу
                  Positioned(
                    top: 10.h,
                    right: 10.w,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close,
                        color: isDark ? Colors.white : Colors.black,
                        size: 28.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _buildInputField(
  TextEditingController controller,
  String label,
  IconData icon, {
  TextInputType? keyboardType,
}) {
  final isDark =
      WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
  return TextField(
    controller: controller,
    keyboardType: keyboardType,
    style: TextStyle(color: isDark ? Colors.white : Colors.black),
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.amber[800]),
      filled: true,
      fillColor: isDark ? Colors.grey[850] : Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
