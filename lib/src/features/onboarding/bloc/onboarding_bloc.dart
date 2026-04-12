import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../services/session_service.dart';
import '../../../services/mnemonic_codec.dart';

// Events
abstract class OnboardingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateAccountRequested extends OnboardingEvent {}

class RestoreAccountRequested extends OnboardingEvent {
  final String recoveryPhrase;
  RestoreAccountRequested(this.recoveryPhrase);

  @override
  List<Object?> get props => [recoveryPhrase];
}

class DisplayNameSubmitted extends OnboardingEvent {
  final String name;
  DisplayNameSubmitted(this.name);

  @override
  List<Object?> get props => [name];
}

// States
abstract class OnboardingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnboardingInitial extends OnboardingState {}

class OnboardingLoading extends OnboardingState {}

class AccountCreated extends OnboardingState {
  final String sessionId;
  AccountCreated(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

class AccountRestored extends OnboardingState {
  final String sessionId;
  AccountRestored(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

class DisplayNameSaved extends OnboardingState {}

class OnboardingError extends OnboardingState {
  final String message;
  OnboardingError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final SessionService _sessionService;

  OnboardingBloc(this._sessionService) : super(OnboardingInitial()) {
    on<CreateAccountRequested>(_onCreateAccount);
    on<RestoreAccountRequested>(_onRestoreAccount);
    on<DisplayNameSubmitted>(_onDisplayNameSubmitted);
  }

  Future<void> _onCreateAccount(
    CreateAccountRequested event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(OnboardingLoading());
    try {
      final sessionId = await _sessionService.createAccount();
      emit(AccountCreated(sessionId));
    } catch (e) {
      emit(OnboardingError(e.toString()));
    }
  }

  Future<void> _onRestoreAccount(
    RestoreAccountRequested event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(OnboardingLoading());
    try {
      final sessionId = await _sessionService.restoreAccount(event.recoveryPhrase);
      emit(AccountRestored(sessionId));
    } on MnemonicDecodingError catch (e) {
      emit(OnboardingError(e.description));
    } catch (e) {
      emit(OnboardingError(e.toString()));
    }
  }

  Future<void> _onDisplayNameSubmitted(
    DisplayNameSubmitted event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(OnboardingLoading());
    try {
      await _sessionService.setDisplayName(event.name);
      emit(DisplayNameSaved());
    } catch (e) {
      emit(OnboardingError(e.toString()));
    }
  }
}
