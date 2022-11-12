part of 'saved_cubit.dart';

@immutable
class SavedState extends Equatable {
  final List<ScheduleItem> savedItems;

  const SavedState({
    required this.savedItems,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [savedItems];
}
