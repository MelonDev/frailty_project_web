part of 'overview_bloc.dart';

@immutable
abstract class OverviewState {}

class InitialOverviewState extends OverviewState {}

class LoadingOverviewState extends OverviewState {}
class ReadyOverviewState extends OverviewState {
  final List<PieForm> list;
  final String province;

  final List<DataRow> dataRow;
  final List<ReportPackWithAnswer> listData;

  ReadyOverviewState(this.list,this.province,this.dataRow,this.listData);
}
