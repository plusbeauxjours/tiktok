import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/features/videos/models/playback_config_model.dart';
import 'package:tiktok/features/videos/repos/playback_config_repo.dart';

class PlaybackConfigViewModel extends Notifier<PlaybackConfigModel> {
  final PlaybackConfigRepository _repository;

  PlaybackConfigViewModel(this._repository);

  void setMuted(bool value) {
    _repository.setMuted(value);
    state = PlaybackConfigModel(
      muted: value,
      autoplay: state.autoplay,
      darkmode: state.darkmode,
    );
  }

  void setAutoplay(bool value) {
    state = PlaybackConfigModel(
      muted: state.muted,
      autoplay: value,
      darkmode: state.darkmode,
    );
  }

  void setDarkmode(bool value) {
    state = PlaybackConfigModel(
      muted: state.muted,
      autoplay: state.autoplay,
      darkmode: value,
    );
  }

  @override
  PlaybackConfigModel build() {
    return PlaybackConfigModel(
      muted: _repository.isMuted(),
      autoplay: _repository.isAutoplay(),
      darkmode: _repository.isDarkmode(),
    );
  }
}

final playbackConfigProvider =
    NotifierProvider<PlaybackConfigViewModel, PlaybackConfigModel>(
  () => throw UnimplementedError(),
);
