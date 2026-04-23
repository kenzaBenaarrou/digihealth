import 'package:digihealth/core/error/error_handle.dart';
import 'package:digihealth/core/network/dio_client.dart';
import 'package:digihealth/features/programs/data/models/consultation_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for ConsultationRemoteDataSource
final consultationRemoteDataSourceProvider =
    Provider<ConsultationRemoteDataSource>((ref) {
  return ConsultationRemoteDataSourceImpl(ref.read(dioProvider));
});

/// Abstract class defining the contract for consultation remote data operations
abstract class ConsultationRemoteDataSource {
  /// Fetch consultation statistics with optional filters
  Future<ConsultationResponse> getConsultationData({
    String? region,
    String? province,
    String? ummc,
    String? from,
    String? to,
    int? tranche,
    bool? isItinerance,
  });
}

/// Implementation of [ConsultationRemoteDataSource] using Dio for HTTP requests
class ConsultationRemoteDataSourceImpl implements ConsultationRemoteDataSource {
  final Dio _dio;

  ConsultationRemoteDataSourceImpl(this._dio);

  @override
  Future<ConsultationResponse> getConsultationData({
    String? region,
    String? province,
    String? ummc,
    String? from,
    String? to,
    int? tranche,
    bool? isItinerance,
  }) async {
    try {
      debugPrint('🔄 Fetching consultation data');

      // Build query parameters
      final queryParams = <String, String>{};

      if (region != null && region.isNotEmpty) {
        queryParams['region'] = region;
      }
      if (province != null && province.isNotEmpty) {
        queryParams['province'] = province;
      }
      if (ummc != null && ummc.isNotEmpty) {
        queryParams['ummc'] = ummc;
      }
      if (from != null && from.isNotEmpty) {
        queryParams['from'] = from;
      }
      if (to != null && to.isNotEmpty) {
        queryParams['to'] = to;
      }
      if (tranche != null) {
        queryParams['tranche'] = tranche.toString();
      }
      if (isItinerance != null && isItinerance) {
        queryParams['is_itinerance'] = 'true';
      }

      // Log the filters being applied
      if (queryParams.isNotEmpty) {
        debugPrint('📊 Consultation filters: $queryParams');
      }

      // Make API request - adjust endpoint to match your backend
      final response = await _dio.get(
        'data/consultation', // Update this to match your actual endpoint
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      if (response.data != null) {
        debugPrint('✅ Consultation data received');

        // Handle different API response structures
        dynamic responseData;

        // If API wraps data in {"status":"success","data":{...}}
        if (response.data is Map && response.data.containsKey('data')) {
          responseData = response.data['data'];
        } else {
          responseData = response.data;
        }

        if (responseData == null) {
          throw Exception('No data received from server');
        }

        // Parse the response
        return ConsultationResponse.fromJson(
            responseData as Map<String, dynamic>);
      } else {
        throw Exception('No data received from server');
      }
    } on DioException catch (e) {
      debugPrint('❌ DioException in getConsultationData: ${e.message}');
      throw ErrorHandle.handleDioException(e);
    } catch (e, stackTrace) {
      debugPrint('❌ Unexpected error in getConsultationData: $e');
      debugPrint('Stack trace: $stackTrace');
      throw Exception('Unexpected error while fetching consultation data: $e');
    }
  }
}
