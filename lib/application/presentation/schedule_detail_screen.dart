import 'package:cached_network_image/cached_network_image.dart';
import 'package:deep_conference/application/logic/speaker_state.dart';
import 'package:deep_conference/application/widgets/my_horizontal_divider.dart';
import 'package:deep_conference/application/widgets/my_icon_text_label.dart';
import 'package:deep_conference/constants/my_icons.dart';
import 'package:deep_conference/domain/models/schedule_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../Utilities/utils.dart';
import '../../constants/my_colors.dart';
import '../../domain/models/speaker.dart';
import '../../domain/repositories/speaker_repository.dart';
import '../logic/notification_cubit.dart';
import '../logic/saved_schedule_cubit.dart';
import '../logic/speaker_cubit.dart';
import '../widgets/error_widgets.dart';
import '../widgets/my_category_time_text_label.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timezone/data/latest.dart' as tz;

class ScheduleDetailScreen extends StatefulWidget {
  const ScheduleDetailScreen({super.key, required this.scheduleItem});

  final ScheduleItem scheduleItem;

  @override
  State<ScheduleDetailScreen> createState() => _ScheduleDetailScreenState();
}

class _ScheduleDetailScreenState extends State<ScheduleDetailScreen> {
  @override
  void initState() {
    tz.initializeTimeZones();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SpeakerCubit(context.read<SpeakerRepository>(), [widget.scheduleItem.speakerId]),
      child: Scaffold(
        body: Column(
          children: [
            Stack(
              children: [
                Image.asset(MyIcons.detailsBackground,
                    alignment: Alignment.centerLeft, fit: BoxFit.cover, height: 240, width: double.infinity),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50, left: 40, right: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, size: 30, color: MyColors.color9B9A9B),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          BlocBuilder<SavedScheduleCubit, SavedScheduleState>(
                            builder: (context, state) {
                              if (state.savedItems.contains(widget.scheduleItem)) {
                                return MaterialButton(
                                  child: const Icon(Icons.remove, color: MyColors.color9B9A9B),
                                  onPressed: () => setState(() {
                                    context
                                        .read<SavedScheduleCubit>()
                                        .updatePersonalSchedule(widget.scheduleItem, false);
                                    context
                                        .read<NotificationCubit>()
                                        .removeNotification(itemId: widget.scheduleItem.id);
                                    Utils.showSnackBar(
                                        text: AppLocalizations.of(context)!.itemRemovedLabel,
                                        context: context,
                                        itemDetail: true);
                                  }),
                                );
                              } else {
                                return MaterialButton(
                                  child: const Icon(Icons.add, color: MyColors.color9B9A9B),
                                  onPressed: () => setState(() {
                                    context
                                        .read<SavedScheduleCubit>()
                                        .updatePersonalSchedule(widget.scheduleItem, true);
                                    context.read<NotificationCubit>().createNotification(widget.scheduleItem);
                                    Utils.showSnackBar(
                                        text: AppLocalizations.of(context)!.itemAddedLabel,
                                        context: context,
                                        itemDetail: true);
                                  }),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const MyHorizontalDivider(),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyCategoryTimeTextLabel(
                                category: widget.scheduleItem.category,
                                icon: Icons.circle,
                                startTime: widget.scheduleItem.startTime,
                                endTime: widget.scheduleItem.endTime,
                                textStyle: Theme.of(context).textTheme.labelMedium),
                            MyIconTextLabel(
                                icon: Icons.location_pin,
                                textStyle: Theme.of(context).textTheme.labelMedium,
                                text: widget.scheduleItem.hall.toUpperCase()),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
                        child: RichText(
                          text: TextSpan(
                            text: "${widget.scheduleItem.title} | .${widget.scheduleItem.category.name}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: MyColors.colorFFFFFF, fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            BlocBuilder<SpeakerCubit, SpeakerState>(
              builder: (context, state) {
                if (state.error != null) {
                  return RetryButton(
                    error: state.error,
                    onRetry: () => {
                      context.read<SpeakerCubit>().readSpeakerItems([widget.scheduleItem.speakerId])
                    },
                  );
                }
                if (state.loading) {
                  return const LoadingState();
                }
                if (state.speakers.isEmpty) {
                  return const SizedBox();
                }
                return Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 10),
                        child: Text(AppLocalizations.of(context)!.speakerLabel,
                            textAlign: TextAlign.left,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(fontWeight: FontWeight.w700, color: MyColors.colorFFFFFF, fontSize: 14)),
                      ),
                    ),
                    const MyHorizontalDivider(),
                    ListView.builder(
                      padding: const EdgeInsets.only(top: 10, right: 40, left: 40),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.speakers.length,
                      itemBuilder: (context, index) {
                        return speakerEntry(state.speakers[index]);
                      },
                    ),
                  ],
                );
              },
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 10),
                child: Text(AppLocalizations.of(context)!.descriptionLabel,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(fontWeight: FontWeight.w700, fontSize: 14, color: MyColors.colorFFFFFF)),
              ),
            ),
            const MyHorizontalDivider(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(left: 32, right: 32, top: 10),
                child: SafeArea(
                  top: false,
                  child: Html(data: widget.scheduleItem.description, style: {
                    "*": Style(
                      color: MyColors.colorCACACA,
                      fontSize: const FontSize(14, units: "px"),
                      fontWeight: FontWeight.w400,
                    ),
                    "ul": Style(listStyleType: ListStyleType.NONE),
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget speakerEntry(Speaker speaker) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(40.00),
          child: CachedNetworkImage(
            height: 50.00,
            width: 50.00,
            fit: BoxFit.cover,
            imageUrl: speaker.image,
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(speaker.name,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: MyColors.colorFFFFFF,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        )),
                Text(
                  speaker.title,
                  textAlign: TextAlign.left,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: MyColors.color9B9A9B, fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
