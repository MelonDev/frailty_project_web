import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:frailtyprojectweb/model/Answer.dart';
import 'package:frailtyprojectweb/model/ChartData.dart';
import 'package:frailtyprojectweb/model/PieForm.dart';
import 'package:frailtyprojectweb/model/ReportPackWithAnswer.dart';
import 'package:frailtyprojectweb/model/ResponseIntValue.dart';
import 'package:frailtyprojectweb/model/ResponseValue.dart';
import 'package:frailtyprojectweb/model/ResultAfterProcess.dart';
import 'package:frailtyprojectweb/tools/DateTools.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meta/meta.dart';

import 'package:http/http.dart' as http;

part 'overview_event.dart';

part 'overview_state.dart';

class OverviewBloc extends Bloc<OverviewEvent, OverviewState> {
  @override
  OverviewState get initialState => InitialOverviewState();

  @override
  Stream<OverviewState> mapEventToState(OverviewEvent event) async* {
    if (event is InitialOverviewEvent) {
    } else if (event is RunOverviewEvent) {
      yield* _mapRunToState(event);
    } else if (event is ExportOverviewEvent) {
      _export(event);
    }
  }

  Stream<OverviewState> _mapRunToState(RunOverviewEvent event) async* {
    yield LoadingOverviewState();

    if (event.province != null) {
      if (event.province.length > 0) {
        yield* _loadSpecificProvince(event);
      } else {
        yield* _loadAllProvince();
      }
    } else {
      yield* _loadAllProvince();
    }
  }

  Stream<OverviewState> _loadSpecificProvince(RunOverviewEvent event) async* {
    String urls =
        "https://melondev-frailty-project.herokuapp.com/api/overview/filterProvince";
    Map maps = {
      //"value": "ชัยนาท"
      "value": event.province
    };

    var responses = await http.post(urls,
        headers: {"Content-Type": "application/json"}, body: json.encode(maps));
    print(responses.body);

    List jsonResponseS = json.decode(responses.body);
    List<Answer> listS =
        jsonResponseS.map((code) => new Answer.fromJsonReport(code)).toList();
    print(listS.length);

    int countMale = 0;
    int countFemale = 0;

    for (Answer value in listS) {
      //print(value.question == null);

      String urlss =
          "https://melondev-frailty-project.herokuapp.com/api/overview/getGender";
      Map mapss = {"value": value.answerPack};
      var responsess = await http.post(urlss,
          headers: {"Content-Type": "application/json"},
          body: json.encode(mapss));
      print(responsess.body);

      ResponseValue responseValue =
          ResponseValue.fromJson(jsonDecode(responsess.body));

      if (responseValue.value.contains("ชาย")) {
        countMale += 1;
      } else if (responseValue.value.contains("หญิง")) {
        countFemale += 1;
      }
    }

    int fraity = 0;
    int preFraity = 0;
    int nonFraity = 0;
    int normal = 0;
    int personnel = 0;

    List<ReportPackWithAnswer> listReport = [];

    for (Answer element in listS) {
      String url =
          "https://melondev-frailty-project.herokuapp.com/api/result/calculating";

      Map map = {
        "key": element.question.questionnaireId,
        "answerPackId": element.answerPack,
        "questionnaireName": "",
        "dateTime": "2020-01-01T00:00:00Z",
      };

      var response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode(map));

      ResultAfterProcess resultAfterProcess =
          ResultAfterProcess.fromJson(jsonDecode(response.body));

      listReport.add(ReportPackWithAnswer(element, resultAfterProcess));

      if (resultAfterProcess.percent <= 12) {
        nonFraity += 1;
      } else if (resultAfterProcess.percent <= 52) {
        preFraity += 1;
      } else if (resultAfterProcess.percent <= 100) {
        fraity += 1;
      }

      if (element.answerPackDetail.taker.personnel) {
        personnel += 1;
      } else {
        normal += 1;
      }
    }

    List<PieForm> list = _compressListPieForm(countMale, countFemale, fraity,
        preFraity, nonFraity, normal, personnel);

    List<DataRow> listDataRow = await _packData(listReport);

