import 'package:dio/dio.dart';
import 'package:quick_bid/modules/sliders/data/model/slider_model.dart';
import 'package:quick_bid/modules/sliders/domain/entity/slider_entity.dart';
import 'package:quick_bid/modules/sliders/domain/repository/slider_domain_repository.dart';

class SliderRepositoryImpl implements SliderDomainRepository {
  final Dio _dio;
  final String _baseUrl;

  SliderRepositoryImpl({
    required Dio dio,
    String baseUrl = 'https://auction-backend-mlzq.onrender.com/api/v1',
  }) : _dio = dio, _baseUrl = baseUrl;

  @override
  Future<List<SliderEntity>> getAllSliders() async {
    try {
      final response = await _dio.get('$_baseUrl/sliders');
      if (response.statusCode == 200) {
        final data = response.data;
        
        List<dynamic> slidersJson = [];
        if (data is List) {
          slidersJson = data;
        } else if (data is Map<String, dynamic>) {
          if (data['data'] is List) {
            slidersJson = data['data'] as List<dynamic>;
          } else if (data['data'] != null) {
            slidersJson = [data['data']];
          }
        }

        return slidersJson
            .where((json) => json != null && json is Map<String, dynamic>)
            .map((json) => SliderModel.fromJson(json as Map<String, dynamic>))
            .where((slider) => slider.isActive) // Только активные слайдеры
            .toList()
          ..sort((a, b) => a.order.compareTo(b.order)); // Сортировка по order
      } else {
        throw Exception('Error fetching sliders: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Repository getAllSliders failed: $e');
    }
  }
}

