part of 'admin_main_bloc.dart';

@immutable
abstract class AdminMainState {}

class InitialAdminMainState extends AdminMainState {
  @override
  String toString() => 'InitialAdminMainState';
}

class OverviewPageState extends AdminMainState {
  @override
  String toString() => 'OverviewPageState';
}

class ActivityAdminMainState extends AdminMainState {
  @override
  String toString() => 'ActivityAdminMainState';
}

class AccountPageState extends AdminMainState {
  @override
  String toString() => 'NewsAdminMainState';
}

class TemporaryCodePageState extends AdminMainState {

  TemporaryCodePageState();

  @override
  String toString() => 'TemporaryCodePageState';
}

class DatabaseAdminMainState extends AdminMainState {}
