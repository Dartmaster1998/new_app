import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_bid/core/theme/app_provider.dart';
import 'package:quick_bid/l10n/app_localizations.dart';
import 'package:quick_bid/modules/artists/domain/entity/artists_entity.dart';
import 'package:quick_bid/modules/localized_text/localized_text.dart';
import 'package:quick_bid/modules/lots/domain/entity/lots_entity.dart';
import 'package:quick_bid/modules/payment/widgets/payment_dialog_widget.dart';

import 'widgets/lot_detail_app_bar.dart';
import 'widgets/lot_detail_content.dart';
import 'widgets/lot_photo_view_page.dart';

class LotDetailScreen extends StatefulWidget {
  final LotEntity lot;
  final ArtistEntity artist;

  const LotDetailScreen({
    super.key,
    required this.lot,
    required this.artist,
  });

  @override
  State<LotDetailScreen> createState() => _LotDetailScreenState();
}

class _LotDetailScreenState extends State<LotDetailScreen> {
  late final ValueNotifier<int> _currentIndex;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = ValueNotifier<int>(0);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _currentIndex.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final app = context.watch<AppProvider>();
    final langCode = app.locale.languageCode;
    final loc = AppLocalizations.of(context)!;

    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;

    final lotName = _localized(widget.lot.name, langCode);
    final ownerName = _localized(widget.artist.name, langCode);
    final description = _localized(widget.lot.description, langCode);
    final priceText = '${widget.lot.price} ${loc.som}';
    final ownerLabel = loc.owner;
    final buyLabel = loc.buy;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: LotDetailAppBar(
        title: lotName,
        isDark: isDark,
        isTablet: isTablet,
      ),
      body: LotDetailContent(
        lot: widget.lot,
        lotName: lotName,
        ownerName: ownerName,
        ownerLabel: ownerLabel,
        description: description,
        priceText: priceText,
        buyLabel: buyLabel,
        isDark: isDark,
        isTablet: isTablet,
        currentPage: _currentIndex,
        pageController: _pageController,
        onPageChanged: _onPageChanged,
        onThumbnailTap: _onThumbnailTap,
        onImageTap: (photo) => _openPhoto(context, photo, isDark),
        onBuyTap: () => showBuyModal(
          context: context,
          lot: widget.lot,
          artist: widget.artist,
          langCode: langCode,
        ),
      ),
    );
  }

  void _onPageChanged(int index) => _currentIndex.value = index;

  void _onThumbnailTap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _currentIndex.value = index;
  }

  void _openPhoto(BuildContext context, String photo, bool isDark) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LotPhotoViewPage(
          imageUrl: photo,
          isDark: isDark,
        ),
      ),
    );
  }

  String _localized(LocalizedText? text, String langCode) {
    if (text == null) return '';
    return text.getByLang(langCode);
  }
}

