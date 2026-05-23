import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:poseweave/core/errors/failures.dart';
import 'package:poseweave/data/services/api_key_service.dart';

part 'settings_bloc.freezed.dart';

@freezed
class SettingsEvent with _$SettingsEvent {
  const factory SettingsEvent.load() = LoadSettings;
  const factory SettingsEvent.saveKey(String key) = SaveKey;
  const factory SettingsEvent.clearKey() = ClearKey;
}

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(false) bool hasKey,
    @Default(false) bool busy,
    String? message,
  }) = _SettingsState;
}

/// Manages the BYOK API key in Settings (separate from `PoseBloc` — different
/// lifecycle, app-wide rather than per-screen).
@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(this._keys) : super(const SettingsState()) {
    on<LoadSettings>(_onLoad);
    on<SaveKey>(_onSave);
    on<ClearKey>(_onClear);
  }

  final ApiKeyService _keys;

  Future<void> _onLoad(LoadSettings event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(hasKey: await _keys.hasKey()));
  }

  Future<void> _onSave(SaveKey event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(busy: true, message: null));
    final Either<Failure, Unit> test = await _keys.testKey(event.key);
    await test.fold(
      (Failure f) async =>
          emit(state.copyWith(busy: false, message: f.message)),
      (_) async {
        await _keys.saveKey(event.key);
        emit(state.copyWith(busy: false, hasKey: true, message: 'Key saved'));
      },
    );
  }

  Future<void> _onClear(ClearKey event, Emitter<SettingsState> emit) async {
    await _keys.clearKey();
    emit(state.copyWith(hasKey: false, message: 'Key cleared'));
  }
}
