import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants/my_icons.dart';
import '../widgets/appbar_items.dart';

class NFCScreen extends StatefulWidget {
  const NFCScreen({super.key});

  @override
  State<NFCScreen> createState() => _NFCScreenState();
}

class _NFCScreenState extends State<NFCScreen> {
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
