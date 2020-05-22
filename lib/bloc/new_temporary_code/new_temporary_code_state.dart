part of 'new_temporary_code_bloc.dart';

@immutable
abstract class NewTemporaryCodeState {

  final TemporaryCode code;

  NewTemporaryCodeState(this.code);


}

class InitialNewTemporaryCodeState extends NewTemporaryCodeState {
  InitialNewTemporaryCodeState() : super(null);
}

class NonNewTemporaryCodeState extends NewTemporaryCodeState {
  NonNewTemporaryCodeState() : super(null);
}

class LoadingNewTemporaryCodeState extends NewTemporaryCodeState {
  LoadingNewTemporaryCodeState() : super(null);
}

class LoadedDetailNewTemporaryCodeState extends NewTemporaryCodeState {
  LoadedDetailNewTemporaryCodeState(TemporaryCode code) : super(code);
}