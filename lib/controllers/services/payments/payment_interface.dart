import 'package:word_and_learn/models/payments/payment_models.dart';

abstract class PaymentInterface {
  Future<List<UserSubscription>?> getUserSubscription();
  Future<List<SubscriptionPackage>?> getSubscriptionPackages();

  Future<PackageSubscriptionDetails?> getPackageSubscriptionDetails(
      int packageId);

  Future<List<PaymentHistory>?> getPaymentHistory();

  Future<bool> startTrial();

  Future<bool?> cancelSubscription();

  Future<Map<String, dynamic>?> subscribeToPackage(
      int packageId, Map<String, dynamic> body);
}
