part of 'new_temporary_code_bloc.dart';

@immutable
abstract class NewTemporaryCodeEvent {}

class InitialNewTemporaryCodeEvent extends NewTemporaryCodeEvent {}

class LoadDetailTemporaryCodeEvent extends NewTemporaryCodeEvent {
  final String pin;

  LoadDetailTemporaryCodeEvent(this.pin);

}

class DownloadNewTemporaryCodeEvent extends NewTemporaryCodeEvent {
  final BuildContext context;
  final String name;
  final String province;
  final List<ReportPackWithAnswer> list;

  DownloadNewTemporaryCodeEvent(this.context, this.name, this.province,
      this.list);
}

class LoadNewTemporaryCodeEvent extends NewTemporaryCodeEvent {}

class ClearNewTemporaryCodeEvent extends NewTemporaryCodeEvent {}
