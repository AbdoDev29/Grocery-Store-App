import 'package:flutter/material.dart';
import 'package:shop/stripe_payment/payment_manager.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => PaymentManager.makePayment(15, 'USD'),
          child: const Text('Pay 15'),
        ),
      ),
    );
  }
}
