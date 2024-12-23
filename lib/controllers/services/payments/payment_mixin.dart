import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/services/payments/payment_interface.dart';
import 'package:word_and_learn/models/writing/models.dart';
import 'package:word_and_learn/models/payments/payment_models.dart';
import 'package:word_and_learn/utils/exceptions.dart';
import 'package:word_and_learn/utils/http_client.dart';
import 'package:http/http.dart' as http;

mixin PaymentMixin implements PaymentInterface {
  final HttpClient client = HttpClient();

  SubscriptionStatus? subscriptionStatus;

  @override
  Future<SubscriptionStatus?> getUserSubscriptionStatus() async {
    http.Response res = await client.get(userSubscriptionStatusUrl);
    HttpResponse response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      UserSubscriptionStatus userSubscriptionStatus =
          UserSubscriptionStatus.fromJson(response.data);
      subscriptionStatus = userSubscriptionStatus.status;
      return subscriptionStatus;
    } else {
      throw HttpFetchException(
          "Could not fetch user subscription status", res.statusCode);
    }
  }

  @override
  Future<List<UserSubscription>?> getUserSubscription() async {
    http.Response res = await client.get(userSubscriptionUrl);

    HttpResponse response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      return userSubscriptionFromJson(res.body);
    } else {
      throw HttpFetchException(
          "Could not fetch user subscription", res.statusCode);
    }
  }

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
  Future<bool> startTrial() async {
    http.Response res = await client.get(
      "$paymentUrl/start_trial/W/",
    );
    HttpResponse response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      return response.isSuccess;
    } else {
      throw HttpFetchException("Could not start trial", res.statusCode);
    }
  }

  @override
  Future<bool?> cancelSubscription() async {
    http.Response res =
        await client.delete('$paymentUrl/subscription/W/cancel/');

    HttpResponse response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      return true;
    } else {
      throw HttpFetchException("Could not cancel transaction", 200);
    }
  }

  @override
  Future<Map<String, dynamic>?> subscribeToPackage(
      int packageId, Map<String, dynamic> body) async {
    http.Response res =
        await client.post("$paymentUrl/package/$packageId/subscribe/", body);

    HttpResponse response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      return response.data;
    } else {
      throw HttpFetchException("Could not subscribe to package", 400);
    }
  }
}
