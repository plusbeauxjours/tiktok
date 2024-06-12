import 'package:flutter/material.dart';
import 'package:tiktok/features/videos/models/playback_config_model.dart';
import 'package:tiktok/features/videos/repos/playback_config_repo.dart';

class PlaybackConfigViewModel extends ChangeNotifier {
  final PlaybackConfigRepository _repository;

  late final PlaybackConfigModel _model = PlaybackConfigModel(
    muted: _repository.isMuted(),
    autoplay: _repository.isAutoplay(),
    darkmode: _repository.isDarkmode(),
  );

  PlaybackConfigViewModel(this._repository);

  bool get muted => _model.muted;

  bool get autoplay => _model.autoplay;

  bool get darkmode => _model.darkmode;

  void setMuted(bool value) {
    _repository.setMuted(value);
    _model.muted = value;
    notifyListeners();
  }

  void setAutoplay(bool value) {
    _repository.setAutoplay(value);
    _model.autoplay = value;
    notifyListeners();
  }

  void setDarkmode(bool value) {
    _repository.setDarkmode(value);
    _model.darkmode = value;
    notifyListeners();
  }
}
