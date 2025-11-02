import 'package:equatable/equatable.dart';
import 'package:quick_bid/modules/category/domain/entity/category_entity.dart';
import 'package:quick_bid/modules/lots/domain/entity/lots_entity.dart';

import '../../../localized_text/localized_text.dart';

class ArtistEntity extends Equatable {
  final String id;
  final LocalizedText name;
  final String photo;
  final List<LotEntity> lots;
  final CategoryEntity category;
  final String slug;

  const ArtistEntity({
    required this.id,
    required this.name,
    required this.photo,
    required this.lots,
    required this.category,
    required this.slug,
  });

  @override
  List<Object?> get props => [id, name, photo, lots, category, slug];
}
