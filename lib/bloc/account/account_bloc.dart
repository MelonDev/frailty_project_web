import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:frailtyprojectweb/model/Account.dart';
import 'package:frailtyprojectweb/tools/DateTools.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meta/meta.dart';

import 'package:http/http.dart' as http;


part 'account_event.dart';

part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  @override
  AccountState get initialState => InitialAccountState();

  @override
  Stream<AccountState> mapEventToState(AccountEvent event) async* {
    if (event is InitialAccountEvent) {
    } else if (event is RequestAllAccountEvent) {
      yield* _mapAllAccountToState(event);
    } else if (event is RequestNormalAccountEvent) {
      yield* _mapNormalAccountToState(event);
    } else if (event is RequestPersonnelAccountEvent) {
      yield* _mapPersonnelAccountToState(event);
    }
  }


  Stream<AccountState> _mapAllAccountToState(
      RequestAllAccountEvent event) async* {
    yield LoadingAccountState();

    String url = "https://melondev-frailty-project.herokuapp.com/api/account/showAllAccount";

    List<Account> listAcc = await _load(url);
    List<DataRow> list = await _loadAndPack(listAcc);

    yield AllAccountState(list,listAcc);
  }

  Stream<AccountState> _mapNormalAccountToState(
      RequestNormalAccountEvent event) async* {
    yield LoadingAccountState();


    String url = "https://melondev-frailty-project.herokuapp.com/api/account/showAllNormalAccount";


    List<Account> listAcc = await _load(url);
    List<DataRow> list = await _loadAndPack(listAcc);
    yield NormalAccountState(list,listAcc);
  }

  Stream<AccountState> _mapPersonnelAccountToState(
      RequestPersonnelAccountEvent event) async* {
    yield LoadingAccountState();

    String url = "https://melondev-frailty-project.herokuapp.com/api/account/showAllPersonnelAccount";

    List<Account> listAcc = await _load(url);
    List<DataRow> list = await _loadAndPack(listAcc);

    yield PersonnelAccountState(list,listAcc);
  }

  Future<List<Account>> _load(String url) async {
    List<Account> listCode = await _loadData(url);
    return listCode;
  }

  Future<List<DataRow>> _loadAndPack(List<Account> list) async{
    List<DataRow> listDataRow = await _packData(list);

    return listDataRow;
  }

  Future<List<Account>> _loadData(String url) async{
    Map map = {"password": "ADMIN123456"};

    //var response = await http.get(
    //    url, headers: {"Content-Type": "application/json"},
    //    body: json.encode(map));

    var response = await http.get(url);

    print(response);


    //print(response.body);
    List jsonResponse = json.decode(response.body);

    List<Account> listCode =
    jsonResponse.map((code) => new Account.fromJson(code)).toList();

    return listCode;

  }

  Future<List<DataRow>> _packData(List<Account> listCode) async{
    List<DataRow> list = listCode.map((value) =>
        DataRow(
            onSelectChanged: (newValue) {
              print('row pressed');
            },
            cells: [
              //DataCell(_initialText(value.id)),
              DataCell(_initialText(value.firstName)),
              DataCell(_initialText(value.lastName)),
              DataCell(_initialText(_initialDateString(value.birthDate))),
              DataCell(_initialText(value.subDistrict)),
              DataCell(_initialText(value.district)),
              DataCell(_initialText(value.province)),

              DataCell(_initialText(value.department.length == 0 ? "-" : value.department)),
              DataCell(_initialText(value.email.length == 0 ? "-" : value.email)),
              DataCell(_initialText(_initialLoginType(value.loginType))),
              DataCell(_initialText(value.oAuthId.length != 0 ? value.oAuthId : "-" )),
            ])
    ).toList();
    return list;
  }

  String _initialLoginType(String value){
    if(value.contains("NAME")){
      return "ชื่อ-นามสกุล";
    }else if(value.contains("GOOGLE")){
      return "กูเกิล";
    }else if(value.contains("APPLE")){
      return "แอปเปิ้ล";
    }else {
      return "-";
    }
  }

  Widget _initialText(String value) {
    return Text(
      value,
      style: GoogleFonts.itim(
        textStyle: TextStyle(
          fontSize: 18,
          color: Colors.black.withAlpha(150),
        )
      ),
    );
  }

  String _initialDateString(DateTime dateTime) {
    return "${dateTime.day} ${DateTools().getName(dateTime.month)} ${dateTime
        .year + 543}";
  }

}
