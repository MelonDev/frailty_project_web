part of 'account_bloc.dart';

@immutable
abstract class AccountState {}

class InitialAccountState extends AccountState {}

class AllAccountState extends AccountState {
  final List<DataRow> data;
  final List<Account> listAccount;


  AllAccountState(this.data,this.listAccount);

  @override
  String toString() => 'AllAccountState';
}


class NormalAccountState extends AccountState {
  final List<DataRow> data;
  final List<Account> listAccount;

  NormalAccountState(this.data,this.listAccount);

  @override
  String toString() => 'NormalAccountState';
}


class PersonnelAccountState extends AccountState {
  final List<DataRow> data;
  final List<Account> listAccount;


  PersonnelAccountState(this.data,this.listAccount);

  @override
  String toString() => 'PersonnelAccountState';
}

class LoadingAccountState extends AccountState {

  @override
  String toString() => 'LoadingAccountState';
}
