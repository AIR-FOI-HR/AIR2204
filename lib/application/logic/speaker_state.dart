
import 'package:equatable/equatable.dart';

import '../../domain/models/speaker.dart';

class SpeakerState extends Equatable {
  final List<Speaker> speakers;
  final bool loading;
  final dynamic error;
  factory SpeakerState.initial() => const SpeakerState(speakers: [], loading: true, error: null);

  const SpeakerState({required this.speakers, this.loading = false, this.error});

  @override
  List<Object?> get props => [speakers, loading, error];
}
