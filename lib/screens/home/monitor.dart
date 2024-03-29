import 'package:flutter/material.dart';
import 'package:iskolarsafe/components/screen_placeholder.dart';
import 'package:iskolarsafe/providers/accounts_provider.dart';
import 'package:iskolarsafe/components/app_options.dart';
import 'package:iskolarsafe/components/appbar_header.dart';
import 'package:iskolarsafe/components/requests_button.dart';
import 'package:iskolarsafe/components/health_confirm_dialog.dart';
import 'package:iskolarsafe/components/user_details.dart';
import 'package:iskolarsafe/models/user_model.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

class Monitor extends StatefulWidget {
  static const String routeName = "/";

  const Monitor({super.key});

  @override
  State<Monitor> createState() => _MonitorState();
}

class _MonitorState extends State<Monitor> with AutomaticKeepAliveClientMixin {
  @override
  bool wantKeepAlive = true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        leading: EditRequestButton(),
        centerTitle: true,
        title: const AppBarHeader(
          icon: Symbols.coronavirus_rounded,
          title: "Under Monitoring",
          hasAction: false,
        ),
        actions: const [
          AppOptions(),
        ],
      ),
      body: StreamBuilder(
          stream: context.watch<AccountsProvider>().monitored,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("Error encountered ${snapshot.error}"));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const ScreenPlaceholder(
                asset: "assets/images/illust_no_monitored.svg",
                text: "No users under monitoring",
              );
            }

            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data?.docs.length,
                itemBuilder: ((context, index) {
                  IskolarInfo user = IskolarInfo.fromJson(
                      snapshot.data?.docs[index].data()
                          as Map<String, dynamic>);
                  user.id = snapshot.data?.docs[index].id;
                  return ListTile(
                    onTap: () => UserDetails.showSheet(context, user),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 24.0),
                    title: Text(
                      "${user.firstName} ${user.lastName}",
                    ),
                    subtitle: _getHealthStatus(true),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 34.0,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(0),
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary),
                            onPressed: () => HealthConfirmDialog.confirmDialog(
                                context: context,
                                user: user,
                                type: HealthConfirmDialogType.endMonitoring),
                            child:
                                const Icon(Symbols.close_rounded, size: 18.0),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        SizedBox(
                          width: 34.0,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(0),
                                foregroundColor:
                                    Theme.of(context).colorScheme.tertiary),
                            onPressed: () => HealthConfirmDialog.confirmDialog(
                                context: context,
                                user: user,
                                type: HealthConfirmDialogType.startQuarantine),
                            child: const Icon(Symbols.medical_mask_rounded),
                          ),
                        ),
                      ],
                    ),
                  );
                }));
          }),
    );
  }

  Widget _getHealthStatus(bool status) {
    String safe = "Safe for Work";
    String symptoms = "Has Symptoms";
    if (status) {
      return Row(
        children: [
          const Icon(Symbols.sick, color: Colors.red, size: 20.0),
          const SizedBox(width: 6.0),
          Text(
            symptoms,
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .apply(color: Colors.red),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          const Icon(Symbols.health_and_safety_rounded,
              color: Colors.green, size: 20.0),
          const SizedBox(width: 6.0),
          Text(
            safe,
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .apply(color: Colors.green),
          ),
        ],
      );
    }
  }
}
