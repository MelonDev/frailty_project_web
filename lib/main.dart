import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frailtyprojectweb/bloc/account/account_bloc.dart';
import 'package:frailtyprojectweb/bloc/new_temporary_code/new_temporary_code_bloc.dart';
import 'package:frailtyprojectweb/bloc/overview/overview_bloc.dart';
import 'package:frailtyprojectweb/bloc/province/province_bloc.dart';
import 'package:frailtyprojectweb/bloc/question/question_bloc.dart';
import 'package:frailtyprojectweb/bloc/temporary_code/temporary_code_bloc.dart';
import 'package:frailtyprojectweb/design/home.dart';
import 'package:frailtyprojectweb/design/login.dart';

import 'bloc/admin_main/admin_main_bloc.dart';
import 'bloc/flow_bloc_delegate.dart';

void main() {
  //BlocSupervisor.delegate = FlowBlocDelegate();
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AdminMainBloc>(
            create: (context) => AdminMainBloc()..add(OverviewPageEvent())),
        BlocProvider<TemporaryCodeBloc>(
            create: (context) => TemporaryCodeBloc()..add(InitialTemporaryCodeEvent())),
        BlocProvider<AccountBloc>(
            create: (context) => AccountBloc()..add(InitialAccountEvent())),
        BlocProvider<OverviewBloc>(
            create: (context) => OverviewBloc()..add(InitialOverviewEvent())),
        BlocProvider<ProvinceBloc>(
            create: (context) => ProvinceBloc()..add(InitialProvinceEvent())),
        BlocProvider<NewTemporaryCodeBloc>(
            create: (context) => NewTemporaryCodeBloc()..add(InitialNewTemporaryCodeEvent())),
        BlocProvider<QuestionBloc>(
            create: (context) => QuestionBloc()..add(InitialQuestionEvent()))
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        //       home: LoginPage(),
        home: HomePage(),
      ),
    );
  }
}
