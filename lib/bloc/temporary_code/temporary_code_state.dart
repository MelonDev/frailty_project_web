part of 'temporary_code_bloc.dart';

@immutable
abstract class TemporaryCodeState {
  TemporaryCode temporaryCode;

  TemporaryCodeState({this.temporaryCode});

}

class InitialTemporaryCodeState extends TemporaryCodeState {}

class AllPinTemporaryCodeState extends TemporaryCodeState {
  final List<DataRow> data;
  final List<TemporaryCode> listTemporaryCode;


  AllPinTemporaryCodeState(this.data,this.listTemporaryCode);

  @override
  String toString() => 'AllPinTemporaryCodeState';
}


class AvailablePinTemporaryCodeState extends TemporaryCodeState {
  final List<DataRow> data;
  final List<TemporaryCode> listTemporaryCode;


  AvailablePinTemporaryCodeState(this.data,this.listTemporaryCode);

  @override
  String toString() => 'AvailablePinTemporaryCodeState';
}


class NotAvailablePinTemporaryCodeState extends TemporaryCodeState {
  final List<DataRow> data;
  final List<TemporaryCode> listTemporaryCode;



  NotAvailablePinTemporaryCodeState(this.data,this.listTemporaryCode);

  @override
  String toString() => 'NotAvailablePinTemporaryCodeState';
}

class LoadingTemporaryCodeState extends TemporaryCodeState {
  
  final bool isDialog;
  
  LoadingTemporaryCodeState({this.isDialog = false});

  @override
  String toString() => 'LoadingTemporaryCodeState';
}
