part of 'province_bloc.dart';

@immutable
abstract class ProvinceEvent {}

class InitialProvinceEvent extends ProvinceEvent {}

class SearchingProvinceEvent extends ProvinceEvent {
  final String value;

  SearchingProvinceEvent(this.value);
}

class ClearProvinceEvent extends ProvinceEvent {}


class LoadQuestionnaireEvent extends ProvinceEvent {}
