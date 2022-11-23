import 'package:deep_conference/domain/repositories/schedule_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/models/schedule_items.dart';
part 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  ScheduleCubit() : super(const ScheduleState(scheduleItems: []));

  final scheduleRepository = ScheduleRepository();

  Future readScheduleItems() async {
    final data = await scheduleRepository.getScheduleList();
    emit(ScheduleState(scheduleItems: data));
  }
}
