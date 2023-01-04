import 'package:deep_conference/application/logic/notification_cubit.dart';
import 'package:deep_conference/application/presentation/schedule_detail_screen.dart';
import 'package:deep_conference/constants/my_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants/my_colors.dart';
import '../../domain/models/notification.dart';
import '../widgets/appbar_items.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    context.read<NotificationCubit>().readUserNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: appBarGradient(),
        title: Text(
          AppLocalizations.of(context)!.notificationsScreenTitle,
        ),
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 12,
                );
              },
              padding: const EdgeInsets.only(left: 40, top: 5, right: 40, bottom: 5),
              itemCount: state.notificationList.length,
              itemBuilder: (context, index) {
                return notificationListBuilder(state.notificationList[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget notificationListBuilder(UserNotification notification) {
    return ListTile(
      onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: ((context) => ScheduleDetailScreen(scheduleItem: notification.scheduleItem)))),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      contentPadding: const EdgeInsets.only(right: 5, left: 12, top: 2, bottom: 2),
      tileColor: MyColors.color9B9A9B.withAlpha(55),
      leading: Image.asset(
        MyIcons.getCategoryIcon(notification.scheduleItem.category) ?? MyIcons.appIcon,
        height: 32,
      ),
      title: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: RichText(
                  maxLines: 3,
                  text: TextSpan(
                    text: AppLocalizations.of(context)!.notifLabelStartOneHour,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500, fontSize: 12),
                    children: <TextSpan>[
                      TextSpan(
                        text: notification.title,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.w400, fontSize: 12, overflow: TextOverflow.ellipsis),
                      )
                    ],
                  ),
                ),
              ),
              IconButton(
                padding: const EdgeInsets.all(0),
                icon: const Icon(
                  Icons.close,
                  color: MyColors.colorFFFFFF,
                  size: 20,
                ),
                onPressed: () => context.read<NotificationCubit>().removeNotification(notifId: notification.id),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                timeSinceNotification(notification.time),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w400, fontSize: 12),
                //textAlign: TextAlign.right,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String timeSinceNotification(DateTime time) {
    final String text;
    if (DateTime.now().difference(time).inMinutes < 1) {
      text = "${DateTime.now().difference(time).inSeconds} ${AppLocalizations.of(context)!.notifLabelSeconds}";
    } else if (DateTime.now().difference(time).inMinutes == 1) {
      text = "${DateTime.now().difference(time).inMinutes} ${AppLocalizations.of(context)!.notifLabelMinute}";
    } else if (DateTime.now().difference(time).inMinutes < 60) {
      text = "${DateTime.now().difference(time).inMinutes} ${AppLocalizations.of(context)!.notifLabelMinutes}";
    } else if (DateTime.now().difference(time).inHours == 1) {
      text = "${DateTime.now().difference(time).inHours} ${AppLocalizations.of(context)!.notifLabelHour}";
    } else if (DateTime.now().difference(time).inHours < 24) {
      text = "${DateTime.now().difference(time).inHours} ${AppLocalizations.of(context)!.notifLabelHours}";
    } else if (DateTime.now().difference(time).inDays == 1) {
      text = "${DateTime.now().difference(time).inDays} ${AppLocalizations.of(context)!.notifLabelDay}";
    } else {
      text = "${DateTime.now().difference(time).inDays} ${AppLocalizations.of(context)!.notifLabelDays}";
    }
    return text;
  }
}
