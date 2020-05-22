import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frailtyprojectweb/ThemeData/BasicLightThemeData.dart';
import 'package:frailtyprojectweb/bloc/admin_main/admin_main_bloc.dart';
import 'package:frailtyprojectweb/bloc/overview/overview_bloc.dart';
import 'package:frailtyprojectweb/design/login.dart';
import 'package:frailtyprojectweb/design/page/account_page.dart';
import 'package:frailtyprojectweb/design/page/overview_page.dart';
import 'package:frailtyprojectweb/design/page/question_page.dart';
import 'package:frailtyprojectweb/design/page/temporary_code_page.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key});

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  AdminMainBloc _adminMainBloc;

  int _currentPosition = 1;

  String _currentState;

  ThemeData _theme = BasicLightThemeData().getTheme();

  @override
  Widget build(BuildContext context) {
    _adminMainBloc = BlocProvider.of<AdminMainBloc>(context);

    return BlocBuilder<AdminMainBloc, AdminMainState>(
        builder: (context, _state) {
      return Scaffold(
        /*appBar: AppBar(
          iconTheme: new IconThemeData(color: Colors.black.withAlpha(170)),
          backgroundColor: Colors.white,
          titleSpacing: 0.0,
          elevation: 0,
          //title: topbar(),
        ),

         */
        drawer: MediaQuery.of(context).size.width < 600 ? _leftSide() : null,
        backgroundColor: Color(0xFFE0E0E0),
        //backgroundColor: _theme.accentColor,

        body: MediaQuery.of(context).size.width < 600
            ? _rightSide(_state)
            : _mainArea(_state),
      );
    });
  }

  Widget topbar() {
    return Center(
      child: Container(
        constraints: BoxConstraints(minHeight: 56, maxHeight: 56),
        color: Colors.transparent,
        child: Stack(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: MediaQuery.of(context).size.width < 600
                      ? EdgeInsets.only(left: 0, right: 0)
                      : EdgeInsets.only(left: 20, right: 20),
                  child: Center(
                    child: Text(
                      'ระบบวิเคราะห์ผู้ป่วยภาวะเปราะบางในผู้สูงอายุ',
                      style: GoogleFonts.itim(
                          textStyle: TextStyle(
                              //fontFamily: "SukhumvitSet",
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withAlpha(170))),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Center(
                    child: MaterialButton(
                      height: 56,
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    LoginPage()));
                      },
                      child: Text(
                        'ออกจากระบบ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withAlpha(170)),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _leftSide() {
    List<AdminMainTab> _list = [
      AdminMainTab("ภาพรวม", OverviewPageEvent()),
      //AdminMainTab("รายชื่อผู้ใช้งาน", ActivityAdminMainEvent()),
      AdminMainTab("รายชื่อผู้ใช้งาน", AccountPageEvent()),
      AdminMainTab("รหัสผ่านชั่วคราว", TemporaryCodePageEvent(0)),
      AdminMainTab("แบบทดสอบ", DatabaseAdminMainEvent())
    ];

    return Container(
      constraints: BoxConstraints(maxWidth: 200),
      color: Colors.teal,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(left: 20,right: 20),
                  height: index == 0 ? 0 : 2,
                  color: Colors.white24,
                );
              },
              padding: EdgeInsets.only(top: 30),
              itemCount: _list.length + 1,
              itemBuilder: (BuildContext context, int position) {
                if (position == 0) {
                  return Container(
                    margin: EdgeInsets.only(left: 20, bottom: 16),
                    child: Text(
                      "เมนู",
                      style: GoogleFonts.itim(
                          textStyle: TextStyle(color: Colors.white, fontSize: 46)),
                    ),
                  );
                } else {
                  if (_currentPosition == position) {
                    return Container(
                      height: 56,
                      color: Colors.white,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 25, right: 25),
                      child: Text(
                        _list[position - 1].name,
                        style: GoogleFonts.itim(
                            textStyle: TextStyle(color: Colors.teal, fontSize: 18)),
                      ),
                    );
                  } else {
                    return MaterialButton(
                        elevation: 0,
                        colorBrightness: Brightness.light,
                        height: 56,
                        onPressed: () {
                          setState(() {
                            _currentPosition = position;
                            _adminMainBloc.add(_list[position - 1].event);
                          });
                        },
                        focusElevation: 0,
                        hoverElevation: 0,
                        highlightElevation: 0,
                        color: Colors.transparent,
                        splashColor: Colors.teal,
                        child: Container(
                          height: 56,
                          color: Colors.transparent,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 7, right: 5),
                          child: Text(
                            _list[position - 1].name,
                            style: GoogleFonts.itim(
                                textStyle:
                                TextStyle(color: Colors.white, fontSize: 18)),
                          ),
                        ) /*Text(
                _list[position].name,

                style: GoogleFonts.itim(textStyle: TextStyle(color: Colors.white, fontSize: 18)),
              ),
              */
                    );
                  }
                }
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: MaterialButton(
              elevation: 0,
              colorBrightness: Brightness.light,
              height: 56,
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            LoginPage()));
              },
              focusElevation: 0,
              hoverElevation: 0,
              highlightElevation: 0,
              color: Colors.black12,
              splashColor: Colors.teal,
              child: Container(
                height: 56,
                color: Colors.transparent,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 7, right: 5),
                child: Text(
                  "ออกจากระบบ",
                  style: GoogleFonts.itim(
                      textStyle:
                      TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ) /*Text(
                _list[position].name,

                style: GoogleFonts.itim(textStyle: TextStyle(color: Colors.white, fontSize: 18)),
              ),
              */
          ),
          )
        ],
      )
    );
  }

  Widget _rightSide(AdminMainState _state) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width < 600
          ? MediaQuery.of(context).size.width
          : MediaQuery.of(context).size.width - 200,
      color: Colors.transparent,
      child: _getRightSide(_state),
    );
  }

  Widget _getRightSide(AdminMainState _state) {
    print("Home Hello : ${_state.toString()}");
    if (_state is OverviewPageState) {

      BlocProvider.of<OverviewBloc>(context).add(RunOverviewEvent(""));

      return OverviewPage();
    } else if (_state is ActivityAdminMainState) {
      return Scaffold(
        floatingActionButton: Padding(
          padding: EdgeInsets.only(right: 20, bottom: 10),
          child: FloatingActionButton.extended(
            onPressed: () {
              /*
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => AddNewDataWeb(qId: 1,title :"เพิ่มกิจกรรม")));

               */
            },
            label: Text("เพิ่มกิจกรรม"),
            icon: Icon(CupertinoIcons.add),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Color(0xFFE0E0E0),
        ),
      );
    } else if (_state is AccountPageState) {
      return AccountPage();
    } else if (_state is TemporaryCodePageState) {
      return TemporaryCodePage();
    } else if (_state is DatabaseAdminMainState) {
      return QuestionPage();
    } else {
      return Container();
    }
  }

  Widget _mainArea(AdminMainState _state) {
    return Row(
      children: <Widget>[_leftSide(), _rightSide(_state)],
    );
  }

  void _showDialog(String title, String content, String confirmBtn) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(content),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(confirmBtn),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class AdminMainTab {
  String name;
  AdminMainEvent event;

  AdminMainTab(this.name, this.event);
}
