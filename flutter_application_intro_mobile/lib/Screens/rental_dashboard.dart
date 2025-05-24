import 'package:flutter/material.dart';
import 'package:flutter_application_intro_mobile/Widgets/listing_tab.dart';
import 'package:flutter_application_intro_mobile/Widgets/rent_request_tab.dart';
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
                Tab(text: "Rent Requests"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [ListingsTab(), RentalsTab(), RentRequestTab()],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, "/addRental");
          },
          tooltip: "Add New Device",
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
