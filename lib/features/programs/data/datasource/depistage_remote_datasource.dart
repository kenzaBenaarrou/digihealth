import 'package:digihealth/core/error/error_handle.dart';
import 'package:digihealth/core/network/dio_client.dart';
import 'package:digihealth/features/programs/data/models/depistage_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
final depistageRemoteDatasourceProvider = Provider<DepistageRemoteDatasource>((ref) {
  return DepistageRemoteDatasourceImpl(ref.read(dioProvider));
});
abstract class DepistageRemoteDatasource {
  /// Fetch depistage statistics with optional filters
  Future<DepistageResponse> getDepistageData({
    String? region,
    String? province,
    String? ummc,
    String? from,
    String? to,
    int? tranche,
    bool? isItinerance,
  });
}

class DepistageRemoteDatasourceImpl implements DepistageRemoteDatasource {
  final Dio _dio;
  const DepistageRemoteDatasourceImpl(this._dio);
  @override
  Future<DepistageResponse> getDepistageData({
    String? region,
    String? province,
    String? ummc,
    String? from,
    String? to,
    int? tranche,
    bool? isItinerance,
  }) async {
    try {
      debugPrint('🔄 Fetching depistage data');

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
        debugPrint('📊 Depistage filters: $queryParams');
      }
      final response =
          await _dio.get("data/depistage", queryParameters: queryParams);
      if (response.data != null) {
        debugPrint('✅ Depistage data fetched successfully');
        dynamic responseData;
        if (response.data is Map && responseData.containsKey('data')) {
          responseData = response.data['data'];
        } else {
          responseData = response.data;
        }
        if (responseData == null) {
          debugPrint('⚠️ Depistage response data is null');
          throw Exception('Depistage data is null');
        }
        return DepistageResponse.fromJson(responseData as Map<String, dynamic>);
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
