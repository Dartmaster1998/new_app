import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_bid/l10n/app_localizations.dart';
import 'package:quick_bid/modules/localized_text/localized_text.dart';

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
                          "${loc.buy} ${_getLotName(lot, langCode)}",
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
                                  context,
                                  nameController,
                                  loc.name,
                                  Icons.person_outline,
                                ),
                                SizedBox(height: 12.h),
                                _buildInputField(
                                  context,
                                  phoneController,
                                  loc.phoneNumber,
                                  Icons.phone_outlined,
                                  keyboardType: TextInputType.phone,
                                ),
                                SizedBox(height: 12.h),
                                _buildInputField(
                                  context,
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
                                      '/payqr/${Uri.encodeComponent(_getLotId(lot))}?'
                                      'title=${Uri.encodeComponent(_getLotName(lot, langCode))}&'
                                      'price=${_getLotPrice(lot)}&'
                                      'artist=${Uri.encodeComponent(_getArtistName(artist, langCode))}&'
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
  BuildContext context,
  TextEditingController controller,
  String label,
  IconData icon, {
  TextInputType? keyboardType,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
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

// Вспомогательные функции для безопасной работы с dynamic типами
String _getLotId(dynamic lot) {
  if (lot == null) return '';
  try {
    // Если это LotEntity
    return lot.id?.toString() ?? '';
  } catch (e) {
    // Если это Map
    return (lot as Map<String, dynamic>?)?['id']?.toString() ?? '';
  }
}

String _getLotName(dynamic lot, String langCode) {
  if (lot == null) return '';
  try {
    // Если это LotEntity
    final name = lot.name;
    if (name != null) {
      // Если это LocalizedText
      if (name is LocalizedText) {
        return name.getByLang(langCode);
      }
      // Если это Map
      if (name is Map<String, dynamic>) {
        return name[langCode]?.toString() ?? '';
      }
    }
    // Если это Map
    final map = lot as Map<String, dynamic>?;
    if (map?['name'] != null) {
      if (map!['name'] is LocalizedText) {
        return (map['name'] as LocalizedText).getByLang(langCode);
      }
      if (map['name'] is Map<String, dynamic>) {
        return (map['name'] as Map<String, dynamic>)[langCode]?.toString() ?? '';
      }
    }
    return map?['title']?.toString() ?? '';
  } catch (e) {
    // Если это Map с прямым title
    try {
      final map = lot as Map<String, dynamic>?;
      return map?['title']?.toString() ?? '';
    } catch (_) {
      return '';
    }
  }
}

String _getLotPrice(dynamic lot) {
  if (lot == null) return '0';
  try {
    // Если это LotEntity
    final price = lot.price;
    if (price != null) {
      return price.toString();
    }
    // Если это Map
    final map = lot as Map<String, dynamic>?;
    return map?['price']?.toString() ?? map?['startingPrice']?.toString() ?? '0';
  } catch (e) {
    // Если это Map
    try {
      final map = lot as Map<String, dynamic>?;
      return map?['price']?.toString() ?? map?['startingPrice']?.toString() ?? '0';
    } catch (_) {
      return '0';
    }
  }
}

String _getArtistName(dynamic artist, String langCode) {
  if (artist == null) return '';
  try {
    // Если это ArtistEntity
    final name = artist.name;
    if (name != null) {
      // Если это LocalizedText
      if (name is LocalizedText) {
        return name.getByLang(langCode);
      }
      // Если это Map
      if (name is Map<String, dynamic>) {
        return name[langCode]?.toString() ?? '';
      }
    }
    // Если это Map
    final map = artist as Map<String, dynamic>?;
    if (map?['name'] != null) {
      if (map!['name'] is LocalizedText) {
        return (map['name'] as LocalizedText).getByLang(langCode);
      }
      if (map['name'] is Map<String, dynamic>) {
        return (map['name'] as Map<String, dynamic>)[langCode]?.toString() ?? '';
      }
      return map['name']?.toString() ?? '';
    }
    return map?['name']?.toString() ?? '';
  } catch (e) {
    // Если это Map с прямым name
    try {
      final map = artist as Map<String, dynamic>?;
      return map?['name']?.toString() ?? '';
    } catch (_) {
      return '';
    }
  }
}
