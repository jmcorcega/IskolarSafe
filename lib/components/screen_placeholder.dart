import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ScreenPlaceholder extends StatelessWidget {
  final String asset;
  final String text;
  final Widget? button;
  const ScreenPlaceholder(
      {Key? key, required this.asset, required this.text, this.button})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      // Show a message where the user can add an entry if list is empty
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            width: MediaQuery.of(context).size.width * 0.75,
            asset,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 12.0),
          Text(
            text,
            style: Theme.of(context).textTheme.titleMedium!.apply(
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.75),
                ),
          ),
          (button != null) ? const SizedBox(height: 16.0) : const SizedBox(),
          (button != null) ? button! : const SizedBox(),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
