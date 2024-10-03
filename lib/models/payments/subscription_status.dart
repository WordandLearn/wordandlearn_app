enum SubscriptionStatus {
  active,
  cancelled,
  expired,
  trialActive,
  noSubscription
}

class UserSubscriptionStatus {
  final SubscriptionStatus status;
  final String? message;

  UserSubscriptionStatus({
    required this.status,
    this.message,
  });

  static SubscriptionStatus _getSubscriptionStatus(String status) {
    switch (status) {
      case 'subscription_active':
        return SubscriptionStatus.active;
      case 'subscription_cancelled':
        return SubscriptionStatus.cancelled;
      case 'subscription_expired':
        return SubscriptionStatus.expired;
      case 'trial_active':
        return SubscriptionStatus.trialActive;
      default:
        return SubscriptionStatus.noSubscription;
    }
  }

  factory UserSubscriptionStatus.fromJson(Map<String, dynamic> json) {
    return UserSubscriptionStatus(
      status: _getSubscriptionStatus(json['status']),
      message: json['message'],
    );
  }
}
