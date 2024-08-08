import 'package:word_and_learn/models/payments/payment_models.dart';

abstract class PaymentInterface {
  Future<List<SubscriptionPackage>?> getSubscriptionPackages();

  Future<PackageSubscriptionDetails?> getPackageSubscriptionDetails(
      int packageId);

  Future<List<PaymentHistory>?> getPaymentHistory();

  Future<bool?> cancelSubscription(int packageId);

  Future<PesaPalRequest?> subscribeToPackage(
      int packageId, Map<String, dynamic> body);
}
