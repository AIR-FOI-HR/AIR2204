part of 'saved_cubit.dart';

@immutable
class SavedState extends Equatable {
  final List<ScheduleItem> savedItems;

  const SavedState({
    required this.savedItems,
  });

  @override
  List<Object?> get props => [savedItems];
}
