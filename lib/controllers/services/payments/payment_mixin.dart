import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/services/payments/payment_interface.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:word_and_learn/models/payments/package_subscription_details.dart';
import 'package:word_and_learn/models/payments/payment_history.dart';
import 'package:word_and_learn/models/payments/subscription_package.dart';
import 'package:word_and_learn/utils/exceptions.dart';
import 'package:word_and_learn/utils/http_client.dart';
import 'package:http/http.dart' as http;

mixin PaymentMixin implements PaymentInterface {
  final HttpClient client = HttpClient();

  @override
  Future<List<SubscriptionPackage>?> getSubscriptionPackages() async {
    http.Response res = await client.get(packagesUrl);

    HttpResponse response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      return subscriptionPackageFromJson(res.body);
    } else {
      throw HttpFetchException("Could not fetch packages", res.statusCode);
    }
  }

  @override
  Future<PackageSubscriptionDetails?> getPackageSubscriptionDetails(
      int packageId) async {
    http.Response res = await client.get('$packagesUrl/$packageId/status');
    HttpResponse response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      return PackageSubscriptionDetails.fromJson(response.data);
    } else {
      throw HttpFetchException(
          "Could not fetch package details", res.statusCode);
    }
  }

  @override
  Future<List<PaymentHistory>?> getPaymentHistory() async {
    http.Response res = await client.get("$paymentUrl/history/");
    HttpResponse response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      return paymentHistoryFromJson(res.body);
    } else {
      throw HttpFetchException(
          "Could not fetch payment history", res.statusCode);
    }
  }

  @override
  Future<bool?> cancelSubscription(int packageId) async {
    http.Response res =
        await client.delete('$paymentUrl/subscription/$packageId/cancel/');

    HttpResponse response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      return true;
    } else {
      throw HttpFetchException("Could not cancel transaction", 200);
    }
  }
}
