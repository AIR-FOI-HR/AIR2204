import 'package:deep_conference/domain/repositories/schedule_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/models/schedule_items.dart';
part 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  ScheduleCubit(this.scheduleRepository) : super(const ScheduleState());

  final ScheduleRepository scheduleRepository;

  void readScheduleItems() async {
    emit(const ScheduleState());
    try {
      final data = await scheduleRepository.getScheduleList();
      emit(ScheduleState(scheduleItems: data, loading: false));
    } catch (e) {
      emit(ScheduleState(error: e));
    }
  }
}
