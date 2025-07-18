import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:appoint/services/auth_service.dart';

class ApiClient {
  ApiClient._({AuthService? authService})
      : _authService = authService ?? AuthService();
  
  static final ApiClient _instance = ApiClient._();
  static ApiClient get instance => _instance;

  late final Dio _dio;
  final AuthService _authService;
  final String _baseUrl = 'https://api.appoint.com/v1'; // TODO: Replace with real API URL

  void initialize() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add interceptors
    _dio.interceptors.addAll([
      _AuthInterceptor(_authService),
      _LoggingInterceptor(),
      _ErrorInterceptor(),
      _RetryInterceptor(),
    ]);
  }

  Dio get dio => _dio;

  // Generic GET request
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Generic POST request
  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Generic PUT request
  Future<T> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Generic DELETE request
  Future<T> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Upload file
  Future<T> uploadFile<T>(
    String path,
    File file, {
    String fieldName = 'file',
    Map<String, dynamic>? extraData,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(file.path),
        ...?extraData,
      });

      final response = await _dio.post<T>(
        path,
        data: formData,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  ApiException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Connection timeout. Please check your internet connection.',
          type: ApiExceptionType.timeout,
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;
        
        if (statusCode == 401) {
          return ApiException(
            message: 'Unauthorized. Please login again.',
            type: ApiExceptionType.unauthorized,
          );
        } else if (statusCode == 403) {
          return ApiException(
            message: 'Access forbidden.',
            type: ApiExceptionType.forbidden,
          );
        } else if (statusCode == 404) {
          return ApiException(
            message: 'Resource not found.',
            type: ApiExceptionType.notFound,
          );
        } else if (statusCode == 422) {
          final errors = _parseValidationErrors(data);
          return ApiException(
            message: 'Validation failed.',
            type: ApiExceptionType.validation,
            validationErrors: errors,
          );
        } else if (statusCode! >= 500) {
          return ApiException(
            message: 'Server error. Please try again later.',
            type: ApiExceptionType.server,
          );
        } else {
          return ApiException(
            message: data?['message'] ?? 'An error occurred.',
            type: ApiExceptionType.unknown,
          );
        }
      case DioExceptionType.cancel:
        return ApiException(
          message: 'Request was cancelled.',
          type: ApiExceptionType.cancelled,
        );
      case DioExceptionType.connectionError:
        return ApiException(
          message: 'No internet connection.',
          type: ApiExceptionType.network,
        );
      default:
        return ApiException(
          message: 'An unexpected error occurred.',
          type: ApiExceptionType.unknown,
        );
    }
  }

  Map<String, List<String>> _parseValidationErrors(dynamic data) {
    if (data is Map<String, dynamic> && data.containsKey('errors')) {
      final errors = data['errors'] as Map<String, dynamic>;
      return errors.map((key, value) => MapEntry(
        key,
        value is List ? value.cast<String>() : [value.toString()],
      ));
    }
    return {};
  }
}

class ApiException implements Exception {
  const ApiException({
    required this.message,
    required this.type,
    this.validationErrors,
  });

  final String message;
  final ApiExceptionType type;
  final Map<String, List<String>>? validationErrors;

  @override
  String toString() => 'ApiException: $message';
}

enum ApiExceptionType {
  timeout,
  network,
  unauthorized,
  forbidden,
  notFound,
  validation,
  server,
  cancelled,
  unknown,
}

// Auth interceptor to add authentication headers
class _AuthInterceptor extends Interceptor {
  final AuthService _authService;

  _AuthInterceptor(this._authService);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final user = await _authService.currentUser();
    if (user != null) {
      final token = await user.getIdToken();
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Token expired, try to refresh
      final user = await _authService.currentUser();
      if (user != null) {
        final token = await user.getIdToken(true); // Force refresh
        err.requestOptions.headers['Authorization'] = 'Bearer $token';
        
        final response = await ApiClient.instance.dio.fetch(err.requestOptions);
        handler.resolve(response);
        return;
      }
    }
    handler.next(err);
  }
}

// Logging interceptor for debugging
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print('🌐 API Request: ${options.method} ${options.path}');
      if (options.data != null) {
        print('📦 Request Data: ${jsonEncode(options.data)}');
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print('✅ API Response: ${response.statusCode} ${response.requestOptions.path}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print('❌ API Error: ${err.response?.statusCode} ${err.requestOptions.path}');
      print('Error: ${err.message}');
    }
    handler.next(err);
  }
}

// Error handling interceptor
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Log error for analytics
    // AnalyticsService.instance.logError(err);
    
    handler.next(err);
  }
}

// Retry interceptor for network issues
class _RetryInterceptor extends Interceptor {
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(seconds: 1);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err) && err.requestOptions.extra['retryCount'] == null) {
      err.requestOptions.extra['retryCount'] = 1;
      
      await Future.delayed(_retryDelay);
      
      try {
        final response = await ApiClient.instance.dio.fetch(err.requestOptions);
        handler.resolve(response);
        return;
      } catch (e) {
        // Continue with error handling
      }
    }
    
    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionError ||
           err.type == DioExceptionType.connectionTimeout ||
           (err.response?.statusCode ?? 0) >= 500;
  }
} 