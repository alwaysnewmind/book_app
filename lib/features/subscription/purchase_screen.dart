import 'package:flutter/material.dart';
import 'package:book_app/services/payment_service.dart';
import 'package:book_app/shared/widgets/animated_tap_wrapper.dart';

class PurchaseScreen extends StatelessWidget {
  const PurchaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final paymentService = PaymentService();

    return Scaffold(
      appBar: AppBar(title: const Text("Upgrade Plan")),
      body: Center(
        child: AnimatedTapWrapper(
          onTap: () async {
            await paymentService.makePayment(
              amount: 199,
              userId: "demo_user",
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: ElevatedButton(
          onPressed: () async {
            await paymentService.makePayment(
              amount: 199,
              userId: "demo_user",
            );
          },
          child: const Text("Buy Premium"),
          ),
        ),
      ),
    );
  }
}