    yield ReadyOverviewState(list, event.province, listDataRow, listReport);
  }

  Stream<OverviewState> _loadAllProvince() async* {
    String urlMale =
        "https://melondev-frailty-project.herokuapp.com/api/overview/getAllMale";
    var responseMale = await http.get(urlMale);
    /*ResponseIntValue valueMale =
            ResponseIntValue.fromJson(json.decode(responseMale.body));
         */

    print(responseMale.body);

    List jsonResponseMale = json.decode(responseMale.body);
    List<Answer> listMale = jsonResponseMale
        .map((code) => new Answer.fromJsonReport(code))
        .toList();

    int countMale = listMale.length;

    print(countMale);

    String urlFemale =
        "https://melondev-frailty-project.herokuapp.com/api/overview/getAllFemale";
    var responseFemale = await http.get(urlFemale);
    /*ResponseIntValue valueFemale =
            ResponseIntValue.fromJson(json.decode(responseFemale.body));
         */
    print(responseFemale.body);

    List jsonResponseFemale = json.decode(responseFemale.body);
    List<Answer> listFemale = jsonResponseFemale
        .map((code) => new Answer.fromJsonReport(code))
        .toList();
    int countFemale = listFemale.length;

    int fraity = 0;
    int preFraity = 0;
    int nonFraity = 0;
    int normal = 0;
    int personnel = 0;



    List<Answer> newList = new List.from(listMale)..addAll(listFemale);

    List<ReportPackWithAnswer> listReport = [];

    for (Answer element in newList) {
      String url =
          "https://melondev-frailty-project.herokuapp.com/api/result/calculating";

      Map map = {
        "key": element.question.questionnaireId,
        "answerPackId": element.answerPack,
        "questionnaireName": "",
        "dateTime": "2020-01-01T00:00:00Z",
      };

      var response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode(map));

      ResultAfterProcess resultAfterProcess =
          ResultAfterProcess.fromJson(jsonDecode(response.body));

      print("element.answerPackDetail == null ${element.answerPackDetail == null}");

      listReport.add(ReportPackWithAnswer(element, resultAfterProcess));

      if (resultAfterProcess.percent <= 12) {
        nonFraity += 1;
      } else if (resultAfterProcess.percent <= 52) {
        preFraity += 1;
      } else if (resultAfterProcess.percent <= 100) {
        fraity += 1;
      }

      if (element.answerPackDetail != null) {
        if (element.answerPackDetail.taker.personnel) {
          personnel += 1;
        } else {
          normal += 1;
        }
      }
    }

    List<PieForm> list = _compressListPieForm(countMale, countFemale, fraity,
        preFraity, nonFraity, normal, personnel);

    List<DataRow> listDataRow = await _packData(listReport);

    yield ReadyOverviewState(list, "ทั่วประเทศ", listDataRow, listReport);
  }

  List<PieForm> _compressListPieForm(int countMale, int countFemale,
      int frailty, int preFrailty, int nonFrailty, int normal, int personnel) {
    return [
      PieForm(
        "แยกตามเพศ",
        [
          ChartData(
              x: "ชาย $countMale คน",
              y: countMale.toDouble(),
              color: Colors.blueAccent,
              text: ""),
          ChartData(
              x: "หญิง $countFemale คน",
              y: countFemale.toDouble(),
              color: Colors.redAccent,
              text: ""),
        ],
      ),
      PieForm(
        "แยกตามความเสี่ยง",
        [
          ChartData(
              x: "ไม่เป็น $nonFrailty คน",
              //y: valueMale.value.toDouble(),
              y: nonFrailty.toDouble(),
              color: Colors.blueAccent,
              text: ""),
          ChartData(
              x: "เสี่ยง $preFrailty คน",
              //y: valueMale.value.toDouble(),
              y: preFrailty.toDouble(),
              color: Colors.amber,
              text: ""),
          ChartData(
              x: "เป็น $frailty คน",
              //y: valueFemale.value.toDouble(),
              y: frailty.toDouble(),
              color: Colors.redAccent,
              text: ""),
        ],
      ),
      PieForm(
        "แยกตามชนิดผู้ดำเนินงาน",
        [
          ChartData(
              x: "คนทั่วไป $normal คน",
              y: normal.toDouble(),
              color: Colors.lightGreen,
              text: ""),
          ChartData(
              x: "บุคลากร $personnel คน",
              y: personnel.toDouble(),
              color: Colors.deepPurpleAccent,
              text: ""),
        ],
      ),
    ];
  }

  void _export(ExportOverviewEvent event) async {
    print("HELLO");
  }

  Future<List<DataRow>> _packData(List<ReportPackWithAnswer> listAnswer) async {


    List<DataRow> list = listAnswer
        .map((value) => DataRow(
                onSelectChanged: (newValue) {
                  print('row pressed');
                },
                cells: [
                  DataCell(
                      _initialText(value.answer.question.questionnaire.name)),
                  //DataCell(_initialText(value.value)),
                  DataCell(_initialText(value.answer.answerPackDetail != null
                      ? _initialDateString(DateTime.parse(
                          value.answer.answerPackDetail.dateTime))
                      : "")),
                  DataCell(_initialText(
                      _convertScoreToString(value.result.percent),
                      color: _convertScoreToColor(value.result.percent))),
                  //DataCell(_initialText(_initialDateString(value.birthDate))),
                  DataCell(_initialText(value.answer.answerPackDetail != null
                      ? "${value.answer.answerPackDetail.taker.firstName} ${value.answer.answerPackDetail.taker.lastName}"
                      : "")),
                  DataCell(_initialText(value.answer.answerPackDetail != null
                      ? value.answer.answerPackDetail.taker.personnel
                          ? "บุคลากร"
                          : "คนทั่วไป"
                      : "")),

                  //DataCell(_initialText(value.department.length == 0 ? "-" : value.department)),
                  //DataCell(_initialText(value.email.length == 0 ? "-" : value.email)),
                  //DataCell(_initialText(value.oAuthId.length != 0 ? value.oAuthId : "-" )),
                ]))
        .toList();

    return list;
  }

  String _convertScoreToString(double value) {
    if (value <= 12) {
      return "ไม่เป็น";
    } else if (value <= 52) {
      return "เสี่ยง";
    } else if (value <= 100) {
      return "เป็น";
    } else {
      return "";
    }
  }

  Color _convertScoreToColor(double value) {
    if (value <= 12) {
      return Colors.blueAccent;
    } else if (value <= 52) {
      return Colors.amber;
    } else if (value <= 100) {
      return Colors.redAccent;
    } else {
      return Colors.black54;
    }
  }

  Widget _initialText(String value, {Color color}) {
    return Text(
      value,
      style: GoogleFonts.itim(
          textStyle: TextStyle(
        fontSize: 18,
        color: color != null ? color : Colors.black.withAlpha(150),
      )),
    );
  }

  String _initialDateString(DateTime dateTime) {
    if (dateTime != null) {
      return "${dateTime.day} ${DateTools().getName(dateTime.month)} ${dateTime.year + 543}";
    } else {
      return "";
    }
  }
}
