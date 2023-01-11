import 'package:deep_conference/application/logic/contacts_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nfc_manager/nfc_manager.dart';
import '../../Utilities/utils.dart';
import '../../constants/my_icons.dart';
import '../widgets/appbar_items.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NFCScreen extends StatefulWidget {
  const NFCScreen({super.key});

  @override
  State<NFCScreen> createState() => _NFCScreenState();
}

class _NFCScreenState extends State<NFCScreen> {
  @override
  void initState() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      Ndef? ndef = Ndef.from(tag);
      if (ndef == null) {
        Utils.showSnackBar(text: "The tag must be in NDEF format", context: context);
        return;
      } else {
        final payload = ndef.cachedMessage!.records.first.payload;
        String payloadAsString = String.fromCharCodes(payload).substring(3);
        context.read<ContactsCubit>().addContact(payloadAsString);
        Utils.showSnackBar(text: "Tag: $payloadAsString", context: context);
        return;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        leading: backArrow(context),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              MyIcons.nfcSharing,
              width: 300,
            ),
            Text(
              AppLocalizations.of(context)!.shareContactInfoLabel,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}
