import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../application/logic/navigation_cubit.dart';
import '../constants/my_colors.dart';
import '../constants/nav_bar_items.dart';

class Utils {
  static showSnackBar({required String? text, required BuildContext context, bool? itemDetail, bool? warning}) {
    if (text == null) return;

    final snackBar = SnackBar(
      content: warning != null
          ? Row(children: [
              const Icon(Icons.warning, color: MyColors.colorFB65BA, size: 20),
              const SizedBox(width: 10),
              Expanded(
                  child: Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(overflow: TextOverflow.visible),
                maxLines: 2,
              )),
            ])
          : Text(text, style: Theme.of(context).textTheme.bodyMedium!.copyWith(overflow: TextOverflow.visible)),
      backgroundColor: MyColors.color3A3A3A,
      behavior: SnackBarBehavior.floating,
      margin: itemDetail != null
          ? const EdgeInsets.only(left: 20, right: 20)
          : const EdgeInsets.only(bottom: 60, left: 20, right: 20),
      action: itemDetail != null
          ? SnackBarAction(
              label: 'My Schedule',
              textColor: MyColors.colorFB65BA,
              onPressed: () {
                Navigator.of(context).pop();
                context.read<NavigationCubit>().getNavBarItem(NavbarItem.mySchedule);
              },
            )
          : null,
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
