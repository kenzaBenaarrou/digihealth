import 'package:digihealth/core/error/error_handle.dart';
import 'package:digihealth/core/network/dio_client.dart';
import 'package:digihealth/features/programs/data/models/program_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for ProgramRemoteDataSource
final programRemoteDataSourceProvider =
    Provider<ProgramRemoteDataSource>((ref) {
  return ProgramRemoteDataSourceImpl(ref.read(dioProvider));
});

/// Abstract class defining the contract for program remote data operations
abstract class ProgramRemoteDataSource {
  /// Fetch programs with optional filters and pagination
  Future<ProgramsResponse> getPrograms({
    String? category,
    String? status,
    String? region,
    String? province,
    String? ummc,
    int page = 1,
    int pageSize = 20,
  });

  /// Fetch a single program by ID
  Future<ProgramModel> getProgramById(String id);
}

/// Implementation of [ProgramRemoteDataSource] using Dio for HTTP requests
class ProgramRemoteDataSourceImpl implements ProgramRemoteDataSource {
  final Dio _dio;

  ProgramRemoteDataSourceImpl(this._dio);

  @override
  Future<ProgramsResponse> getPrograms({
    String? category,
    String? status,
    String? region,
    String? province,
    String? ummc,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      debugPrint(
          '🔄 Fetching programs - Page: $page, Category: $category, Status: $status');

      // Build query parameters
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': pageSize,
      };

      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }
      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }
      if (region != null && region.isNotEmpty) {
        queryParams['region'] = region;
      }
      if (province != null && province.isNotEmpty) {
        queryParams['province'] = province;
      }
      if (ummc != null && ummc.isNotEmpty) {
        queryParams['ummc'] = ummc;
      }

      // Make API request
      final response = await _dio.get(
        'data/consultation',
        queryParameters: queryParams,
      );

      if (response.data != null) {
        debugPrint('✅ Programs response received');

        // Handle different API response structures
        dynamic responseData;
        if (response.data is Map && response.data.containsKey('data')) {
          responseData = response.data['data'];
        } else {
          responseData = response.data;
        }

        if (responseData == null) {
          throw Exception('No data received from server');
        }

        // Parse the response
        return ProgramsResponse.fromJson(responseData);
      } else {
        throw Exception('No data received from server');
      }
    } on DioException catch (e) {
      debugPrint('❌ DioException in getPrograms: ${e.message}');
      throw ErrorHandle.handleDioException(e);
    } catch (e, stackTrace) {
      debugPrint('❌ Unexpected error in getPrograms: $e');
      debugPrint('Stack trace: $stackTrace');
      throw Exception('Unexpected error while fetching programs: $e');
    }
  }

  @override
  Future<ProgramModel> getProgramById(String id) async {
    try {
      debugPrint('🔄 Fetching program by ID: $id');

      final response = await _dio.get('programs/$id');

      if (response.data != null) {
        debugPrint('✅ Program detail received');

        // Handle different API response structures
        dynamic responseData;
        if (response.data is Map && response.data.containsKey('data')) {
          responseData = response.data['data'];
        } else {
          responseData = response.data;
        }

        if (responseData == null) {
          throw Exception('No data received from server');
        }

        return ProgramModel.fromJson(responseData);
      } else {
        throw Exception('No data received from server');
      }
    } on DioException catch (e) {
      debugPrint('❌ DioException in getProgramById: ${e.message}');
      throw ErrorHandle.handleDioException(e);
    } catch (e, stackTrace) {
      debugPrint('❌ Unexpected error in getProgramById: $e');
      debugPrint('Stack trace: $stackTrace');
      throw Exception('Unexpected error while fetching program: $e');
    }
  }
}
