import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frailtyprojectweb/bloc/account/account_bloc.dart';
import 'package:frailtyprojectweb/model/Account.dart';
import 'package:frailtyprojectweb/tools/ExportCsv.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountPage extends StatefulWidget {
  AccountPage({Key key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  AccountBloc _accountBloc;

  int _pagePosition = 0;

  @override
  Widget build(BuildContext context) {
    _accountBloc = BlocProvider.of<AccountBloc>(context);

    _accountBloc.add(RequestAllAccountEvent());

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
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(12),topRight: Radius.circular(12))
                                  ),
                                  padding: EdgeInsets.only(left: 12,right: 12),
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
                                                  _accountBloc.add(
                                                      RequestAllAccountEvent());
                                                  break;
                                                }
                                              case 1:
                                                {
                                                  _accountBloc.add(
                                                      RequestNormalAccountEvent());
                                                  break;
                                                }
                                              case 2:
                                                {
                                                  _accountBloc.add(
                                                      RequestPersonnelAccountEvent());
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
                                                  _buildTabText("ผู้ใช้ทั่วไป"),
                                            ),
                                            Tab(
                                              child: _buildTabText("บุคลากร"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  width: 287,
                                  height: 50,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                            AccountState state = _accountBloc.state;

                                            if(state is AllAccountState){
                                              _exportCsv("All",state.listAccount);
                                            }else if(state is NormalAccountState){
                                              _exportCsv("Normal",state.listAccount);
                                            }else if(state is PersonnelAccountState){
                                              _exportCsv("Personnel",state.listAccount);
                                            }
                                          },
                                          Colors.white,
                                          Colors.black87,
                                          Colors.teal,
                                          minWidth: 100,
                                          center: true,
                                        ),
                                      ),
                                      /*SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        width: 150,
                                        height: 40,
                                        child: _buttonTemplete(
                                          "สร้างรหัสใหม่",
                                          null,
                                          null,
                                          Colors.teal,
                                          Colors.white,
                                          Colors.teal,
                                          minWidth: 100,
                                          center: true,
                                        ),
                                      )

                                       */
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
                      BlocBuilder<AccountBloc, AccountState>(
                          builder: (context, state) {
                        if (state is AllAccountState) {
                          _pagePosition = 0;
                          return _initialDataTable(state.data);
                        } else if (state is NormalAccountState) {
                          _pagePosition = 1;
                          return _initialDataTable(state.data);
                        } else if (state is PersonnelAccountState) {
                          _pagePosition = 2;
                          return _initialDataTable(state.data);
                        } else if (state is LoadingAccountState) {
                          _pagePosition = -1;
                          return Container(
                              decoration: BoxDecoration(color: Colors.white),
                              width: MediaQuery.of(this.context).size.width,
                              height: MediaQuery.of(this.context).size.height,
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

  void _exportCsv(String name,List<Account> list){
    ExportCsv exportCsv = ExportCsv();
    exportCsv.downloadAccountData("Account-${name != null ? name : "data" }",["ID","FirstName","LastName","BirthDate","Sub-district","District","Province","Department","Status","Email","LoginType","OAuthId"],list);
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

  void _refreshPage() {
    if (_pagePosition >= 0) {
      switch (_pagePosition) {
        case 0:
          {
            _accountBloc.add(RequestAllAccountEvent());
            break;
          }
        case 1:
          {
            _accountBloc.add(RequestNormalAccountEvent());
            break;
          }
        case 2:
          {
            _accountBloc.add(RequestPersonnelAccountEvent());
            break;
          }
      }
    }
  }

  Widget _initialDataTable(List<DataRow> data) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topRight: Radius.circular(12))
      ),
      width: MediaQuery.of(this.context).size.width,
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 50),
      margin: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
            showCheckboxColumn: false,
            columns: [
              //DataColumn(label: _buildText("ไอดี")),
              DataColumn(label: _buildText("ชื่อจริง")),
              DataColumn(label: _buildText("นามสกุล")),
              DataColumn(label: _buildText("วันเดือนปีเกิด")),
              DataColumn(label: _buildText("ตำบล")),
              DataColumn(label: _buildText("อำเภอ")),
              DataColumn(label: _buildText("จังหวัด")),
              DataColumn(label: _buildText("สังกัด")),
              DataColumn(label: _buildText("อีเมล")),
              DataColumn(label: _buildText("ล็อคอินทาง")),
              DataColumn(label: _buildText("OAuth ID")),
            ],
            sortColumnIndex: 3,
            sortAscending: false,
            rows: data != null ? data : []),
      ),
    );
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
}
