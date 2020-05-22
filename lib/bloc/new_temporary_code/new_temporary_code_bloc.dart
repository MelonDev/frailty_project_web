import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:frailtyprojectweb/model/TemporaryCode.dart';
import 'package:meta/meta.dart';

import 'package:http/http.dart' as http;

part 'new_temporary_code_event.dart';

part 'new_temporary_code_state.dart';

class NewTemporaryCodeBloc
    extends Bloc<NewTemporaryCodeEvent, NewTemporaryCodeState> {
  @override
  NewTemporaryCodeState get initialState => InitialNewTemporaryCodeState();

  @override
  Stream<NewTemporaryCodeState> mapEventToState(
      NewTemporaryCodeEvent event) async* {
    if (event is LoadNewTemporaryCodeEvent) {
      yield* _mapLoadNewToState(event);
    } else if (event is ClearNewTemporaryCodeEvent) {
      yield* _mapClearToState(event);
    } else if (event is LoadDetailTemporaryCodeEvent) {
      yield* _mapLoadDetailToState(event);
    }
  }

  Stream<NewTemporaryCodeState> _mapLoadDetailToState(
      LoadDetailTemporaryCodeEvent event) async* {
    yield LoadingNewTemporaryCodeState();

    Map map = {"pin":event.pin};

    String url =
        "https://melondev-frailty-project.herokuapp.com/api/temporary-code/showDetailFromPin";

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: json.encode(map));

    TemporaryCode temporaryCode = new TemporaryCode.fromJson(jsonDecode(response.body));

    yield LoadedDetailNewTemporaryCodeState(temporaryCode);

  }

  Stream<NewTemporaryCodeState> _mapLoadNewToState(
      LoadNewTemporaryCodeEvent event) async* {
    yield LoadingNewTemporaryCodeState();

    Map map = {};

    String url =
        "https://melondev-frailty-project.herokuapp.com/api/temporary-code/generatePinCode";

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: json.encode(map));

    //print(response.body);

    TemporaryCode temporaryCode =
    new TemporaryCode.fromJson(jsonDecode(response.body));

    yield LoadedDetailNewTemporaryCodeState(temporaryCode);

  }

  Stream<NewTemporaryCodeState> _mapClearToState(
      ClearNewTemporaryCodeEvent event) async* {
    yield NonNewTemporaryCodeState();
  }
}
