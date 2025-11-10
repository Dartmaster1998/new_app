class ImageUrlHelper {
  static const String baseUrl = 'https://auction-backend-mlzq.onrender.com';

  /// Формирует полный URL для изображения
  /// Если URL уже полный (начинается с http:// или https://), возвращает его как есть
  /// Иначе добавляет базовый URL
  static String getFullImageUrl(String imagePath) {
    if (imagePath.isEmpty) return '';
    
    // Если URL уже полный, возвращаем как есть
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    }
    
    // Убираем начальный слеш, если есть
    final cleanPath = imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;
    
    // Формируем полный URL
    return '$baseUrl/$cleanPath';
  }
}

