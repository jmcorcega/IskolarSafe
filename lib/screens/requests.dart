import 'dart:core';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iskolarsafe/components/appbar_header.dart';
import 'package:iskolarsafe/components/entry_details.dart';
import 'package:iskolarsafe/components/request_confirm_dialog.dart';
import 'package:iskolarsafe/components/screen_placeholder.dart';
import 'package:iskolarsafe/models/user_model.dart';
import 'package:iskolarsafe/providers/entries_provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:iskolarsafe/models/entry_model.dart';
import 'package:provider/provider.dart';

enum RequestType { update, delete }

class Requests extends StatefulWidget {
  static const String routeName = "/edit-delete";

  const Requests({super.key});

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Container(
            margin: const EdgeInsets.only(right: 100.0),
            child: const AppBarHeader(
                icon: Symbols.article_rounded, title: "Requests")),
      ),
      body: StreamBuilder(
        stream: context.watch<HealthEntryProvider>().requests,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const ScreenPlaceholder(
              asset: "assets/images/illust_no_connection.svg",
              text: "An error has occured. Try again later.",
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<HealthEntry> updating = [];
          List<HealthEntry> deletion = [];

          for (var data in snapshot.data!.docs) {
            HealthEntry entry =
                HealthEntry.fromJson(data.data() as Map<String, dynamic>);

            if (entry.forDeletion) {
              deletion.add(entry);
            } else {
              updating.add(entry);
            }
          }

          return DefaultTabController(
            length: 2,
            child: Scaffold(
                appBar: const TabBar(tabs: [
                  Tab(
                      child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Symbols.edit_document_rounded),
                      SizedBox(width: 12.0),
                      Text("Edit Requests"),
                    ],
                  )),
                  Tab(
                      child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Symbols.scan_delete_rounded),
                      SizedBox(width: 12.0),
                      Text("Delete Requests"),
                    ],
                  ))
                ]),
                body: TabBarView(
                  children: [
                    _buildRequestsList(updating, RequestType.update),
                    _buildRequestsList(deletion, RequestType.delete)
                  ],
                )),
          );
        },
      ),
    );
  }

  Widget _buildRequestsList(List<HealthEntry> entries, RequestType type) {
    if (entries.isEmpty) {
      return const ScreenPlaceholder(
        asset: "assets/images/illust_list_empty.svg",
        text: "No requests need your attention",
      );
    }

    return ListView.builder(
      itemCount: entries.length,
      itemBuilder: ((context, index) {
        return _buildListTile(entries[index]);
      }),
    );
  }

  Widget _approveRejectButtons(HealthEntry entry) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FilledButton.icon(
          style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary),
          onPressed: () => RequestConfirmDialog.confirmDialog(
            context: context,
            entry: entry,
            type: entry.forDeletion
                ? RequestConfirmDialogType.approveDelete
                : RequestConfirmDialogType.approveEdit,
            modal: false,
          ),
          icon: const Icon(Symbols.done, size: 18.0),
          label: const Text("Approve"),
        ),
        const SizedBox(width: 8.0),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.tertiary),
          onPressed: () => RequestConfirmDialog.confirmDialog(
            context: context,
            entry: entry,
            type: entry.forDeletion
                ? RequestConfirmDialogType.rejectDelete
                : RequestConfirmDialogType.rejectEdit,
            modal: false,
          ),
          icon: const Icon(Symbols.close_rounded),
          label: const Text("Reject"),
        ),
      ],
    );
  }

  Widget _buildListTile(HealthEntry entry) {
    IskolarInfo user = entry.userInfo;
    Widget avatar = user.photoUrl != null
        ? CircleAvatar(
            foregroundImage: CachedNetworkImageProvider(user.photoUrl!),
          )
        : CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(user.firstName.substring(0, 1),
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
          );
    Widget name = Text("${user.firstName} ${user.lastName}",
        style: Theme.of(context).textTheme.titleMedium);

    if (entry.forDeletion) {
      return ListTile(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => DraggableScrollableSheet(
                initialChildSize: 0.45,
                maxChildSize: 0.95,
                minChildSize: 0.4,
                expand: false,
                builder: (context, scrollController) {
                  return SingleChildScrollView(
                    controller: scrollController,
                    child: HealthEntryDetails(entry: entry),
                  );
                }),
          );
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
        leading: SizedBox(
          height: double.infinity,
          child: avatar,
        ),
        minLeadingWidth: 44.0,
        title: name,
        subtitle: _approveRejectButtons(entry),
        isThreeLine: true,
      );
    }

    return ListTile(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => DraggableScrollableSheet(
              initialChildSize: 0.45,
              maxChildSize: 0.95,
              minChildSize: 0.4,
              expand: false,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: HealthEntryDetails(entry: entry),
                );
              }),
        );
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
      leading: SizedBox(
        height: double.infinity,
        child: avatar,
      ),
      minLeadingWidth: 44.0,
      title: name,
      subtitle: _approveRejectButtons(entry),
    );
  }
}
