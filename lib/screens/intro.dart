// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_walkthrough_screen/flutter_walkthrough_screen.dart';
import 'package:iskolarsafe/providers/preferences_provider.dart';
import 'package:iskolarsafe/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:svg_provider_cache/svg_provider_cache.dart';

class Intro extends StatelessWidget {
  static const String routeName = "/";
  const Intro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.watch<PreferencesProvider>().getBool("is_shown_intro"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(),
          );
        }

        if (snapshot.data == true) return Home();
        return _buildIntroScreen(context);
      },
    );
  }

  Widget _buildIntroScreen(BuildContext context) {
    return IntroScreen(
      pageRoute: MaterialPageRoute(
        builder: (context) {
          return Home();
        },
      ),
      onbordingDataList: [
        OnbordingData(
          image: Svg('assets/images/illust_welcome_1.svg'),
          titleText: Column(
            children: [
              Text(
                "Welcome to",
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8.0),
              Text(
                "IskolarSafe",
                style: Theme.of(context).textTheme.titleLarge!.apply(
                      fontWeightDelta: 1,
                      fontSizeDelta: 4,
                    ),
              ),
            ],
          ),
          descText: Container(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            alignment: Alignment.center,
            child: Text(
              "Welcome to the health tracing app by the Isko/Iska, for the Isko/Iska.",
              textAlign: TextAlign.center,
            ),
          ),
        ),
        OnbordingData(
          image: Svg('assets/images/illust_welcome_2.svg'),
          titleText: Column(
            children: [
              Text(
                "IskolarSafe makes it easy to track your health",
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8.0),
              Text(
                "Walk in and Scan",
                style: Theme.of(context).textTheme.titleLarge!.apply(
                      fontWeightDelta: 1,
                      fontSizeDelta: 4,
                    ),
              ),
            ],
          ),
          descText: Container(
            padding: EdgeInsets.symmetric(horizontal: 28.0),
            alignment: Alignment.center,
            child: Text(
              "Simply make your entry for today, and you can use it to enter premises around the university.",
              textAlign: TextAlign.center,
            ),
          ),
        ),
        OnbordingData(
          image: Svg('assets/images/illust_welcome_3.svg'),
          titleText: Column(
            children: [
              Text(
                "IskolarSafe makes it easy to contact trace",
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8.0),
              Text(
                "Scan and Manage",
                style: Theme.of(context).textTheme.titleLarge!.apply(
                      fontWeightDelta: 1,
                      fontSizeDelta: 4,
                    ),
              ),
            ],
          ),
          descText: Container(
            padding: EdgeInsets.symmetric(horizontal: 28.0),
            alignment: Alignment.center,
            child: Text(
              "It's now easier to manage your users and their health status.",
              textAlign: TextAlign.center,
            ),
          ),
        ),
        OnbordingData(
          image: Svg('assets/images/illust_welcome_4.svg'),
          titleText: Column(
            children: [
              Text(
                "Experience IskolarSafe today",
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8.0),
              Text(
                "Stay safe!",
                style: Theme.of(context).textTheme.titleLarge!.apply(
                      fontWeightDelta: 1,
                      fontSizeDelta: 4,
                    ),
              ),
            ],
          ),
          descText: Container(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            alignment: Alignment.center,
            child: Text(
              "Sign up and experience IskolarSafe today.\n",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
      colors: [
        Theme.of(context).colorScheme.primary,
        Theme.of(context).colorScheme.secondary,
        Theme.of(context).colorScheme.tertiary,
      ],
      nextButton: Text(
        "NEXT",
        style: Theme.of(context).textTheme.labelLarge!.apply(
              fontWeightDelta: 1,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
      lastButton: Text(
        "GOT IT",
        style: Theme.of(context).textTheme.labelLarge!.apply(
              fontWeightDelta: 1,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
      skipButton: Text(
        "SKIP",
        style: Theme.of(context).textTheme.labelLarge!.apply(
              fontWeightDelta: 1,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
      selectedDotColor: Theme.of(context).colorScheme.primary,
      unSelectdDotColor: Theme.of(context)
          .colorScheme
          .onSurfaceVariant
          .withAlpha((255 * 0.25).toInt()),
    );
  }
}
