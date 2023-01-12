import 'package:deep_conference/Utilities/utils.dart';
import 'package:deep_conference/application/presentation/qr_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants/my_colors.dart';
import '../logic/contacts_cubit.dart';

class QRScanScreen extends StatefulWidget {
  const QRScanScreen({super.key});

  @override
  State<QRScanScreen> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  MobileScannerController cameraController = MobileScannerController(facing: CameraFacing.back, torchEnabled: false);

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 20),
            child: Row(
              children: [
                IconButton(
                  color: Colors.white,
                  icon: ValueListenableBuilder(
                    valueListenable: cameraController.torchState,
                    builder: (context, state, child) {
                      switch (state) {
                        case TorchState.off:
                          return const Icon(Icons.flash_off_rounded, color: MyColors.color9B9A9B);
                        case TorchState.on:
                          return const Icon(Icons.flash_on_rounded, color: MyColors.colorFFFFFF);
                      }
                    },
                  ),
                  iconSize: 32,
                  onPressed: () => cameraController.toggleTorch(),
                ),
                IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.switch_camera),
                  iconSize: 32,
                  onPressed: () => cameraController.switchCamera(),
                ),
              ],
            ),
          ),
        ],
      ),
      body: BlocConsumer<ContactsCubit, ContactsState>(
        listener: (context, state) {
          if (state.error != null) {
            Utils.showSnackBar(text: state.error?.message(context), context: context);
          } else if (state.contactAddedAndroid || state.contactAddedIOS) {
            if (state.contactAddedIOS) {
              Utils.showSnackBar(text: AppLocalizations.of(context)!.addedToContacts, context: context);
            }
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              MobileScanner(
                allowDuplicates: false,
                controller: cameraController,
                onDetect: (barcode, args) async {
                  if (barcode.rawValue == null) {
                    Utils.showSnackBar(text: AppLocalizations.of(context)!.failQrScanned, context: context);
                  } else {
                    if (barcode.contactInfo != null) {
                      context.read<ContactsCubit>().addContact(barcode.rawValue!);
                    } else {
                      Utils.showSnackBar(
                          text: AppLocalizations.of(context)!.invalidQrScanned, context: context, warning: true);
                    }
                  }
                },
              ),
              QRScannerOverlay(overlayColour: MyColors.color000000.withOpacity(0.5))
            ],
          );
        },
      ),
    );
  }
}
