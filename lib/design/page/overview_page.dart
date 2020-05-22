import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frailtyprojectweb/bloc/overview/overview_bloc.dart';
import 'package:frailtyprojectweb/bloc/province/province_bloc.dart';
import 'package:frailtyprojectweb/model/ChartData.dart';
import 'package:frailtyprojectweb/model/ReportPackWithAnswer.dart';
import 'package:frailtyprojectweb/tools/ExportCsv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OverviewPage extends StatefulWidget {
  OverviewPage({Key key}) : super(key: key);

  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  OverviewBloc _overviewBloc;
  ProvinceBloc _provinceBloc;

  String _province;

  @override
  Widget build(BuildContext context) {
    _overviewBloc = BlocProvider.of<OverviewBloc>(context);
    _provinceBloc = BlocProvider.of<ProvinceBloc>(context);

    _province = "";

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
                                      BlocBuilder<OverviewBloc, OverviewState>(
                                          builder: (context, state) {
                                        if (state is ReadyOverviewState) {
                                          return Container(
                                            width: 300,
                                            height: 40,
                                            child: _buttonProvice(
                                              state.province.length == 0
                                                  ? "ทั่วประเทศ"
                                                  : state.province,
                                              null,
                                              showProvinceDialog,
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
                                              null,
                                              Colors.white,
                                              Colors.black87,
                                              Colors.teal,
                                              minWidth: 100,
                                              center: false,
                                            ),
                                          );
                                          ;
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
                                      BlocBuilder<OverviewBloc, OverviewState>(
                                          builder: (context, state) {
                                    if (state is ReadyOverviewState) {
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
                                                _exportCsv(
                                                    "Overview-${state.province.length == 0 ? "ทั่วประเทศ" : state.province}",state.province,
                                                    state.listData);
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
                      BlocBuilder<OverviewBloc, OverviewState>(
                          builder: (context, state) {
                        if (state is InitialOverviewState) {
                          return Container(
                            width: 20,
                            height: 20,
                            color: Colors.red,
                          );
                        } else if (state is LoadingOverviewState) {
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
                        } else if (state is ReadyOverviewState) {
                          return Column(
                            children: [
                              Container(
                                padding:
                                    EdgeInsets.only(left: 0, right: 0, top: 30),
                                height: 300,
                                child: ListView.builder(
                                  itemCount: state.list != null
                                      ? state.list.length
                                      : 0,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder:
                                      (BuildContext context, int position) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: position == 0 ? 20 : 0,
                                              bottom: 6),
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            state.list[position].title,
                                            textAlign: TextAlign.start,
                                            //center ? TextAlign.center : TextAlign.start,
                                            style: GoogleFonts.itim(
                                              textStyle: TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 28,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: position == 0 ? 20 : 0,
                                              right: position == 2 ? 40 : 16),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          width: 340,
                                          height: 200,
                                          child: Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12)
                                                    //borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12),topLeft: Radius.circular(12))
                                                    ),
                                                //width: 240,
                                                width: 340,
                                                height: 200,
                                                child: Center(
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        left: 20),
                                                    child: SfCircularChart(
                                                      legend: Legend(
                                                          isVisible: true,
                                                          textStyle:
                                                              ChartTextStyle(
                                                                  color: Colors
                                                                      .black87,
                                                                  fontFamily:
                                                                      "Itim",
                                                                  fontSize:
                                                                      18)),
                                                      series:
                                                          _compressChartData(
                                                              state
                                                                  .list[
                                                                      position]
                                                                  .data),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              /*Container(
                                          width: 160,
                                          height: 260,
                                          decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(12),topRight: Radius.circular(12))
                                          ),
                                        )

                                         */
                                            ],
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ),
                              _initialDataTable(state.dataRow)
                            ],
                          );
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

  void _exportCsv(String name,String province, List<ReportPackWithAnswer> list) {
    ExportCsv exportCsv = ExportCsv();
    exportCsv.downloadOverviewData(
        "Overview-${name != null ? name : "data"}",province,
        [
          "ID",
          "Questionnaire",
          "Date",
          "Province",
          "Score",
          "Percent",
          "ResultMessage",
          "Operator",
          "Department",
          "Status"
        ],
        list);
  }

  Widget _initialDataTable(List<DataRow> data) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      width: MediaQuery.of(this.context).size.width,
      padding: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 50),
      margin: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
            showCheckboxColumn: false,
            columns: [
              DataColumn(label: _buildText("ชื่อชุดแบบทดสอบ")),
              //DataColumn(label: _buildText("ที่อยู่ผู้ถูกประเมิน")),
              DataColumn(label: _buildText("วันเดือนปีที่ประเมิน")),
              DataColumn(label: _buildText("ผลการประเมิน")),
              DataColumn(label: _buildText("ชื่อผู้ดำเนินการ")),
              DataColumn(label: _buildText("สถานะผู้ดำเนินการ")),
            ],
            sortColumnIndex: 0,
            sortAscending: false,
            rows: data != null ? data : []),
      ),
    );
  }

  void showProvinceDialog() {
    _provinceBloc.add(SearchingProvinceEvent(""));

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
                          //"รายละเอียด ${_temporaryCode == null ? "NULL" : _temporaryCode.pinCode}",
                          "เลือกจังหวัด",
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
                if (p_state is CurrentProvinceState) {
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

  Widget _insertAddressPage(BuildContext context, CurrentProvinceState _state) {
    ThemeData _theme = Theme.of(context);

    return Stack(
      children: [
        Container(
          color: Colors.white,
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                color: Colors.white,
                child: _generateTextField(context, "ค้นหา", _state,
                    id: 1,
                    size: 44,
                    marginTop: 3,
                    marginBottom: 0,
                    fontSize: 19),
              ),
              Container(
                margin: EdgeInsets.only(top: 60, bottom: 0),
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

                          if (_state.data[position].PROVINCE_NAME
                              .contains("ทั่วประเทศ")) {
                            _overviewBloc.add(RunOverviewEvent(""));
                          } else {
                            _overviewBloc.add(RunOverviewEvent(
                                _state.data[position].PROVINCE_NAME));
                          }

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
                                "${_state.data[position].PROVINCE_NAME}",
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

  Widget _generateTextField(
      BuildContext context, String message, CurrentProvinceState _state,
      {int id = 0,
      double size = 50,
      double marginTop = 16,
      double marginBottom = 0,
      double fontSize = 20}) {
    TextEditingController controller;
    ThemeData _theme = Theme.of(context);

    return Align(
      alignment: Alignment.center,
      child: Container(
        height: size,
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            //color: Colors.black.withAlpha(30)
            color: Colors.black12),
        child: Align(
          alignment: Alignment.center,
          child: Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: TextField(
              controller: controller,
              keyboardAppearance: _theme.brightness,
              keyboardType: TextInputType.text,
              onTap: () {
                //_actionBtn = true;
              },
              onChanged: (value) {
                //str = value;
                _searching(context, _state, value);
              },
              onSubmitted: (str) {
                //_actionBtn = false;
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              style: GoogleFonts.itim(
                textStyle: TextStyle(
                    fontFamily: 'SukhumvitSet',
                    //color: Colors.black,
                    color: Colors.black54,
                    fontSize: fontSize += 1,
                    fontWeight: FontWeight.normal),
              ),
              cursorColor: _theme.cursorColor,
              decoration: InputDecoration.collapsed(
                  hintText: message,
                  hintStyle: GoogleFonts.itim(
                    textStyle: TextStyle(
                        //color: Colors.black.withAlpha(120),
                        color: Colors.black54,
                        fontSize: fontSize,
                        fontWeight: FontWeight.normal),
                  ),
                  border: InputBorder.none),
            ),
          ),
        ),
      ),
    );
  }

  void _searching(
      BuildContext context, CurrentProvinceState state, String message) {
    // _registerBloc
    //     .add(SearchingEvent(account, context: context, searchMessage: message));
    _provinceBloc.add(SearchingProvinceEvent(message));
  }

  void _refreshPage() {
    OverviewState state = _overviewBloc.state;
    if (state is ReadyOverviewState) {
      _overviewBloc.add(RunOverviewEvent(
          state.province.contains("ทั่วประเทศ") ? "" : state.province));
    }
  }

  Widget _buildText(String text) {
    return InkWell(
      child: Text(
        text,
        style: GoogleFonts.itim(
          textStyle: TextStyle(
            color: Colors.teal,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  List<PieSeries<ChartSampleData, String>> getDefaultPieSeries(
      bool isTileView) {
    final List<ChartSampleData> pieData = <ChartSampleData>[
      ChartSampleData(
          x: 'ชาย', y: 30, text: 'ชาย \n 30%', color: Colors.blueAccent),
      ChartSampleData(
          x: 'หญฺิง', y: 35, text: 'หญิง \n 35%', color: Colors.pinkAccent),
    ];
    return <PieSeries<ChartSampleData, String>>[
      PieSeries<ChartSampleData, String>(
          explode: false,
          explodeIndex: 0,
          explodeOffset: '10%',
          dataSource: pieData,
          animationDuration: 500,
          radius: "80",
          legendIconType: LegendIconType.circle,
          xValueMapper: (ChartSampleData data, _) => data.x,
          yValueMapper: (ChartSampleData data, _) => data.y,
          pointColorMapper: (ChartSampleData data, _) => data.color,
          dataLabelMapper: (ChartSampleData data, _) => data.text,
          startAngle: 0,
          endAngle: 0,
          dataLabelSettings: DataLabelSettings(
              isVisible: true,
              textStyle: ChartTextStyle(
                  color: Colors.white, fontFamily: "Itim", fontSize: 18))),
    ];
  }

  List<PieSeries<ChartData, String>> _compressChartData(List<ChartData> list) {
    return <PieSeries<ChartData, String>>[
      PieSeries<ChartData, String>(
          explode: false,
          explodeIndex: 0,
          explodeOffset: '10%',
          dataSource: list,
          animationDuration: 500,
          radius: "80",
          strokeColor: Colors.white,
          strokeWidth: 5,
          legendIconType: LegendIconType.circle,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          pointColorMapper: (ChartData data, _) => data.color,
          dataLabelMapper: (ChartData data, _) => data.text,
          startAngle: 0,
          endAngle: 0,
          dataLabelSettings: DataLabelSettings(
              isVisible: true,
              textStyle: ChartTextStyle(
                  color: Colors.white, fontFamily: "Itim", fontSize: 18))),
    ];
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
                    Text(
                      text,
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

class ChartSampleData {
  String x;
  double y;
  String text;
  Color color;

  ChartSampleData({this.x, this.y, this.text, this.color});
}
