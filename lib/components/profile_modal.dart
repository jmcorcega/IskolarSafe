import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iskolarsafe/components/appbar_header.dart';
import 'package:iskolarsafe/components/health_badge.dart';
import 'package:iskolarsafe/models/entry_model.dart';
import 'package:iskolarsafe/models/user_model.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProfileModal extends StatelessWidget {
  final Map<String, dynamic> data;
  const ProfileModal(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HealthEntry entry = HealthEntry.fromJson(data);
    IskolarInfo user = entry.userInfo;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 64.0),
        (entry.verdict == IskolarHealthStatus.healthy)
            ? QrImageView(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.all(18.0),
                data: data.toString(),
                version: QrVersions.auto,
                size: MediaQuery.of(context).size.width * 0.75,
              )
            : SizedBox.square(
                dimension: MediaQuery.of(context).size.width * 0.75,
                child: Stack(children: [
                  Container(
                    height: MediaQuery.of(context).size.width * 0.75,
                    width: MediaQuery.of(context).size.width * 0.75,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Symbols.sick_rounded,
                          size: 84.0,
                          color: Theme.of(context).colorScheme.inverseSurface,
                        ),
                        const SizedBox(height: 18.0),
                        Text(
                          "Cannot generate a QR code because you are sick.",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium!.apply(
                              fontWeightDelta: 1,
                              color:
                                  Theme.of(context).colorScheme.inverseSurface),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
        const SizedBox(height: 24.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            user.photoUrl != null
                ? CircleAvatar(
                    foregroundImage: CachedNetworkImageProvider(user.photoUrl!),
                  )
                : CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      user.firstName.substring(0, 1),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
            const SizedBox(width: 16.0),
            Wrap(
              direction: Axis.vertical,
              children: [
                Text(
                  "${user.firstName} ${user.lastName}",
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .apply(fontSizeDelta: 2),
                ),
                Text(user.studentNumber,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .apply(fontWeightDelta: -1)),
              ],
            ),
          ],
        ),
        HealthBadge(entry.verdict),
        const SizedBox(height: 32.0),
        Divider(height: 1.0),
        ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 32.0,
            vertical: 4.0,
          ),
          leading: Icon(Symbols.account_circle_rounded),
          title: Text(user.userName),
          subtitle: Text(
            "Username",
            style: Theme.of(context).textTheme.labelSmall,
          ),
          onLongPress: () async {
            await Clipboard.setData(ClipboardData(text: user.userName));
            if (context.mounted) {
              Fluttertoast.showToast(
                msg: "Copied to your clipboard.",
              );
            }
          },
        ),
        Divider(height: 1.0),
        ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 32.0,
            vertical: 4.0,
          ),
          leading: Icon(Symbols.badge_rounded),
          title: Text(user.studentNumber),
          subtitle: Text(
            "Student number",
            style: Theme.of(context).textTheme.labelSmall,
          ),
          onLongPress: () async {
            await Clipboard.setData(ClipboardData(text: user.studentNumber));
            if (context.mounted) {
              Fluttertoast.showToast(
                msg: "Copied to your clipboard.",
              );
            }
          },
        ),
        Divider(height: 1.0),
        ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 32.0,
            vertical: 4.0,
          ),
          leading: Icon(Symbols.school_rounded),
          title: Text(user.course),
          subtitle: Text(
            "Course",
            style: Theme.of(context).textTheme.labelSmall,
          ),
          onLongPress: () async {
            await Clipboard.setData(ClipboardData(text: user.course));
            if (context.mounted) {
              Fluttertoast.showToast(
                msg: "Copied to your clipboard.",
              );
            }
          },
        ),
        Divider(height: 1.0),
        ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 32.0,
            vertical: 4.0,
          ),
          leading: Icon(Symbols.domain_rounded),
          title: Text(user.college),
          subtitle: Text(
            "College",
            style: Theme.of(context).textTheme.labelSmall,
          ),
          onLongPress: () async {
            await Clipboard.setData(ClipboardData(text: user.college));
            if (context.mounted) {
              Fluttertoast.showToast(
                msg: "Copied to your clipboard.",
              );
            }
          },
        ),
        user.condition.isNotEmpty ? Divider(height: 1.0) : Container(),
        user.condition.isNotEmpty
            ? ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 4.0,
                ),
                leading: Icon(Symbols.monitor_heart_rounded),
                title: Wrap(
                  spacing: 5.0,
                  children: user.condition.map((String condition) {
                    return Chip(
                      label: Text(condition),
                    );
                  }).toList(),
                ),
                subtitle: Text(
                  "Conditions",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              )
            : Container(),
        Divider(height: 1.0),
        user.allergies.isNotEmpty
            ? ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 4.0,
                ),
                leading: Icon(Symbols.masks_rounded),
                title: Wrap(
                  spacing: 5.0,
                  children: user.allergies.map((String allergy) {
                    return Chip(
                      label: Text(allergy),
                    );
                  }).toList(),
                ),
                subtitle: Text(
                  "Allergies",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              )
            : Container(),
        user.allergies.isNotEmpty ? Divider(height: 1.0) : Container(),
      ],
    );
  }
}
