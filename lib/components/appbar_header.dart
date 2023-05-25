import 'package:flutter/material.dart';

class AppBarHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool hasAction;
  final bool isCenter;

  const AppBarHeader(
      {super.key,
      required this.icon,
      required this.title,
      this.hasAction = true,
      this.isCenter = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: (!hasAction) ? MainAxisSize.min : MainAxisSize.max,
      mainAxisAlignment:
          (isCenter) ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        (hasAction)
            ? const IconButton(
                icon: CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.transparent,
                ),
                onPressed: null,
              )
            : const SizedBox(),
        Icon(
          icon,
          size: 30.0,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        const SizedBox(width: 15.0),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium!.apply(
                fontSizeDelta: 3,
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
      ],
    );
  }
}
