import 'package:deep_conference/application/presentation/nfc_screen.dart';
import 'package:deep_conference/application/presentation/qr_scan_screen.dart';
import 'package:deep_conference/application/widgets/appbar_items.dart';
import 'package:deep_conference/application/widgets/more_menu_widget.dart';
import 'package:deep_conference/constants/my_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../Utilities/utils.dart';
import '../../constants/my_icons.dart';
import '../logic/contacts_cubit.dart';
import '../logic/user_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    context.read<UserCubit>().getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: appBarGradient(),
        title: Text(
          AppLocalizations.of(context)!.profileScreenTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        leading: const MoreMenuWidget(),
        actions: [
          notificationBell(context),
        ],
      ),
      body: BlocConsumer<UserCubit, UserState>(
        listener: (context, state) {
          if (state.error != null) {
            Utils.showSnackBar(text: state.error?.message(context), context: context, warning: true);
          }
          if (state.userUpdated) {
            Utils.showSnackBar(text: AppLocalizations.of(context)!.userUpdateSuccessful, context: context);
          }
        },
        builder: (context, state) {
          if (state.userData) {
            return ListView(
              padding: const EdgeInsets.only(top: 27, left: 40, right: 40),
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 15),
                  width: 300,
                  decoration: BoxDecoration(
                    color: MyColors.color772DFF.withAlpha(15),
                    borderRadius: BorderRadius.circular(15),
                    image: const DecorationImage(
                      image: AssetImage(MyIcons.profileScreenQrBackground),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: QrImage(
                          size: 180,
                          backgroundColor: MyColors.colorFFFFFF,
                          data: context
                              .read<ContactsCubit>()
                              .userDataToVCard(state.firstName, state.lastName, state.phoneNumber, state.email),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text("${state.firstName} ${state.lastName}",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: MyColors.color9B9A9B, fontSize: 20, overflow: TextOverflow.visible)),
                      const SizedBox(
                        height: 15,
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColors.color772DFF,
                          padding: const EdgeInsets.only(right: 10, left: 10, top: 8, bottom: 8),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const NFCScreen(),
                            ),
                          );
                        },
                        icon: Image.asset(
                          MyIcons.nfcIcon,
                          height: 24,
                        ),
                        label: Text(AppLocalizations.of(context)!.shareWithNFC,
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 14)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 35),
                profileScreenData(label: AppLocalizations.of(context)!.profileEmailLabel, title: true),
                const SizedBox(height: 5),
                profileScreenData(label: state.email, title: false),
                const SizedBox(height: 35),
                profileScreenData(label: AppLocalizations.of(context)!.profilePhoneNumberLabel, title: true),
                const SizedBox(height: 5),
                profileScreenData(label: state.phoneNumber, title: false),
                const SizedBox(height: 35),
                profileScreenData(label: AppLocalizations.of(context)!.profileCompanyUrlLabel, title: true),
                const SizedBox(height: 5),
                profileScreenData(label: state.companyUrl, title: false),
                const SizedBox(height: 35),
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.color772DFF,
                      padding: const EdgeInsets.only(right: 10, left: 10, top: 8, bottom: 8),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const QRScanScreen(),
                        ),
                      );
                    },
                    icon: Image.asset(
                      MyIcons.qrIcon,
                      height: 24,
                    ),
                    label: Text(AppLocalizations.of(context)!.addNewContact,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 14)),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget profileScreenData({required String label, required bool title}) {
    if (title) {
      return Center(
          child: Text(label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: MyColors.color772DFF)));
    } else {
      return Center(
          child: Text(label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(overflow: TextOverflow.visible)));
    }
  }
}
