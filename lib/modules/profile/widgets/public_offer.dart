import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_bid/l10n/app_localizations.dart';

class PublicOfferTile extends StatelessWidget {
  final bool isDark;
  final AppLocalizations loc;

  const PublicOfferTile({
    super.key,
    required this.isDark,
    required this.loc,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: isDark ? Colors.grey[900] : Colors.grey.shade100,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListTile(
        leading: Icon(
          Icons.description_outlined,
          color: Colors.amber[800],
        ),
        title: Text(
          loc.publicOffer, // локализованный текст, например “Публичная оферта”
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16.sp,
          color: isDark ? Colors.white54 : Colors.black54,
        ),
        onTap: () {
          // переход на страницу публичной оферты
          GoRouter.of(context).push('/public-offer');
        },
      ),
    );
  }
}


class PublicOfferScreen extends StatelessWidget {
  const PublicOfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.publicOffer, // “Публичная оферта”
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      backgroundColor: isDark ? Colors.black : Colors.grey.shade50,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Публичная оферта",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                """
Настоящая публичная оферта является официальным предложением о заключении договора купли-продажи между пользователем и платформой QuickBid.

1. **Общие положения**
Пользователь, осуществляющий покупку лота на платформе, принимает все условия настоящей оферты.

2. **Права и обязанности сторон**
Покупатель обязуется предоставлять достоверные данные при оформлении покупки и своевременно производить оплату. 
QuickBid обеспечивает безопасность данных и корректную обработку платежей.

3. **Порядок оплаты**
Оплата осуществляется через доступные способы на платформе. После подтверждения оплаты лот закрепляется за покупателем.

4. **Возврат и отмена**
Возврат средств возможен только в случае технических ошибок, допущенных платформой, или отмены аукциона организатором.

5. **Ответственность**
QuickBid не несёт ответственности за ошибки, вызванные некорректными действиями пользователя.

6. **Заключительные положения**
Пользуясь платформой QuickBid, вы подтверждаете согласие с условиями настоящей публичной оферты.
                """,
                style: TextStyle(
                  fontSize: 14.sp,
                  height: 1.6,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.center,
                child: Text(
                  " ",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.amber[800],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
