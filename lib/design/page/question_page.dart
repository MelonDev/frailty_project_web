import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frailtyprojectweb/bloc/province/province_bloc.dart';
import 'package:frailtyprojectweb/bloc/question/question_bloc.dart';
import 'package:frailtyprojectweb/model/Question.dart';
import 'package:frailtyprojectweb/model/Questionnaire.dart';
import 'package:frailtyprojectweb/tools/ExportCsv.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionPage extends StatefulWidget {
  QuestionPage({Key key}) : super(key: key);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  QuestionBloc _questionBloc;
  ProvinceBloc _provinceBloc;

  @override
  Widget build(BuildContext context) {
    _questionBloc = BlocProvider.of<QuestionBloc>(context);
    _provinceBloc = BlocProvider.of<ProvinceBloc>(context);

    _questionBloc.add(RunQuestionEvent(null));

    return Container(
      child: Column(
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: EdgeInsets.only(left: 20, top: 20, right: 20),
                          color: Colors.transparent,
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  width: 400,
                                  child: Row(
                                    children: [
                                      BlocBuilder<QuestionBloc, QuestionState>(
                                          builder: (context, state) {
                                        if (state is ReadyQuestionState) {
                                          return Container(
                                            width: 300,
                                            height: 40,
                                            child: _buttonProvice(
                                              state.questionnaire.name,
                                              null,
                                              showQuestionDialog,
                                              Colors.white,
                                              Colors.black87,
                                              Colors.teal,
                                              minWidth: 100,
                                              center: false,
                                            ),
                                          );
                                        } else {
                                          return Container(
                                            width: 300,
                                            height: 40,
                                            child: _buttonProvice(
                                              "กำลังโหลด..",
                                              null,
                                              () {},
                                              Colors.white,
                                              Colors.black87,
                                              Colors.teal,
                                              minWidth: 100,
                                              center: false,
                                            ),
                                          );
                                        }
                                      })
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  width: 292,
                                  height: 50,
                                  child:
                                      BlocBuilder<QuestionBloc, QuestionState>(
                                          builder: (context, state) {
                                    if (state is ReadyQuestionState) {
                                      return Row(
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 40,
                                            child: _buttonTemplete(
                                              "รีเฟรช",
                                              null,
                                              _refreshPage,
                                              Colors.white,
                                              Colors.black87,
                                              Colors.teal,
                                              minWidth: 100,
                                              center: true,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Container(
                                            width: 170,
                                            height: 40,
                                            child: _buttonTemplete(
                                              "ดาวน์โหลด CSV",
                                              null,
                                              () {
                                                if(state.questionnaire.id == null){
                                                  _exportCsvPlus(
                                                      state.questionnaire.name,
                                                      state.dataQues);
                                                }else {
                                                  _exportCsv(
                                                      state.questionnaire.name,
                                                      state.questionnaire,
                                                      state.data);
                                                }
                                              },
                                              Colors.white,
                                              Colors.black87,
                                              Colors.teal,
                                              minWidth: 100,
                                              center: true,
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 40,
                                            child: _buttonTemplete(
                                              "รีเฟรช",
                                              null,
                                              null,
                                              Colors.white,
                                              Colors.black87,
                                              Colors.teal,
                                              minWidth: 100,
                                              center: true,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Container(
                                            width: 170,
                                            height: 40,
                                            child: _buttonTemplete(
                                              "ดาวน์โหลด CSV",
                                              null,
                                              null,
                                              Colors.white,
                                              Colors.black87,
                                              Colors.teal,
                                              minWidth: 100,
                                              center: true,
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  }),
                                ),
                              )
                            ],
                          )),
                      Container(
                        height: 0,
                        color: Colors.black12,
                        width: 400,
                        margin: EdgeInsets.only(left: 20, right: 20),
                      ),
                      BlocBuilder<QuestionBloc, QuestionState>(
                          builder: (context, state) {
                        if (state is InitialQuestionState) {
                          return Container(
                            width: 20,
                            height: 20,
                            color: Colors.red,
                          );
                        } else if (state is LoadingQuestionState) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    child: SpinKitThreeBounce(
                                      color: Colors.black54,
                                      size: 50.0,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        } else if (state is ReadyQuestionState) {
                          return _initialDataTable(state.dataRowList);
                        } else {
                          return SizedBox();
                        }
                      })
                    ],
                  )))
        ],
      ),
    );
  }

  void _refreshPage() {
    QuestionState state = _questionBloc.state;
    if (state is ReadyQuestionState) {
      _questionBloc.add(RunQuestionEvent(
          state.questionnaire.name.contains("ทั้งหมด")
              ? null
              : state.questionnaire));
    }
  }

  Widget _initialDataTable(List<DataRow> data) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      width: MediaQuery.of(this.context).size.width,
      padding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 50),
      margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
            columns: [
              //DataColumn(label: _buildText("ไอดี")),
              DataColumn(label: _buildText("คำถาม")),
              DataColumn(label: _buildText("ประเภทตัวเลือก")),
              DataColumn(label: _buildText("ชุดคำถาม")),
              //DataColumn(label: _buildText("Test")),
            ],
            sortColumnIndex: 0,
            sortAscending: false,
            rows: data != null ? data : []),
      ),
    );
  }

  void _exportCsv(
      String name, Questionnaire questionnaire, List<Question> list) {
    ExportCsv exportCsv = ExportCsv();
    exportCsv.downloadQuestionnaireData(
        "Questionnaire-${name != null ? name : "data"}",
        questionnaire,
        ["ID", "Message", "Type", "Questionnaire", "Description"],
        list);
  }

  void _exportCsvPlus(
      String name, List<Questionnaire> list) {
    ExportCsv exportCsv = ExportCsv();
    exportCsv.downloadQuestionnaireDataPlus(
        "Questionnaire-${name != null ? name : "data"}",
        ["ID", "Message", "Type", "Questionnaire", "Description"],
        list);
  }

  Widget _buildText(String text) {
    return Text(
      text,
      style: GoogleFonts.itim(
        textStyle: TextStyle(
          color: Colors.teal,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void showQuestionDialog() {
    _provinceBloc.add(LoadQuestionnaireEvent());

    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        //_temporaryCodeBloc
        //    .add(RequestNewTemporaryCodeEvent(_temporaryCodeBloc.state));

        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.black.withAlpha(100),
          alignment: Alignment.center,
          child: Container(
            margin: EdgeInsets.only(top: 40, bottom: 40),
            constraints: BoxConstraints(maxWidth: 400),
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(100),
                  blurRadius: 1.0,
                )
              ],
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.black.withAlpha(170),
                  ),
                ),
                elevation: 0,
                centerTitle: true,
                title: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(right: 60),
                      height: 56,
                      child: Center(
                        child: Text(
                          "เลือกแบบทดสอบ",
                          textAlign: TextAlign.left,
                          style: GoogleFonts.itim(
                            textStyle: TextStyle(
                                color: Colors.black.withAlpha(170),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              body: BlocBuilder<ProvinceBloc, ProvinceState>(
                  builder: (context, p_state) {
                if (p_state is CurrentQuestionState) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: _insertAddressPage(context, p_state),
                  );
                } else {
                  return Container();
                }
              }),
            ),
          ),
        );
      },
    );
  }

  Widget _insertAddressPage(BuildContext context, CurrentQuestionState _state) {
    ThemeData _theme = Theme.of(context);

    return Stack(
      children: [
        Container(
          color: Colors.white,
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: 0, bottom: 0),
                padding: EdgeInsets.only(bottom: 0),
                child: ListView.builder(
                    padding: EdgeInsets.only(top: 20, bottom: 50),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: _state.data != null ? (_state.data.length) : 0,
                    itemBuilder: (context, position) {
                      return FlatButton(
                        onPressed: () {
                          //_province = _state.data[position].PROVINCE_NAME;

                          _questionBloc
                              .add(RunQuestionEvent(_state.data[position]));

                          _provinceBloc.add(ClearProvinceEvent());

                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          color: Colors.transparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${_state.data[position].name}",
                                style: GoogleFonts.itim(
                                  textStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                              position != (_state.data.length - 1)
                                  ? Container(
                                      color: Colors.black12,
                                      margin: EdgeInsets.only(top: 10),
                                      width: MediaQuery.of(context).size.width,
                                      height: 1,
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buttonTemplete(String text, String image, Function function,
      Color bgColor, Color textColor, Color splashColor,
      {double minWidth = 200,
      double height = 60,
      double marginSide = 0,
      bool center = false,
      bool bold = false}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: marginSide, right: marginSide, top: 0),
      child: MaterialButton(
        minWidth: minWidth,
        height: height,
        color: bgColor,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        splashColor: splashColor,
        child: Container(
          margin: EdgeInsets.only(left: center ? 0 : 10, right: 0, top: 0),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment:
                center ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              image != null
                  ? Image.asset(
                      image,
                      fit: BoxFit.contain,
                      width: 22,
                      height: 22,
                    )
                  : Container(),
              image != null
                  ? SizedBox(
                      width: image != null ? 15 : (center ? 0 : 15),
                    )
                  : Container(),
              Text(
                text,
                textAlign: TextAlign.center,
                //center ? TextAlign.center : TextAlign.start,
                style: GoogleFonts.itim(
                  textStyle: TextStyle(
                    color: textColor,
                    fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                    fontSize: 18,
                  ),
                ),
              ),
              image != null
                  ? SizedBox(
                      width: image != null ? 15 : (center ? 0 : 15),
                    )
                  : Container(),
            ],
          ),
        ),
        onPressed: () {
          function();
        },
      ),
    );
  }

  Widget _buttonProvice(String text, String image, Function function,
      Color bgColor, Color textColor, Color splashColor,
      {double minWidth = 200,
      double height = 60,
      double marginSide = 0,
      bool center = false,
      bool bold = false}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: marginSide, right: marginSide, top: 0),
      child: MaterialButton(
        minWidth: minWidth,
        height: height,
        color: bgColor,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        splashColor: splashColor,
        child: Container(
          margin: EdgeInsets.only(left: center ? 0 : 10, right: 0, top: 0),
          alignment: Alignment.center,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: center
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    image != null
                        ? Image.asset(
                            image,
                            fit: BoxFit.contain,
                            width: 22,
                            height: 22,
                          )
                        : Container(),
                    image != null
                        ? SizedBox(
                            width: image != null ? 15 : (center ? 0 : 15),
                          )
                        : Container(),
                    Flexible(
                      child: Container(
                        padding: new EdgeInsets.only(right: 20.0),
                        child: Text(
                          text,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          //center ? TextAlign.center : TextAlign.start,
                          style: GoogleFonts.itim(
                            textStyle: TextStyle(
                              color: textColor,
                              fontWeight:
                                  bold ? FontWeight.bold : FontWeight.normal,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    image != null
                        ? SizedBox(
                            width: image != null ? 15 : (center ? 0 : 15),
                          )
                        : Container(),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: Icon(Icons.keyboard_arrow_down),
                ),
              )
            ],
          ),
        ),
        onPressed: () {
          function();
        },
      ),
    );
  }
}
