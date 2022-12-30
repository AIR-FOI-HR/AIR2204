import 'dart:io';

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
          if (state.contactAdded) {
            if (state.error != null) {
              Utils.showSnackBar(text: state.error.message, context: context);
            }
            if (state.contactAdded) {
              if (Platform.isIOS) {
                Utils.showSnackBar(text: AppLocalizations.of(context)!.addedToContacts, context: context);
              }
              Navigator.of(context).pop();
            }
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
                      final String? firstName = barcode.contactInfo?.name?.first;
                      final String? lastName = barcode.contactInfo?.name?.last;
                      String? phoneNumber = "";
                      String? email = "";
                      if (barcode.contactInfo!.phones!.isNotEmpty) {
                        phoneNumber = barcode.contactInfo?.phones?[0].number;
                      }
                      if (barcode.contactInfo!.emails.isNotEmpty) {
                        email = barcode.contactInfo?.emails[0].address;
                      }
                      if (Platform.isAndroid) {
                        await context.read<ContactsCubit>().addContactAndroid(firstName, lastName, phoneNumber, email);
                      } else if (Platform.isIOS) {
                        await context.read<ContactsCubit>().addContactIOS(firstName, lastName, phoneNumber, email);
                      }
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
