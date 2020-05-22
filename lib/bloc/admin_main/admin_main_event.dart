part of 'admin_main_bloc.dart';

@immutable
abstract class AdminMainEvent {}

class InitialAdminMainEvent extends AdminMainEvent {

}

class OverviewPageEvent extends AdminMainEvent {

}

class ActivityAdminMainEvent extends AdminMainEvent {

}

class AccountPageEvent extends AdminMainEvent {

}

class TemporaryCodePageEvent extends AdminMainEvent {

  final int id;

  TemporaryCodePageEvent(this.id);

}

class DatabaseAdminMainEvent extends AdminMainEvent {

}

class LoadingAdminMainEvent extends AdminMainEvent {

}
