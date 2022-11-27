import 'package:deep_conference/application/logic/speaker_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/speaker_repository.dart';

class SpeakerCubit extends Cubit<SpeakerState> {
  SpeakerCubit(this.speakerRepository, this.speakerIds)
      : super(SpeakerState.initial()) {
    if (speakerIds.first != "") {
      readSpeakerItems(speakerIds);
    } else {
      emit(const SpeakerState(speakers: []));
    }
  }

  final SpeakerRepository speakerRepository;
  final List<String> speakerIds;

  void readSpeakerItems(List<String> speakerIds) async {
    try {
      final data = await speakerRepository.getSpeakerList(speakerIds);
      emit(SpeakerState(speakers: data));
    } catch (e) {
      emit(SpeakerState(speakers: const [], error: e));
    }
  }
}
