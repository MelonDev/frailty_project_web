part of 'province_bloc.dart';

@immutable
abstract class ProvinceState {}

class InitialProvinceState extends ProvinceState {
  final List<Province> data;

  InitialProvinceState(this.data);
}

class CurrentProvinceState extends ProvinceState {
  final List<Province> data;

  CurrentProvinceState(this.data);
}

class CurrentQuestionState extends ProvinceState {
  final List<Questionnaire> data;

  CurrentQuestionState(this.data);
}