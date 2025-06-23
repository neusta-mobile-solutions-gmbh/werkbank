import 'package:flutter/material.dart';

class RelaxationCard extends StatelessWidget {
  const RelaxationCard({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  final Widget image;
  final Widget title;
  final Widget description;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 350,
      ),
      child: Card(
        elevation: 6.0,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16.0,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: image,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8.0,
                children: [
                  DefaultTextStyle.merge(
                    style: Theme.of(context).textTheme.headlineSmall!,
                    child: title,
                  ),
                  DefaultTextStyle.merge(
                    style: Theme.of(context).textTheme.bodyMedium!,
                    child: description,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
