import 'dart:convert';
import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frailtyprojectweb/bloc/new_temporary_code/new_temporary_code_bloc.dart';
import 'package:frailtyprojectweb/model/Answer.dart';
import 'package:frailtyprojectweb/model/Question.dart';
import 'package:frailtyprojectweb/model/ReportOverview.dart';
import 'package:frailtyprojectweb/model/ReportOverviewQuestion.dart';
import 'package:frailtyprojectweb/model/ReportPackWithAnswer.dart';

import 'ExportCsv.dart';
import 'package:http/http.dart' as http;

class ExportOverview {
  Future<AnchorElement> newExportCsv(
      BuildContext context,String name, String province, List<ReportPackWithAnswer> list) async {


    List<Question> listQuestion = await _getQuestionList(list);

    List<ReportOverviewQuestion> dataHeader =
        await _initialDataHeader(listQuestion);

    List<String> header = await _compressHeader(dataHeader);

    List<ReportOverview> listOver = [];

    for (ReportPackWithAnswer element in list) {

      String url =
          "https://melondev-frailty-project.herokuapp.com/api/answer/showAnswerFromAnswerPackKey";

      Map map = {"key": element.result.answerPackId};

      var response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode(map));

      List jsonResponse = json.decode(response.body);

      print(response.body);

      List<Answer> listAnswer = jsonResponse.map((code) {
        print("ANSWER : $code");
        return Answer.fromJsonWithQuestionOnly(code);
      }).toList();

      Map<String,Answer> mapAnswer = await _compressMap(listAnswer);

      int i = 0;

      List<Answer> listAnswerReport = [];

      for (ReportOverviewQuestion report in dataHeader) {
        Answer a = mapAnswer[report.question.id] ?? Answer(value: "");
        listAnswerReport.add(a);
        for (Question sub in report.list) {
          Answer b = mapAnswer[sub.id] ?? Answer(value: "");
          listAnswerReport.add(b);

        }
      }

      listOver.add(ReportOverview(element, listAnswerReport));



    }



    ExportCsv exportCsv = ExportCsv();
    AnchorElement anchorElement = exportCsv.newDownloadOverviewData(context,
        "Overview-${name != null ? name : "data"}", province, header, listOver);

    return anchorElement;

  }



  Future<List<Question>> _getQuestionList(
      List<ReportPackWithAnswer> list) async {
    String url =
        "https://melondev-frailty-project.herokuapp.com/api/question/showAllQuestionFromQuestionnaireKey";
    Map map = {
      "key": list[0].answer.question.questionnaire.id,
      "subQuestion": false
    };

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: json.encode(map));

    //print(response.body);

    List jsonResponse = json.decode(response.body);

    List<Question> listQuestion = jsonResponse.map((code) {
      return Question.fromJson(code);
    }).toList();

    return listQuestion;
  }

  Future<List<ReportOverviewQuestion>> _initialDataHeader(
      List<Question> list) async {
    list.sort((a, b) => a.position.compareTo(b.position));
    List<ReportOverviewQuestion> listReport = [];

    for (Question question in list) {
      List<Question> subList = await _getSubQuestion(question.id);
      listReport.add(ReportOverviewQuestion(question, subList));
    }

    return listReport;
  }


  Future<Map<String,Answer>> _compressMap(List<Answer> list) async {
    Map<String,Answer> map = {};

    for(Answer report in list){
      map[report.question.id] = report;
    }

    return map;
  }

  Future<List<String>> _compressHeader(
      List<ReportOverviewQuestion> list) async {
    List<String> header = [
      "ไอดี",
      "ชุดแบบทดสอบ",
      "วันเดือนปีและเวลาที่ทำ",
      "จังหวัด",
      "คะแนน",
      "เปอร์เซ็น",
      "รายงานผล",
      "ผู้ดำเนินการ",
      "สังกัด",
      "สถานะ"
    ];

    int i = 0;

    for (ReportOverviewQuestion report in list) {
      i += 1;
      header.add("$i. ${report.question.message}");

      for (Question sub in report.list) {
        i += 1;
        header.add("$i. ${sub.message}");
      }
    }

    return header;
  }

  Future<List<Question>> _getSubQuestion(String key) async {
    String url =
        "https://melondev-frailty-project.herokuapp.com/api/question/showAllSubQuestionFromQuestionKey";
    Map map = {"key": key};

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: json.encode(map));

    List jsonResponse = json.decode(response.body);

    List<Question> listQuestion = jsonResponse.map((code) {
      return Question.fromJson(code);
    }).toList();

    listQuestion.sort((a, b) => a.position.compareTo(b.position));

    return listQuestion;
  }
}
