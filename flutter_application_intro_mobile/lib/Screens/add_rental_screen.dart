import 'package:flutter/material.dart';
import '../Widgets/base_scaffold.dart';

class AddRentalScreen extends StatelessWidget {
  const AddRentalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Voeg toestel toe',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 1000,
                      color: Colors.grey.shade100,
                      child: const Center(child: Text("Content hier")),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
