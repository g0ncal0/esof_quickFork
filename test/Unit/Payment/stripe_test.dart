import 'package:esof/backend/stripe/payment_manager.dart';
import 'package:esof/pages/checkout/checkout_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:esof/pages/home_page/home_page_widget.dart';
import 'package:esof/backend/stripe/payment_manager.dart';
import 'package:mockito/mockito.dart';

class MockBuildContext extends Mock implements BuildContext {}

class MockMakeCloudCall extends Mock {
  Future<Map<String, dynamic>> call(String callName, Map<String, dynamic> params);
}

void main() {
  group('Stripe Payment Tests', () {
    test('Test processStripePayment', () async {
      // Mocking required dependencies
      final mockContext = MockBuildContext();

      const int amount = 295;
      const String currency = 'EUR';
      const String customerEmail = 'testesofquickfork@gmail.com';
      const String description = 'Test Payment';
      const bool allowGooglePay = false;
      const bool allowApplePay = false;

      final paymentResponse = await processStripePayment(
        mockContext,
        amount: amount,
        currency: currency,
        customerEmail: customerEmail,
        description: description,
        allowGooglePay: allowGooglePay,
        allowApplePay: allowApplePay,
      );

      expect(paymentResponse, isNotNull);
      expect(paymentResponse.paymentId, null);

    });
  });
}
