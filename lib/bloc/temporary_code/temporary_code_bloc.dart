import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:frailtyprojectweb/model/TemporaryCode.dart';
import 'package:frailtyprojectweb/tools/DateTools.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meta/meta.dart';

import 'package:http/http.dart' as http;

part 'temporary_code_event.dart';

part 'temporary_code_state.dart';

class TemporaryCodeBloc extends Bloc<TemporaryCodeEvent, TemporaryCodeState> {
  @override
  TemporaryCodeState get initialState => InitialTemporaryCodeState();

  @override
  Stream<TemporaryCodeState> mapEventToState(TemporaryCodeEvent event) async* {
    if (event is InitialTemporaryCodeEvent) {
    } else if (event is RequestAllPinTemporaryCodeEvent) {
      yield* _mapAllPinToState(event);
    } else if (event is RequestAvailablePinTemporaryCodeEvent) {
      yield* _mapAvailablePinToState(event);
    } else if (event is RequestNotAvailablePinTemporaryCodeEvent) {
      yield* _mapNotAvailablePinToState(event);
    } else if (event is RequestNewTemporaryCodeEvent) {
      yield* _mapNewCodeToState(event);
    }
  }

  Stream<TemporaryCodeState> _mapNewCodeToState(
      RequestNewTemporaryCodeEvent event) async* {
    //yield LoadingTemporaryCodeState(isDialog: true);
    Map map = {};

    String url =
        "https://melondev-frailty-project.herokuapp.com/api/temporary-code/generatePinCode";

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: json.encode(map));

    //print(response.body);

    TemporaryCode temporaryCode =
        new TemporaryCode.fromJson(jsonDecode(response.body));

    TemporaryCodeState state = event.lastState;

    state.temporaryCode = temporaryCode;

    yield state;
  }

  Stream<TemporaryCodeState> _mapAllPinToState(
      RequestAllPinTemporaryCodeEvent event) async* {
    yield LoadingTemporaryCodeState();

    String url =
        "https://melondev-frailty-project.herokuapp.com/api/temporary-code/showAllPinCode";

    List<TemporaryCode> listTem = await _load(url);

    List<DataRow> list = await _loadAndPack(listTem, event.function);

    yield AllPinTemporaryCodeState(list,listTem);
  }

  Stream<TemporaryCodeState> _mapAvailablePinToState(
      RequestAvailablePinTemporaryCodeEvent event) async* {
    yield LoadingTemporaryCodeState();

    String url =
        "https://melondev-frailty-project.herokuapp.com/api/temporary-code/showAllPinAvailable";

    List<TemporaryCode> listTem = await _load(url);

    List<DataRow> list = await _loadAndPack(listTem, event.function);

    yield AvailablePinTemporaryCodeState(list,listTem);
  }

  Stream<TemporaryCodeState> _mapNotAvailablePinToState(
      RequestNotAvailablePinTemporaryCodeEvent event) async* {
    yield LoadingTemporaryCodeState();

    String url =
        "https://melondev-frailty-project.herokuapp.com/api/temporary-code/showAllPinNotAvailable";

    List<TemporaryCode> listTem = await _load(url);

    List<DataRow> list = await _loadAndPack(listTem, event.function);

    yield NotAvailablePinTemporaryCodeState(list,listTem);
  }

  Future<List<TemporaryCode>> _load(String url) async {
    List<TemporaryCode> listCode = await _loadData(url);
    return listCode;
  }

  Future<List<DataRow>> _loadAndPack(
      List<TemporaryCode> list, Function function) async {
    List<DataRow> listDataRow = await _packData(list, function);

    return listDataRow;
  }

  Future<List<TemporaryCode>> _loadData(String url) async {
    Map map = {"password": "ADMIN123456"};

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: json.encode(map));

    //print(response.body);
    List jsonResponse = json.decode(response.body);

    List<TemporaryCode> listCode =
        jsonResponse.map((code) => new TemporaryCode.fromJson(code)).toList();

    return listCode;
  }

  Future<List<DataRow>> _packData(
      List<TemporaryCode> listCode, Function function) async {
    List<DataRow> list = listCode.reversed
        .map((value) => DataRow(cells: [
              DataCell(_initialText(value.id, value, function)),
              DataCell(
                  _initialText(value.pinCode, value, function, special: true)),
              DataCell(_initialText(
                  _initialDateString(value.startDate), value, function)),
              DataCell(_initialText(
                  _initialDateString(value.expiredDate), value, function)),
              //DataCell(_initialTest(value.startDate.toString(), value.pinCode))
            ]))
        .toList();
    return list;
  }

  Widget _initialTest(String value, String pin) {
    return Container(
      child: MaterialButton(
        color: Colors.teal,
        onPressed: () {
          print(pin);
        },
        child: Text(value),
      ),
    );
  }

  Widget _initialText(
      String value, TemporaryCode temporaryCode, Function function,
      {bool special = false}) {
    return FlatButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.all(0),
      hoverColor: Colors.black12,
      focusColor: Colors.green,
      splashColor: Colors.black26,
      onPressed: () {
        function(temporaryCode.pinCode);
      },
      child: Padding(
        padding: EdgeInsets.only(left: 0, right: 0),
        child: Text(
          value,
          style: GoogleFonts.itim(
            textStyle: TextStyle(
              fontWeight: special ? FontWeight.normal : FontWeight.normal,
              fontSize: special ? 17 : 17,
              color: Colors.black.withAlpha(150),
            ),
          ),
        ),
      ),
    );
  }

  String _initialDateString(DateTime dateTime) {
    return "${dateTime.day} ${DateTools().getName(dateTime.month)} ${dateTime.year + 543}";
  }
}
