import 'package:digihealth/core/error/error_handle.dart';
import 'package:digihealth/core/network/dio_client.dart';
import 'package:digihealth/models/filter_data_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for FilterRemoteDataSource
/// Uses the shared Dio instance from dioProvider
final filterRemoteDataSourceProvider = Provider<FilterRemoteDataSource>((ref) {
  return FilterRemoteDataSourceImpl(ref.read(dioProvider));
});

/// Abstract class defining the contract for filter remote data operations
abstract class FilterRemoteDataSource {
  /// Fetches initial filter data (all regions)
  /// Throws [Failure] if the request fails
  Future<FilterDataModel> getFilterData();

  /// Fetches provinces for a specific region
  Future<List<String>> getProvincesForRegion(String region);

  /// Fetches UMMCs for a specific region and province
  Future<List<String>> getUmmcsForProvince(String region, String province);
}

/// Implementation of [FilterRemoteDataSource] using Dio for HTTP requests
class FilterRemoteDataSourceImpl implements FilterRemoteDataSource {
  final Dio _dio;

  FilterRemoteDataSourceImpl(this._dio);

  @override
  Future<FilterDataModel> getFilterData() async {
    try {
      // Make API request to fetch filter data
      // Based on your URL pattern, this seems to be the endpoint
      final response = await _dio.get(
          'ummcs/getregionsdata?data={"regions":"","provinces":"","ummcs":""}'); // Adjust if needed

      // Parse and return the response
      if (response.data != null) {
        debugPrint('Filter API response received');

        // Check if API wraps data
        dynamic filterData;

        // If API returns {"status":"success","data":{...}}
        if (response.data is Map && response.data.containsKey('data')) {
          filterData = response.data['data'];
        } else {
          // If API returns data directly
          filterData = response.data;
        }

        if (filterData == null) {
          throw Exception('API response data is null');
        }

        debugPrint('Attempting to parse filter data...');
        final filterDataModel = FilterDataModel.fromJson(filterData);
        debugPrint('Filter data parsed successfully!');
        debugPrint('Regions: ${filterDataModel.regions.length}');
        debugPrint('Provinces: ${filterDataModel.provinces.length}');
        debugPrint('UMMCs: ${filterDataModel.ummcs.length}');

        return filterDataModel;
      } else {
        throw Exception('No data received from server');
      }
    } on DioException catch (e) {
      // Handle Dio-specific errors and convert to Failure
      debugPrint('DioException in getFilterData: ${e.message}');
      throw ErrorHandle.handleDioException(e);
    } catch (e, stackTrace) {
      // Handle any other unexpected errors
      debugPrint('Unexpected error in getFilterData: $e');
      debugPrint('Stack trace: $stackTrace');
      throw Exception('Unexpected error while fetching filter data: $e');
    }
  }

  @override
  Future<List<String>> getProvincesForRegion(String region) async {
    try {
      debugPrint('🔄 Fetching provinces for region: $region');

      // Make API request with selected region
      final queryData = '{"region":"$region","province":"","ummc":""}';
      final response = await _dio.get(
        'ummcs/getregionsdata?data=$queryData',
      );

      if (response.data != null) {
        debugPrint('Provinces API response received');

        dynamic responseData;
        if (response.data is Map && response.data.containsKey('data')) {
          responseData = response.data['data'];
        } else {
          responseData = response.data;
        }

        if (responseData == null) {
          throw Exception('API response data is null');
        }

        // Extract provinces list
        final provinces = (responseData['provinces'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [];

        debugPrint('✅ Provinces fetched: ${provinces.length}');
        return provinces;
      } else {
        throw Exception('No data received from server');
      }
    } on DioException catch (e) {
      debugPrint('DioException in getProvincesForRegion: ${e.message}');
      throw ErrorHandle.handleDioException(e);
    } catch (e, stackTrace) {
      debugPrint('Unexpected error in getProvincesForRegion: $e');
      debugPrint('Stack trace: $stackTrace');
      throw Exception('Unexpected error while fetching provinces: $e');
    }
  }

  @override
  Future<List<String>> getUmmcsForProvince(
      String region, String province) async {
    try {
      debugPrint('🔄 Fetching UMMCs for region: $region, province: $province');

      // Make API request with selected region and province
      final queryData = '{"region":"$region","province":"$province","ummc":""}';
      final response = await _dio.get(
        'ummcs/getregionsdata?data=$queryData',
      );

      if (response.data != null) {
        debugPrint('UMMCs API response received');

        dynamic responseData;
        if (response.data is Map && response.data.containsKey('data')) {
          responseData = response.data['data'];
        } else {
          responseData = response.data;
        }

        if (responseData == null) {
          throw Exception('API response data is null');
        }

        // Extract ummcs list
        final ummcs = (responseData['ummcs'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [];

        debugPrint('✅ UMMCs fetched: ${ummcs.length}');
        return ummcs;
      } else {
        throw Exception('No data received from server');
      }
    } on DioException catch (e) {
      debugPrint('DioException in getUmmcsForProvince: ${e.message}');
      throw ErrorHandle.handleDioException(e);
    } catch (e, stackTrace) {
      debugPrint('Unexpected error in getUmmcsForProvince: $e');
      debugPrint('Stack trace: $stackTrace');
      throw Exception('Unexpected error while fetching UMMCs: $e');
    }
  }
}
