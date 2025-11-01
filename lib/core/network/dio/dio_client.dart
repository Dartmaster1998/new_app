import 'dart:async';

import 'package:dio/dio.dart';
import 'package:quick_bid/core/network/token_storage/token_storage.dart';

class DioClient {
final Dio _dio;
  final TokenStorage tokenStorage;

  DioClient({required this.tokenStorage})
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'http://34.18.76.114',
            responseType: ResponseType.json,
            sendTimeout: const Duration(seconds: 10000),
            receiveTimeout: const Duration(seconds: 10000),
          ),
        ) {
    _dio.interceptors.add(LoggerInterceptor(tokenStorage: tokenStorage));
    Timer.periodic(const Duration(minutes: 30), (timer) async {
      await tokenStorage.clearTokens();
    });
  }

  Dio get dio => _dio;
  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }
  Future<Response> post(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.post(
        url,
        data: data,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
  Future<Response> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
  Future<dynamic> delete(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final Response response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
class LoggerInterceptor extends Interceptor {
  final TokenStorage tokenStorage;
  final Dio _dio;

  LoggerInterceptor({required this.tokenStorage})
      : _dio = Dio(BaseOptions(baseUrl: 'http://34.18.76.114'));

@override
void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {

  if (!options.path.contains('/sign-up') && !options.path.contains('/login')) {
    final token = await tokenStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
  }

  if (options.data is FormData) {
    options.headers.remove('Content-Type');
  } else {
    options.headers['Content-Type'] = 'application/json; charset=UTF-8';
  }

  // print('*** Dio Request ***');
  // print('URI: ${options.uri}');
  // print('Method: ${options.method}');
  // print('Headers: ${options.headers}');
  // print('Query Parameters: ${options.queryParameters}');
  // print('Body: ${options.data}');
  // print('*******************');

  handler.next(options);
}


  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    final options = err.requestOptions;

    // print('*** Dio Error ***');
    // print('URI: ${options.uri}');
    // print('Status Code: ${statusCode}');
    // print('Message: ${err.message}');
    if (err.response != null) {
      // print('Error Data: ${err.response?.data}');
    }
    // print('****************');

    if (statusCode == 401) {
      final success = await _handleRefreshToken();
      if (success) {
        final newToken = await tokenStorage.getAccessToken();
        options.headers['Authorization'] = 'Bearer $newToken';

        try {
          final response = await _dio.fetch(options);
          return handler.resolve(response);
        } catch (e) {
          return handler.next(err);
        }
      } else {
        await tokenStorage.clearTokens();
      }
    }

    handler.next(err);
  }

  Future<bool> _handleRefreshToken() async {
    final refreshToken = await tokenStorage.getRefreshToken();
    if (refreshToken == null) return false;

    try {
      final response = await _dio.post('/v1/api/auth/refresh', data: {
        'refreshToken': refreshToken,
      });

      if (response.statusCode == 200 && response.data != null) {
        final newAccessToken = response.data['accessToken'];
        final newRefreshToken = response.data['refreshToken'];

        if (newAccessToken != null && newRefreshToken != null) {
          await tokenStorage.saveAccessToken(newAccessToken);
          await tokenStorage.saveRefreshToken(newRefreshToken);
          return true;
        }
      }
      return false;
    } catch (e) {
      // print('Refresh token failed: $e');
      return false;
    }
  }
}
