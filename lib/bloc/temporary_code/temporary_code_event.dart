part of 'temporary_code_bloc.dart';

@immutable
abstract class TemporaryCodeEvent {
  final Function function;

  TemporaryCodeEvent(this.function);
}

class InitialTemporaryCodeEvent extends TemporaryCodeEvent {
  InitialTemporaryCodeEvent() : super(null);

}

class RequestNewTemporaryCodeEvent extends TemporaryCodeEvent {
  final TemporaryCodeState lastState;

  RequestNewTemporaryCodeEvent(this.lastState) : super(null);
}

class RequestAllPinTemporaryCodeEvent extends TemporaryCodeEvent {
  RequestAllPinTemporaryCodeEvent(Function function) : super(function);
}

class RequestAvailablePinTemporaryCodeEvent extends TemporaryCodeEvent {
  RequestAvailablePinTemporaryCodeEvent(Function function) : super(function);
}

class RequestNotAvailablePinTemporaryCodeEvent extends TemporaryCodeEvent {
  RequestNotAvailablePinTemporaryCodeEvent(Function function) : super(function);
}