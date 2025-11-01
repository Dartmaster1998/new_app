import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quick_bid/core/theme/app_provider.dart';
import 'package:quick_bid/modules/artists/domain/entity/artists_entity.dart';
import 'package:quick_bid/modules/homepage/widgets/lot_card.dart';

class ArtistDetailScreen extends StatelessWidget {
  final ArtistsEntity artist;

  const ArtistDetailScreen({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final langCode = app.locale.languageCode; // 'ru', 'ky', 'en'
    final name = artist.name[langCode] ?? artist.name['en'] ?? '';
    final description = artist.description[langCode] ?? artist.description['en'] ?? '';

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                artist.photo,
                width: double.infinity,
                height: 300.h,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 50),
              ),
            ),
            SizedBox(height: 16.h),
            Text(name, style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 8.h),
            Text(description, style: TextStyle(fontSize: 15.sp, color: Colors.grey.shade700)),
            SizedBox(height: 20.h),
            const Divider(),
            SizedBox(height: 10.h),
            Text(
              {
                'ky': 'Активдүү лоттор',
                'ru': 'Активные лоты',
                'en': 'Active Lots',
              }[langCode] ?? 'Active Lots',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10.h),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: artist.lots.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.w,
                mainAxisSpacing: 10.h,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {
                final lot = artist.lots[index];
                return GestureDetector(
                  onTap: () {
                    context.push(
                      '/lot-detail',
                      extra: {
                        'lot': lot,
                        'artist': artist,
                      },
                    );
                  },
                  child: LotCard(
                    lot: lot,
                    artist: artist,
                    showBuyButton: true,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
