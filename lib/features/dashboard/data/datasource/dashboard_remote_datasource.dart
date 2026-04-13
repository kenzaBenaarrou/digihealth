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
  /// Throws [Failure] if the request fails
  Future<DashboardResponse> getDashboardData();
}

/// Implementation of [DashboardRemoteDataSource] using Dio for HTTP requests
class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final Dio _dio;

  DashboardRemoteDataSourceImpl(this._dio);

  @override
  Future<DashboardResponse> getDashboardData() async {
    try {
      // Make API request to fetch dashboard data
      final response = await _dio.get('data/dashboard');

      // Parse and return the response
      if (response.data != null) {
        // API wraps data in {"status":"success","data":{...}}
        log('Dashboard API response status: ${response.data["status"]}');

        final data = response.data["data"];
        if (data == null) {
          throw Exception('API response data field is null');
        }

        log('Attempting to parse dashboard data...');
        final dashboardResponse = DashboardResponse.fromJson(data);
        log('Dashboard data parsed successfully!');
        log('Consultations: ${dashboardResponse.consultationGenerale?.sum}');
        log('Specialities count: ${dashboardResponse.specialities?.length}');

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
