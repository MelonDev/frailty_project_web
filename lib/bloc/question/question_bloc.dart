import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:frailtyprojectweb/bloc/province/province_bloc.dart';
import 'package:frailtyprojectweb/model/Question.dart';
import 'package:frailtyprojectweb/model/Questionnaire.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meta/meta.dart';

import 'package:http/http.dart' as http;


part 'question_event.dart';

part 'question_state.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  @override
  QuestionState get initialState => InitialQuestionState();

  @override
  Stream<QuestionState> mapEventToState(QuestionEvent event) async* {
    if (event is InitialQuestionEvent) {
    } else if (event is RunQuestionEvent) {
      yield* _mapRunToState(event);
    }
  }

  Stream<QuestionState> _mapRunToState(RunQuestionEvent event) async* {
    yield LoadingQuestionState();

    if (event.questionnaire != null) {
      if (event.questionnaire.id != null) {
        yield* _loadQuestion(event);
      } else {
        yield* _loadAllQuestion();
      }
    } else {
      yield* _loadAllQuestion();
    }

  }

  Stream<QuestionState> _loadAllQuestion() async* {

    String url =
        "https://melondev-frailty-project.herokuapp.com/api/question/showAllAnyQuestion";
    var response = await http.get(url);

    List jsonResponse = json.decode(response.body);
    List<Question> list = jsonResponse
        .map((code) => new Question.fromJson(code['question']))
        .toList();

    List<Questionnaire> listQN = jsonResponse
        .map((code) => new Questionnaire.fromJsonWithQuestion(code))
        .toList();

    List<DataRow> listData = await _packData(listQN);

    yield ReadyQuestionState(Questionnaire(name: "ทั้งหมด"),list,listData,dataQues: listQN);
  }

  Stream<QuestionState> _loadQuestion(RunQuestionEvent event) async* {



    String url =
        "https://melondev-frailty-project.herokuapp.com/api/question/showAllQuestionFromQuestionnaireKey";

    Map map = {
      "key": event.questionnaire.id,
      "subQuestion": true
    };

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(map));

    List jsonResponse = json.decode(response.body);
    List<Question> list = jsonResponse
        .map((code) => new Question.fromJson(code))
        .toList();

    List<DataRow> listData = await _packDataQN(list, event.questionnaire);


    yield ReadyQuestionState(event.questionnaire,list,listData);
  }

  Future<List<DataRow>> _packData(List<Questionnaire> listQuestion) async {
    List<DataRow> list = listQuestion
        .map((value) => DataRow(
        cells: [
          //DataCell(_initialText(value.question.id)),
          DataCell(_initialText(value.question.message,null)),
          DataCell(_initialText(_convertType(value.question.type),null)),
          DataCell(_initialText(value.name,null)),
        ]))
        .toList();
    return list;
  }

  Future<List<DataRow>> _packDataQN(List<Question> listQuestion,Questionnaire questionnaire) async {
    List<DataRow> list = listQuestion
        .map((value) => DataRow(
        cells: [
          //DataCell(_initialText(value.id)),
          DataCell(_initialText(value.message,null)),
          DataCell(_initialText(_convertType(value.type),null)),
          DataCell(_initialText(questionnaire.name,null)),
        ]))
        .toList();
    return list;
  }
  
  String _convertType(String type){
    if(type.contains("location_multiply")){
      return "ตำแหน่งที่อยู่";
    }else if(type.contains("number_multiply")){
      return "ตัวเลือกแบบตัวเลข";
    }else if(type.contains("multiply")){
      return "ตัวเลือกแบบข้อความ";
    }else if(type.contains("number")){
      return "ตัวเลข";
    }else if(type.contains("textinput")){
      return "พิมพ์ข้อความ";
    }else if(type.contains("title")){
      return "หัวข้อ";
    }else{
      return "-";
    }
  }

  Widget _initialText(
      String value, Function function) {
    return Container(
        constraints: BoxConstraints(maxWidth: 500), child :FlatButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.all(0),
      hoverColor: Colors.black12,
      focusColor: Colors.green,
      splashColor: Colors.black26,
      onPressed: () {
      },
      child: Padding(
        padding: EdgeInsets.only(left: 0, right: 0),
        child: Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.itim(
            textStyle: TextStyle(
              fontWeight:FontWeight.normal,
              fontSize: 17 ,
              color: Colors.black.withAlpha(150),
            ),
          ),
        ),
      ),
    ),);
  }

  Widget _initialTexts(String value, {Color color}) {
    return Container(
      constraints: BoxConstraints(maxWidth: 500),
      child: Text(
        value,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.itim(
            textStyle: TextStyle(
              fontSize: 18,
              color: color != null ? color : Colors.black.withAlpha(150),
            )),
      ),
    );
  }

}
