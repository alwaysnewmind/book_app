import 'package:dio/dio.dart';

import 'models/subscription_verification_response.dart';

class PremiumRemoteDataSource {
  final Dio _dio;

  const PremiumRemoteDataSource(this._dio);

  Future<SubscriptionVerificationResponse> verifySubscription({
    required String userId,
    required String receiptData,
    required String platform,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/verify-subscription',
      data: {
        'userId': userId,
        'receiptData': receiptData,
        'platform': platform,
      },
    );

    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'Empty verification response from backend.',
      );
    }

    return SubscriptionVerificationResponse.fromJson(data);
  }
}
