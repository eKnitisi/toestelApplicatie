import 'package:flutter/material.dart';
import 'package:flutter_application_intro_mobile/Widgets/listing_tab.dart';

class RentalDashboard extends StatelessWidget {
  final String title;
  const RentalDashboard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Rental Dashboard"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Your Listings"),
              Tab(text: "Rentals"),
              Tab(text: "History"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [ListingsTab(), RentalsTab(), HistoryTab()],
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

class RentalsTab extends StatelessWidget {
  const RentalsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Your Rentals"));
  }
}

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("History"));
  }
}
