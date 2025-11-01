import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_bid/modules/artists/domain/entity/artists_entity.dart';
import 'package:quick_bid/modules/artists/presentation/artists_page.dart';
import 'package:quick_bid/modules/bottom_navigation/main_laoyt_screen.dart';
import 'package:quick_bid/modules/lots/lot_detail_screen.dart';
import 'package:quick_bid/modules/payment/payment_screen.dart';
import 'package:quick_bid/modules/profile/widgets/public_offer.dart';
import 'package:quick_bid/modules/splash_screen/splash_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const MainLayoutScreen(),
    ),
    GoRoute(
      path: '/artist-detail',
      builder: (context, state) {
        final artist = state.extra as ArtistsEntity;
        return ArtistDetailScreen(artist: artist);
      },
    ),
    GoRoute(
      path: '/lot-detail',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        final lot = extra['lot'];
        final artist = extra['artist'];
        return LotDetailScreen(lot: lot, artist: artist);
      },
    ),
GoRoute(
  path: '/payqr/:lotId',
  builder: (context, state) {
    final lotId = state.pathParameters['lotId']!;
    final lotTitle = state.uri.queryParameters['title'] ?? 'Лот $lotId';
    final startingPrice = state.uri.queryParameters['price'] ?? '0';
    final artistName = state.uri.queryParameters['artist'] ?? 'Неизвестно';
    final name = state.uri.queryParameters['name'] ?? '';
    final phone = state.uri.queryParameters['phone'] ?? '';
    final email = state.uri.queryParameters['email'] ?? '';

    final lot = {
      'id': lotId,
      'title': lotTitle,
      'startingPrice': startingPrice,
    };
    final artist = {
      'name': artistName,
    };

    return PayQrScreen(
      lot: lot,
      artist: artist,
      name: name,
      phone: phone,
      email: email,
    );
  },
),


GoRoute(
  path: '/public-offer',
  builder: (context, state) => const PublicOfferScreen(),
),
  ],
);

class DeeplinkHandler extends StatefulWidget {
  final Widget child;
  const DeeplinkHandler({super.key, required this.child});

  @override
  State<DeeplinkHandler> createState() => _DeeplinkHandlerState();
}

class _DeeplinkHandlerState extends State<DeeplinkHandler> {
  @override
  void initState() {
    super.initState();
    _handleInitialUri();
  }

  Future<void> _handleInitialUri() async {
    final uri = Uri.base;
    if (uri.pathSegments.isEmpty) return;

    // Диплинк для оплаты: quickbid://payment/123?amount=10&recipient=+996555156851
    if (uri.pathSegments[0] == 'payment' && uri.pathSegments.length > 1) {
      final lotId = uri.pathSegments[1];
      final amount = uri.queryParameters['amount'] ?? '0';
      final recipient = uri.queryParameters['recipient'] ?? '';
      context.go('/payment/$lotId?amount=$amount&recipient=$recipient');
    }

    // Пример диплинка для лота: quickbid://lot-detail?id=123
    if (uri.pathSegments[0] == 'lot-detail' && uri.pathSegments.length > 1) {
      // Если понадобится, можно распарсить id и extra
      // context.go('/lot-detail', extra: {...});
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
