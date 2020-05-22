part of 'overview_bloc.dart';

@immutable
abstract class OverviewEvent {}

class InitialOverviewEvent extends OverviewEvent {}

class RunOverviewEvent extends OverviewEvent {

  final String province;

  RunOverviewEvent(this.province);


}

class ExportOverviewEvent extends OverviewEvent {
  final String name;
  final List<String> headerList;
  final List<Answer> list;
  ExportOverviewEvent(this.name, this.headerList, this.list);
}

