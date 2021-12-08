import 'package:flutter/material.dart';
import 'package:health_project/commons/widgets/header_widget.dart';

class BloodPressureView extends StatelessWidget {
  const BloodPressureView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SubHeader(title: 'Huyết áp'),
            Expanded(
              child: ListView(
                children: [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
