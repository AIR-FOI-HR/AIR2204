import 'package:deep_conference/Utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

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
        title: const Text('Scan a QR code'),
        actions: [
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
            iconSize: 24,
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.switch_camera),
            iconSize: 24,
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: BlocConsumer<ContactsCubit, ContactsState>(
        listener: (context, state) {
          if (state.contactAdded) {
            if (state.firstName != "" || state.lastName != "") {
              Utils.showSnackBar("${state.firstName} ${state.lastName} added to your contacts!", context);
            } else {
              Utils.showSnackBar("successfully added to your contacts!", context);
            }
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return MobileScanner(
            allowDuplicates: false,
            controller: cameraController,
            onDetect: (barcode, args) async {
              if (barcode.rawValue == null) {
                Utils.showSnackBar("Failed to scan a barcode", context);
              } else {
                final String? firstName = barcode.contactInfo?.name?.first;
                final String? lastName = barcode.contactInfo?.name?.last;
                final String? phoneNumber = barcode.contactInfo?.phones?[0].number;
                //await context.read<ContactsCubit>().addContact(firstName, lastName, phoneNumber);
                await context.read<ContactsCubit>().addContact(firstName, lastName, phoneNumber);
              }
            },
          );
        },
      ),
    );
  }

  // Future<void> addContact(String? firstName, String? lastName, String? phoneNumber) async {
  //   final PermissionStatus permissionStatus = await Permission.contacts.request();
  //   if (permissionStatus.isGranted) {
  //     final Contact contact = Contact.fromVCard(
  //       'BEGIN:VCARD\n'
  //       'VERSION:3.0\n'
  //       'N:$lastName;$firstName;;;\n'
  //       'TEL;TYPE=HOME:$phoneNumber\n'
  //       'END:VCARD',
  //     );

  //     await FlutterContacts.insertContact(contact);
  //   }
  // }
}
