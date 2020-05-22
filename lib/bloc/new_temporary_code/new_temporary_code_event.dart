part of 'new_temporary_code_bloc.dart';

@immutable
abstract class NewTemporaryCodeEvent {}

class InitialNewTemporaryCodeEvent extends NewTemporaryCodeEvent {}

class LoadDetailTemporaryCodeEvent extends NewTemporaryCodeEvent {
  final String pin;

  LoadDetailTemporaryCodeEvent(this.pin);

}

class LoadNewTemporaryCodeEvent extends NewTemporaryCodeEvent {}

class ClearNewTemporaryCodeEvent extends NewTemporaryCodeEvent {}
