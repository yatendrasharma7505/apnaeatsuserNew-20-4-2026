import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  late Razorpay _razorpay;

  final Function(
    String paymentId,
    String orderId,
    String signature,
  )? onSuccess;

  final Function(String message)? onError;

  RazorpayService({
    this.onSuccess,
    this.onError,
  }) {
    _razorpay = Razorpay();

    _razorpay.on(
      Razorpay.EVENT_PAYMENT_SUCCESS,
      _handleSuccess,
    );

    _razorpay.on(
      Razorpay.EVENT_PAYMENT_ERROR,
      _handleError,
    );

    _razorpay.on(
      Razorpay.EVENT_EXTERNAL_WALLET,
      _handleExternalWallet,
    );
  }

  void openCheckout({
    required String orderId,
    required double amount,
    required String name,
    required String email,
    required String phone,
  }) {
    final options = {
      "key": "rzp_live_S6ZBDEez4dQsUT",

      /// amount in paise
      "amount": (amount * 100).toInt(),

      "currency": "INR",

      "name": name,

      "order_id": orderId,

      "description": "Food Order",

      "timeout": 300,

      "prefill": {
        "contact": phone,
        "email": email,
      },

      "theme": {
        "color": "#ff7529",
      },

      "method": {
        "upi": true,
        "card": true,
        "netbanking": true,
        "wallet": true,
      }
    };

    _razorpay.open(options);
  }

  void _handleSuccess(PaymentSuccessResponse response) {
    print("RAZORPAY SUCCESS");

    print(response.paymentId);

    print(response.orderId);

    print(response.signature);

    onSuccess?.call(
      response.paymentId ?? "",
      response.orderId ?? "",
      response.signature ?? "",
    );
  }

  void _handleError(PaymentFailureResponse response) {
    print("RAZORPAY ERROR");

    print(response.code);

    print(response.message);

    onError?.call(
      response.message ?? "Payment Failed",
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("EXTERNAL WALLET");

    print(response.walletName);
  }

  void dispose() {
    _razorpay.clear();
  }
}
