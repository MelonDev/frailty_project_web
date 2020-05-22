part of 'account_bloc.dart';

@immutable
abstract class AccountEvent {}

class InitialAccountEvent extends AccountEvent {}

class RequestAllAccountEvent extends AccountEvent {}

class RequestNormalAccountEvent extends AccountEvent {}

class RequestPersonnelAccountEvent extends AccountEvent {}