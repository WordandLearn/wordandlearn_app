import 'package:intl/intl.dart';

export 'subscription_package.dart';
export 'package_subscription_details.dart';
export 'payment_history.dart';
export 'pesapal_request.dart';
export 'user_subscription.dart';
export 'subscription_status.dart';

class PaymentModel {
  String formattedDate(DateTime date) {
    //Format date to be like Aug 12,2024
    return DateFormat("MMM dd,yyyy").format(date);
  }
}
