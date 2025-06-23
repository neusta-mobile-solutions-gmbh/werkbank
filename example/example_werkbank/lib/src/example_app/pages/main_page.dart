import 'package:example_werkbank/src/example_app/components/fidget_spinner_simulation.dart';
import 'package:example_werkbank/src/example_app/pages/fidgets_page.dart';
import 'package:example_werkbank/src/example_app/pages/profile_page.dart';
import 'package:example_werkbank/src/example_app/pages/relaxation_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          [
            'Relaxation',
            'Fidgets',
            'Profile',
          ][_selectedIndex],
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      body: [
        const RelaxationPage(),
        const FidgetsPage(),
        const ProfilePage(),
      ][_selectedIndex],
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Floating Action Button Pressed')),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.add,
          semanticLabel: 'Add',
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.panorama),
            label: 'Relaxation',
          ),
          NavigationDestination(
            icon: FidgetSpinnerSimulation(
              // Values were optimized using the use case.
              targetTurns: _selectedIndex == 1 ? 2.0 : 0.0,
              mass: 1.0,
              stiffness: 20.0,
              dampingRatio: 1.0,
            ),
            label: 'Fidgets',
          ),
          const NavigationDestination(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
