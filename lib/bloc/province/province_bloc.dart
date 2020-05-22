import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:frailtyprojectweb/model/Province.dart';
import 'package:frailtyprojectweb/model/Questionnaire.dart';
import 'package:meta/meta.dart';

import 'package:http/http.dart' as http;

import '../flow_bloc_delegate.dart';

part 'province_event.dart';

part 'province_state.dart';

class ProvinceBloc extends Bloc<ProvinceEvent, ProvinceState> {
  @override
  ProvinceState get initialState => InitialProvinceState(null);

  @override
  Stream<ProvinceState> mapEventToState(ProvinceEvent event) async* {

    print(event);
    if (event is InitialProvinceEvent) {
      yield* _mapInitialToState();
    } else if (event is SearchingProvinceEvent) {
      yield* _mapSearchingToState(event);
    } else if (event is LoadQuestionnaireEvent) {
      yield* _mapQuestionnaireToState(event);
    }else if (event is ClearProvinceEvent) {
      yield* _mapClearToState();
    }
  }

  Stream<ProvinceState> _mapInitialToState() async* {

    yield InitialProvinceState(null);
  }

  Stream<ProvinceState> _mapClearToState() async* {

    yield InitialProvinceState(null);
  }

  Stream<ProvinceState> _mapQuestionnaireToState(LoadQuestionnaireEvent event) async* {
    String url =
        "https://melondev-frailty-project.herokuapp.com/api/question/showAllQuestionnaire";
    var response = await http.get(url);

    print(response.body);
    List jsonResponse = json.decode(response.body);
    List<Questionnaire> list = jsonResponse
        .map((code) => new Questionnaire.fromJson(code))
        .toList();

    List<Questionnaire> listFinal = [];
    //listFinal.add(Province(PROVINCE_ID: 0,PROVINCE_CODE: "0",PROVINCE_NAME: "ทั่วประเทศ"));
    listFinal.add(Questionnaire(name: "ทั้งหมด"));

    listFinal.addAll(list);

    yield CurrentQuestionState(listFinal);

  }

  Stream<ProvinceState> _mapSearchingToState(SearchingProvinceEvent event) async* {

    String url =
        "https://raw.githubusercontent.com/Cerberus/Thailand-Address/master/provinces.json";
    var response = await http.get(url);

    //print(response.body);
    List jsonResponse = json.decode(response.body);
    List<Province> list = jsonResponse
        .map((code) => new Province.fromJson(code))
        .toList();

    List<Province> listFinal = [];
    listFinal.add(Province(PROVINCE_ID: 0,PROVINCE_CODE: "0",PROVINCE_NAME: "ทั่วประเทศ"));
    listFinal.addAll(list);

    if(event.value != null){
      if(event.value.length > 0){

        List<Province> province = listFinal.where((item) => item.PROVINCE_NAME.contains(event.value)).toList();
        print(province.length);

        yield CurrentProvinceState(province);
      }else {

        print(listFinal.length);

        yield CurrentProvinceState(listFinal);
      }
    }else {
      print(listFinal.length);

      yield CurrentProvinceState(listFinal);
    }

  }
}
