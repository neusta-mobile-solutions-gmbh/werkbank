import 'package:example_werkbank/src/example_app/components/relaxation_card.dart';
import 'package:flutter/material.dart';

class RelaxationPage extends StatelessWidget {
  const RelaxationPage({super.key});

  static const _assets = [
    'assets/pexels-lkloeppel-2416585.jpg',
    'assets/pexels-lkloeppel-4783862.jpg',
    'assets/pexels-lkloeppel-4783863.jpg',
    'assets/pexels-lkloeppel-4783869.jpg',
    'assets/pexels-lkloeppel-545964.jpg',
    'assets/pexels-lkloeppel-545979.jpg',
    'assets/pexels-lkloeppel-595899.jpg',
    'assets/pexels-lkloeppel-7777601.jpg',
    'assets/pexels-lkloeppel-7777622.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverSafeArea(
          sliver: SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                for (final (i, asset) in _assets.indexed)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: i == _assets.length - 1 ? 0 : 16.0,
                      ),
                      child: RelaxationCard(
                        image: Image.asset(
                          asset,
                          fit: BoxFit.cover,
                        ),
                        title: const Text('Title'),
                        description: const Text(
                          'Lorem ipsum dolor sit amet, consetetur sadipscing '
                          'elitr, sed diam nonumy eirmod tempor invidunt ut '
                          'labore et dolore magna aliquyam erat, sed diam '
                          'voluptua.',
                        ),
                      ),
                    ),
                  ),
              ]),
            ),
          ),
        ),
      ],
    );
  }
}
