import 'package:flutter/material.dart';
import 'package:flutter_application_intro_mobile/Widgets/listing_tab.dart';
import 'package:flutter_application_intro_mobile/Widgets/rental_tab.dart';
import '../Widgets/base_scaffold.dart';

class RentalDashboard extends StatelessWidget {
  final String title;
  const RentalDashboard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: BaseScaffold(
        title: title,
        body: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: "My Listings"),
                Tab(text: "My Rentals"),
                Tab(text: "History"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [ListingsTab(), RentalsTab(), HistoryTab()],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, "/addRental");
          },
          child: const Icon(Icons.add),
          tooltip: "Add New Device",
        ),
      ),
    );
  }
}

// Dummy tabs

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("History"));
  }
}
