import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nfc_manager/nfc_manager.dart';

import '../../Utilities/utils.dart';
import '../../constants/my_icons.dart';
import '../widgets/appbar_items.dart';

class NFCScreen extends StatefulWidget {
  const NFCScreen({super.key});

  @override
  State<NFCScreen> createState() => _NFCScreenState();
}

class _NFCScreenState extends State<NFCScreen> {
  // void emit() async {
  //   final nfcStatus = await NfcEmulator.nfcStatus;
  //   if (nfcStatus == NfcStatus.enabled) {
  //     await NfcEmulator.startNfcEmulator("666B65630001", "cd22c716", "79e64d05ed6475d3acf405d6a9cd506b");
  //   }
  // }

  // void stopEmit() async {
  //   await NfcEmulator.stopNfcEmulator();
  // }

  @override
  void initState() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      Ndef? ndef = Ndef.from(tag);
      if (ndef == null) {
        Utils.showSnackBar(text: "Tag: ${tag.data}", context: context);
        return;
      } else {
        Utils.showSnackBar(text: "Compatible tag found", context: context);
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
            // ElevatedButton.icon(
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: MyColors.color772DFF,
            //     padding: const EdgeInsets.only(right: 10, left: 10, top: 8, bottom: 8),
            //   ),
            //   onPressed: () {
            //     emit();
            //   },
            //   icon: Image.asset(
            //     MyIcons.qrIcon,
            //     height: 24,
            //   ),
            //   label:
            //       Text("Emit your contact info", style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 14)),
            // ),
            // ElevatedButton.icon(
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: MyColors.color772DFF,
            //     padding: const EdgeInsets.only(right: 10, left: 10, top: 8, bottom: 8),
            //   ),
            //   onPressed: () {
            //     stopEmit();
            //   },
            //   icon: Image.asset(
            //     MyIcons.qrIcon,
            //     height: 24,
            //   ),
            //   label: Text("Stop emmiting", style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 14)),
            // ),
          ],
        ),
      ),
    );
  }
}
