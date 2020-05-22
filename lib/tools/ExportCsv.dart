// ignore: avoid_web_libraries_in_flutter
import 'dart:convert';
import 'dart:html';
import 'package:csv/csv.dart';
import 'package:frailtyprojectweb/model/Account.dart';
import 'package:frailtyprojectweb/model/Answer.dart';
import 'package:frailtyprojectweb/model/Question.dart';
import 'package:frailtyprojectweb/model/Questionnaire.dart';
import 'package:frailtyprojectweb/model/ReportPackWithAnswer.dart';
import 'package:frailtyprojectweb/model/ResultAfterProcess.dart';
import 'package:frailtyprojectweb/model/TemporaryCode.dart';

import 'DateTools.dart';
import 'package:http/http.dart' as http;


class ExportCsv {
  final List data;

  ExportCsv({this.data});

  List<List<dynamic>> rows = List<List<dynamic>>();

  downloadData() {
    for (int i = 0; i < data.length; i++) {
      List<dynamic> row = List();
      row.add(data[i].userName);
      row.add(data[i].userLastName);
      row.add(data[i].userEmail);
      rows.add(row);
    }

    String csv = const ListToCsvConverter().convert(rows);
    new AnchorElement(href: "data:text/plain;charset=utf-8,$csv")
      ..setAttribute("download", "data.csv")
      ..click();
  }

  String _initialDateString(DateTime dateTime) {
    return "${dateTime.day} ${DateTools().getName(dateTime.month)} ${dateTime.year + 543}";
  }

  downloadTemporaryData(
      String name, List<String> headerList, List<TemporaryCode> temporaryList) {
    rows.add(headerList);

    for (TemporaryCode code in temporaryList) {
      List<dynamic> row = List();
      row.add(code.id);
      row.add(code.pinCode);
      row.add(_initialDateString(code.startDate));
      row.add(_initialDateString(code.expiredDate));
      rows.add(row);
    }

    String date = _initialDateString(DateTime.now());

    String csv = const ListToCsvConverter().convert(rows);
    new AnchorElement(href: "data:text/plain;charset=utf-8,$csv")
      ..setAttribute("download", "${name == null ? "data" : name}-$date.csv")
      ..click();
  }

  downloadAccountData(
      String name, List<String> headerList, List<Account> accountList) {
    rows.add(headerList);

    for (Account code in accountList) {
      List<dynamic> row = List();
      row.add(code.id);
      row.add(code.firstName);
      row.add(code.lastName);
      row.add(_initialDateString(code.birthDate));
      row.add(code.subDistrict);
      row.add(code.district);
      row.add(code.province);
      row.add(code.department);
      row.add("${code.personnel ? "บุคลากร" : "ผู้ใช้งาน"}");
      row.add(code.email);
      row.add(code.loginType);
      row.add(code.oAuthId);

      rows.add(row);
    }

    String date = _initialDateString(DateTime.now());

    String csv = const ListToCsvConverter().convert(rows);
    new AnchorElement(href: "data:text/plain;charset=utf-8,$csv")
      ..setAttribute("download", "${name == null ? "data" : name}-$date.csv")
      ..click();
  }

  downloadQuestionnaireData(
      String name,Questionnaire questionnaire, List<String> headerList, List<Question> list) {
    rows.add(headerList);

    for (Question code in list) {
      List<dynamic> row = List();
      row.add(code.id);
      row.add(code.message);
      row.add(code.type);
      row.add(questionnaire.name);
      row.add(questionnaire.description);

      rows.add(row);
    }

    String date = _initialDateString(DateTime.now());

    String csv = const ListToCsvConverter().convert(rows);
    new AnchorElement(href: "data:text/plain;charset=utf-8,$csv")
      ..setAttribute("download", "${name == null ? "data" : name}-$date.csv")
      ..click();
  }

  downloadQuestionnaireDataPlus(
      String name, List<String> headerList, List<Questionnaire> list) {
    rows.add(headerList);

    for (Questionnaire code in list) {
      List<dynamic> row = List();
      row.add(code.question.id);
      row.add(code.question.message);
      row.add(code.question.type);
      row.add(code.name);
      row.add(code.description);

      rows.add(row);
    }

    String date = _initialDateString(DateTime.now());

    String csv = const ListToCsvConverter().convert(rows);
    new AnchorElement(href: "data:text/plain;charset=utf-8,$csv")
      ..setAttribute("download", "${name == null ? "data" : name}-$date.csv")
      ..click();
  }

  downloadOverviewData(
      String name,String province, List<String> headerList, List<ReportPackWithAnswer> list) {
    rows.add(headerList);

    for (ReportPackWithAnswer code in list) {
      List<dynamic> row = List();
      row.add(code.answer.answerPackDetail.id);
      row.add(code.answer.question.questionnaire.name);
      row.add(_initialDateString(DateTime.parse(code.answer.answerPackDetail.dateTime)));
      row.add(province);
      row.add(double.parse(code.result.score.toStringAsFixed(2)));
      row.add(code.result.percent);
      row.add(code.result.resultMessage);
      row.add("${code.answer.answerPackDetail.taker.firstName} ${code.answer.answerPackDetail.taker.lastName}");
      row.add(code.answer.answerPackDetail.taker.department);
      row.add(code.answer.answerPackDetail.taker.personnel
          ? "บุคลากร"
          : "คนทั่วไป");

      rows.add(row);
    }

    String date = _initialDateString(DateTime.now());

    String csv = const ListToCsvConverter().convert(rows);
    new AnchorElement(href: "data:text/plain;charset=utf-8,$csv")
      ..setAttribute("download", "${name == null ? "data" : name}-$date.csv")
      ..click();
  }
}
