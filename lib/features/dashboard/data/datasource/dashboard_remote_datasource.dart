import 'dart:developer';

import 'package:digihealth/core/error/error_handle.dart';
import 'package:digihealth/core/network/dio_client.dart';
import 'package:digihealth/features/dashboard/data/models/dashboard_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for DashboardRemoteDataSource
/// Uses the shared Dio instance from dioProvider
final dashboardRemoteDataSourceProvider =
    Provider<DashboardRemoteDataSource>((ref) {
  return DashboardRemoteDataSourceImpl(ref.read(dioProvider));
});

/// Abstract class defining the contract for dashboard remote data operations
abstract class DashboardRemoteDataSource {
  /// Fetches dashboard data from the remote API
  /// Optional parameters: [region], [province], [ummc], [from], [to], [tranche], [isItenerance] for filtering
  /// Throws [Failure] if the request fails
  Future<DashboardResponse> getDashboardData({
    String? region,
    String? province,
    String? ummc,
    String? from,
    String? to,
    int? tranche,
    bool? isItenerance,
  });
}

/// Implementation of [DashboardRemoteDataSource] using Dio for HTTP requests
class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final Dio _dio;

  DashboardRemoteDataSourceImpl(this._dio);

  @override
  Future<DashboardResponse> getDashboardData({
    String? region,
    String? province,
    String? ummc,
    String? from,
    String? to,
    int? tranche,
    bool? isItenerance,
  }) async {
    try {
      // Build query parameters
      String endpoint = 'data/dashboard';
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
      if (isItenerance != null && isItenerance) {
        queryParams['is_itenerance'] = 'true';
      }

      // Log the filters being applied
      if (queryParams.isNotEmpty) {
        print('📊 Fetching dashboard with filters: $queryParams');
      } else {
        print('📊 Fetching dashboard without filters');
      }

      // Make API request to fetch dashboard data
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      // Parse and return the response
      if (response.data != null) {
        // API wraps data in {"status":"success","data":{...}}
        print('Dashboard API response status: ${response.data["status"]}');

        final data = response.data["data"];
        if (data == null) {
          throw Exception('API response data field is null');
        }

        print('Attempting to parse dashboard data...${response.data["data"]}');
        final dashboardResponse = DashboardResponse.fromJson(data);
        print('Dashboard data parsed successfully!');
        // print('Consultations: ${dashboardResponse.consultationGenerale?.sum}');
        // print('Specialities count: ${dashboardResponse.specialities?.length}');

        return dashboardResponse;
      } else {
        throw Exception('No data received from server');
      }
    } on DioException catch (e) {
      // Handle Dio-specific errors and convert to Failure
      log('DioException in getDashboardData: ${e.message}');
      throw ErrorHandle.handleDioException(e);
    } catch (e, stackTrace) {
      // Handle any other unexpected errors
      log('Unexpected error in getDashboardData: $e');
      log('Stack trace: $stackTrace');
      throw Exception('Unexpected error while fetching dashboard data: $e');
    }
  }
}
