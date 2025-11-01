import 'dart:convert';
import 'package:quick_bid/modules/artists/domain/entity/artists_entity.dart';

class ArtistsModel extends ArtistsEntity {
  ArtistsModel({
    required super.id,
    required super.name,
    required super.category,
    required super.photo,
    required super.description,
    required super.lots,
  });

  factory ArtistsModel.fromJson(Map<String, dynamic> json) {
    return ArtistsModel(
      id: json['id'] as String,
      name: Map<String, String>.from(json['name'] as Map),
      category: Map<String, String>.from(json['category'] as Map),
      photo: json['photo'] as String,
      description: Map<String, String>.from(json['description'] as Map),
      lots: (json['lots'] as List<dynamic>)
          .map((e) => LotModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'photo': photo,
      'description': description,
      'lots': lots.map((e) => (e as LotModel).toJson()).toList(),
    };
  }
}

class LotModel extends Lot {
  LotModel({
    required super.id,
    required super.title,
    required super.description,
    required super.startingPrice,
    required super.auctionDate,
    required super.photos,
  });

  factory LotModel.fromJson(Map<String, dynamic> json) {
    return LotModel(
      id: json['id'].toString(),
      title: Map<String, String>.from(json['title'] as Map),
      description: Map<String, String>.from(json['description'] as Map),
      startingPrice: (json['starting_price'] as num).toDouble(),
      auctionDate: DateTime.parse(json['auction_date'] as String),
      photos: (json['photo'] is List)
          ? List<String>.from(json['photo'])
          : [json['photo'].toString()],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'starting_price': startingPrice,
      'auction_date': auctionDate.toIso8601String(),
      'photo': photos,
    };
  }
}

// Helpers
List<ArtistsModel> artistsFromJson(String str) =>
    (json.decode(str) as List<dynamic>)
        .map((e) => ArtistsModel.fromJson(e as Map<String, dynamic>))
        .toList();

String artistsToJson(List<ArtistsModel> data) =>
    json.encode(data.map((e) => e.toJson()).toList());
