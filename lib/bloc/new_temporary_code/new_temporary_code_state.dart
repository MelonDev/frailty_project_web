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

class DownloadingNewTemporaryCodeState extends NewTemporaryCodeState {
  DownloadingNewTemporaryCodeState() : super(null);
}

class LoadedDetailNewTemporaryCodeState extends NewTemporaryCodeState {

  final bool active;

  LoadedDetailNewTemporaryCodeState(TemporaryCode code,this.active) : super(code);
}