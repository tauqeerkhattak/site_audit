import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:site_audit/domain/controllers/review_controller.dart';

class ReviewScreen extends StatelessWidget {
  final controller = Get.find<ReviewController>();
  ReviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          Text('DATA IS VALIDATED AND SAVED LOCALLY'),
        ],
      ),
    );
  }
}
