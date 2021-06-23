import 'dart:io';
import 'package:dio/dio.dart';
import 'package:pexels/data/util/apiException.dart';

class DioClient {
  // dio instance
  final Dio _dio;

  // injecting dio instance
  DioClient(this._dio);

  // Get:-----------------------------------------------------------------------
  Future<dynamic> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    dynamic responseJson;
    try {
      final Response response = await _dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      responseJson = _response(response);
      return responseJson;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  // Post:----------------------------------------------------------------------
  Future<dynamic> post(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    dynamic responseJson;
    try {
      final Response response = await _dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      responseJson = await _response(response);
      return responseJson;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  // Put:-----------------------------------------------------------------------
  Future<dynamic> put(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      dynamic responseJson;
      final Response response = await _dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      responseJson = _response(response);
      return responseJson;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  // Delete:--------------------------------------------------------------------
  Future<dynamic> delete(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    dynamic responseJson;
    try {
      final Response response = await _dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      responseJson = _response(response);
      return responseJson;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  dynamic _response(Response response) {
    switch (response.statusCode) {
      case 200:
        return response.data;
      case 400:
        throw BadRequestException(response.data.toString());
      case 401:

      case 403:
        throw UnauthorisedException(response.data.toString());
      case 500:

      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
