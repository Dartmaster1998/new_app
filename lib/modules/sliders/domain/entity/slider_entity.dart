import 'package:equatable/equatable.dart';

class SliderEntity extends Equatable {
  final String id;
  final String image;
  final String link;
  final int order;
  final bool isActive;

  const SliderEntity({
    required this.id,
    required this.image,
    required this.link,
    required this.order,
    required this.isActive,
  });

  @override
  List<Object?> get props => [id, image, link, order, isActive];
}

