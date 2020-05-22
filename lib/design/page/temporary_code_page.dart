import 'package:cupertino_tabbar/cupertino_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frailtyprojectweb/bloc/admin_main/admin_main_bloc.dart';
import 'package:frailtyprojectweb/bloc/new_temporary_code/new_temporary_code_bloc.dart';
import 'package:frailtyprojectweb/bloc/temporary_code/temporary_code_bloc.dart';
import 'package:frailtyprojectweb/model/TemporaryCode.dart';
import 'package:frailtyprojectweb/tools/DateTools.dart';
import 'package:frailtyprojectweb/tools/ExportCsv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TemporaryCodePage extends StatefulWidget {
  TemporaryCodePage({Key key}) : super(key: key);

  @override
  _TemporaryCodePageState createState() => _TemporaryCodePageState();
}

class _TemporaryCodePageState extends State<TemporaryCodePage> {
  TemporaryCodeBloc _temporaryCodeBloc;
  NewTemporaryCodeBloc _newTemporaryCodeBloc;

  int _pagePosition = 0;

  TemporaryCode _temporaryCode;

  @override
  Widget build(BuildContext context) {
    _temporaryCodeBloc = BlocProvider.of<TemporaryCodeBloc>(context);
    _newTemporaryCodeBloc = BlocProvider.of<NewTemporaryCodeBloc>(context);

    _temporaryCodeBloc.add(RequestAllPinTemporaryCodeEvent(onTapTable));

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
                                  width: 424,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12))),
                                  padding: EdgeInsets.only(left: 12, right: 12),
                                  child: DefaultTabController(
                                      length: 3,
                                      child: Scaffold(
                                        appBar: AppBar(
                                          backgroundColor: Colors.white,
                                          bottom: TabBar(
                                            onTap: (position) {
                                              switch (position) {
                                                case 0:
                                                  {
                                                    _temporaryCodeBloc.add(
                                                        RequestAllPinTemporaryCodeEvent(
                                                            onTapTable));
                                                    break;
                                                  }
                                                case 1:
                                                  {
                                                    _temporaryCodeBloc.add(
                                                        RequestAvailablePinTemporaryCodeEvent(
                                                            onTapTable));
                                                    break;
                                                  }
                                                case 2:
                                                  {
                                                    _temporaryCodeBloc.add(
                                                        RequestNotAvailablePinTemporaryCodeEvent(
                                                            onTapTable));
                                                    break;
                                                  }
                                              }
                                            },
                                            indicatorWeight: 4,
                                            labelColor: Colors.black87,
                                            indicatorColor: Colors.teal,
                                            tabs: [
                                              Tab(
                                                child: _buildTabText("ทั้งหมด"),
                                              ),
                                              Tab(
                                                child:
                                                    _buildTabText("ใช้งานได้"),
                                              ),
                                              Tab(
                                                child: _buildTabText(
                                                    "หมดอายุแล้ว"),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  width: 446,
                                  height: 50,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        width: 7,
                                      ),
                                      Container(
                                        width: 170,
                                        height: 40,
                                        child: _buttonTemplete(
                                          "ดาวน์โหลด CSV",
                                          null,
                                          (){
                                            TemporaryCodeState state = _temporaryCodeBloc.state;

                                            if(state is AllPinTemporaryCodeState){
                                              _exportCsv("All",state.listTemporaryCode);
                                            }else if(state is AvailablePinTemporaryCodeState){
                                              _exportCsv("Available",state.listTemporaryCode);
                                            }else if(state is NotAvailablePinTemporaryCodeState){
                                              _exportCsv("NotAvailable",state.listTemporaryCode);
                                            }
                                          },
                                          Colors.white,
                                          Colors.black87,
                                          Colors.teal,
                                          minWidth: 100,
                                          center: true,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 7,
                                      ),
                                      Container(
                                        width: 150,
                                        height: 40,
                                        child: _buttonTemplete(
                                          "สร้างรหัสใหม่",
                                          null,
                                          () {
                                            _newTemporaryCodeBloc.add(
                                                LoadNewTemporaryCodeEvent());
                                            showDetailDialog();
                                          },
                                          Colors.teal,
                                          Colors.white,
                                          Colors.teal,
                                          minWidth: 100,
                                          center: true,
                                        ),
                                      )
                                    ],
                                  ),
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
                      BlocBuilder<TemporaryCodeBloc, TemporaryCodeState>(
                          builder: (context, state) {
                        _temporaryCode = state.temporaryCode;

                        if (state is AllPinTemporaryCodeState) {
                          _pagePosition = 0;
                          return _initialDataTable(state.data);
                        } else if (state is AvailablePinTemporaryCodeState) {
                          _pagePosition = 1;
                          return _initialDataTable(state.data);
                        } else if (state is NotAvailablePinTemporaryCodeState) {
                          _pagePosition = 2;
                          return _initialDataTable(state.data);
                        } else if (state is LoadingTemporaryCodeState) {
                          _pagePosition = -1;
                          return state.isDialog
                              ? Container()
                              : Container(
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                  width: MediaQuery.of(this.context).size.width,
                                  height:
                                      MediaQuery.of(this.context).size.height,
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, top: 10, bottom: 50),
                                  margin: EdgeInsets.only(
                                      left: 20, right: 20, top: 0, bottom: 0),
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
                                  ));
                        } else {
                          return Container();
                        }
                      })
                    ],
                  )))
        ],
      ),
    );
  }

  void _exportCsv(String name,List<TemporaryCode> temporaryList){
    ExportCsv exportCsv = ExportCsv();
    exportCsv.downloadTemporaryData("TemporaryCode-${name != null ? name : "data" }",["ID","PinCode","StartDate","ExpiredDate"],temporaryList);
  }

  int cupertinoTabBarIValue = 0;

  int cupertinoTabBarValueGetter() => cupertinoTabBarIValue;

  void onTapTable(String pin) {
    _newTemporaryCodeBloc.add(LoadDetailTemporaryCodeEvent(pin));
    showDetailDialog();
  }

  void _refreshPage() {
    if (_pagePosition >= 0) {
      switch (_pagePosition) {
        case 0:
          {
            _temporaryCodeBloc.add(RequestAllPinTemporaryCodeEvent(onTapTable));
            break;
          }
        case 1:
          {
            _temporaryCodeBloc
                .add(RequestAvailablePinTemporaryCodeEvent(onTapTable));
            break;
          }
        case 2:
          {
            _temporaryCodeBloc
                .add(RequestNotAvailablePinTemporaryCodeEvent(onTapTable));
            break;
          }
      }
    }
  }

  void showDetailDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        /*if (_temporaryCode == null) {
          _newTemporaryCodeBloc.add(LoadNewTemporaryCodeEvent());
        } else {
          _newTemporaryCodeBloc.add(LoadDetailTemporaryCodeEvent(_temporaryCode.pinCode));
        }
        
         */

        //_temporaryCodeBloc.add(RequestNewTemporaryCodeEvent(_temporaryCodeBloc.state));

        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.black.withAlpha(100),
          alignment: Alignment.center,
          child: Container(
            margin: EdgeInsets.only(top: 40, bottom: 40),
            constraints: BoxConstraints(maxWidth: 500),
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(100),
                blurRadius: 1.0,
              )
            ], color: Colors.white),
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
                          "รายละเอียด",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black.withAlpha(170),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              body: BlocBuilder<NewTemporaryCodeBloc, NewTemporaryCodeState>(
                  builder: (context, state) {
                if (state is LoadedDetailNewTemporaryCodeState ||
                    state is LoadDetailTemporaryCodeEvent) {
                  return Container(
                    decoration: BoxDecoration(color: Colors.white),
                    width: MediaQuery.of(this.context).size.width,
                    height: MediaQuery.of(this.context).size.height,
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 50),
                    margin:
                        EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 260,
                          width: 260,
                          color: Colors.white,
                          child: QrImage(
                            data: state.code.pinCode,
                            size: 290,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          state.code.pinCode,
                          textAlign: TextAlign.start,
                          style: GoogleFonts.varelaRound(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.3,
                            textStyle: TextStyle(
                              color: Colors.teal,
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "สถานะ: ",
                              textAlign: TextAlign.start,
                              style: GoogleFonts.itim(
                                textStyle: TextStyle(
                                    color: Colors.black45, fontSize: 20),
                              ),
                            ),
                            Text(
                              "ข้อความ",
                              textAlign: TextAlign.start,
                              style: GoogleFonts.itim(
                                textStyle: TextStyle(
                                    color: Colors.amber, fontSize: 20),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "วันที่สร้าง: ${_initialDateString(state.code.startDate)}",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.itim(
                            textStyle:
                                TextStyle(color: Colors.black45, fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "วันที่หมดอายุ: ${_initialDateString(state.code.expiredDate)}",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.itim(
                            textStyle:
                                TextStyle(color: Colors.black45, fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "ไอดี: ${state.code.id}",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.itim(
                            textStyle:
                                TextStyle(color: Colors.black45, fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is LoadingNewTemporaryCodeState) {
                  return Container(
                      decoration: BoxDecoration(color: Colors.white),
                      width: MediaQuery.of(this.context).size.width,
                      height: MediaQuery.of(this.context).size.height,
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 50),
                      margin:
                          EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
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
                      ));
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

  Widget _initialDataTable(List<DataRow> data) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topRight: Radius.circular(12))),
      width: MediaQuery.of(this.context).size.width,
      height: MediaQuery.of(this.context).size.height,
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 50),
      margin: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
            columns: [
              DataColumn(label: _buildText("ไอดี")),
              DataColumn(label: _buildText("รหัส PIN")),
              DataColumn(label: _buildText("วันที่สร้าง")),
              DataColumn(label: _buildText("วันที่หมดอายุ")),
              //DataColumn(label: _buildText("Test")),
            ],
            sortColumnIndex: 3,
            sortAscending: false,
            rows: data != null ? data : []),
      ),
    );
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

  Widget _buildTabText(String text) {
    return Text(
      text,
      style: GoogleFonts.itim(
        textStyle: TextStyle(
          fontSize: 16,
          color: Colors.black.withAlpha(180),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _initialDateString(DateTime dateTime) {
    return "${dateTime.day} ${DateTools().getName(dateTime.month)} ${dateTime.year + 543}";
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
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
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
}
