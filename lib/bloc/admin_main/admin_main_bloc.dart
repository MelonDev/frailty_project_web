import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:frailtyprojectweb/model/TemporaryCode.dart';
import 'package:frailtyprojectweb/tools/DateTools.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'admin_main_event.dart';

part 'admin_main_state.dart';

class AdminMainBloc extends Bloc<AdminMainEvent, AdminMainState> {
  @override
  AdminMainState get initialState {
    return InitialAdminMainState();
  }

  @override
  Stream<AdminMainState> mapEventToState(AdminMainEvent event) async* {
    if (event is OverviewPageEvent) {
      yield* _mapOverviewPageToState(event);
    } else if (event is ActivityAdminMainEvent) {
      yield* _mapActivityAdminMainToState(event);
    } else if (event is AccountPageEvent) {
      yield* _mapAccountPageToState(event);
    } else if (event is TemporaryCodePageEvent) {
      yield* _mapTemporaryCodePageToState(event);
    } else if (event is DatabaseAdminMainEvent) {
      yield* _mapDatabaseAdminMainToState(event);
    }
  }

  Stream<AdminMainState> _mapOverviewPageToState(
      OverviewPageEvent event) async* {
    yield OverviewPageState();
  }

  Stream<AdminMainState> _mapActivityAdminMainToState(
      ActivityAdminMainEvent event) async* {
    yield ActivityAdminMainState();
  }

  Stream<AdminMainState> _mapAccountPageToState(
      AccountPageEvent event) async* {
    yield AccountPageState();
  }

  Stream<AdminMainState> _mapTemporaryCodePageToState(
      TemporaryCodePageEvent event) async* {
    yield TemporaryCodePageState();
  }

  Stream<AdminMainState> _mapDatabaseAdminMainToState(
      DatabaseAdminMainEvent event) async* {
    yield DatabaseAdminMainState();
  }
}
