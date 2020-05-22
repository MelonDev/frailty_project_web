import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frailtyprojectweb/design/home.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key});

  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  String bgUrl =
      "https://images.unsplash.com/photo-1566830646346-908d87490bba?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80";

  @override
  Widget build(BuildContext context) {
    String _username = "";
    String _password = "";

    Size _size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFFE0E0E0),
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.network(
              bgUrl,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black.withAlpha(100),
          ),
          Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 1000),
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: _size.width > 850 ? 20 : 30,
                          right: _size.width > 850 ? 20 : 30,
                          bottom: 60),
                      child: Column(
                        children: <Widget>[
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: 700,
                              minWidth: 460,
                            ),
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 0, right: 0, bottom: 20, top: 40),
                              child: Text(
                                'ระบบวิเคราะห์ผู้ป่วยภาวะเปราะบางในผู้สูงอายุ ',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    //fontFamily: "SukhumvitSet",
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white.withAlpha(255),
                                    fontSize: 28),
                              ),
                            ),
                          ),
                          Container(
                            constraints: BoxConstraints(
                                maxWidth: 700,
                                minWidth: 560,
                                maxHeight: 500,
                                minHeight: 300),
                            decoration: BoxDecoration(
                                color: Colors.white.withAlpha(240),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(100),
                                    blurRadius: 0.0,
                                  ),
                                ]),
                            padding: EdgeInsets.only(
                                left: _size.width > 850 ? 100 : 10,
                                right: _size.width > 850 ? 100 : 10,
                                top: 40,
                                bottom: 20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 40, right: 40, top: 30),
                                  child: TextField(
                                    onChanged: (value) {
                                      _username = value;
                                    },
                                    style: TextStyle(),
                                    decoration: InputDecoration(
                                        hintText: "ชื่อผู้ใช้",
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(Icons.person)),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 40, right: 40, top: 20),
                                  child: TextField(
                                    obscureText: true,
                                    onChanged: (value) {
                                      _password = value;
                                    },
                                    decoration: InputDecoration(
                                        hintText: "รหัสผ่าน",
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(Icons.vpn_key)),
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 40,
                                        right: 40,
                                        top: 40,
                                        bottom: 40),
                                    child: Material(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      color: Colors.green,
                                      child: MaterialButton(
                                        minWidth: 200,
                                        height: 50,
                                        onPressed: () {
                                          if (_username.length == 0 ||
                                              _password.length == 0) {
                                            _showDialog("แจ้งเตือน",
                                                "กรอกข้อมูลไม่ครบ", "ปิด");
                                          } else if (_username
                                                  .toLowerCase()
                                                  .contains("admin") &&
                                              _password
                                                  .toLowerCase()
                                                  .contains("123456")) {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        HomePage()));
                                          } else {
                                            _showDialog("แจ้งเตือน",
                                                "ข้อมูลไม่ถูกต้อง", "ปิด");
                                          }
                                        },
                                        child: Text(
                                          'ลงชื่อเข้าใช้',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget topbar() {
    return Center(
      child: Container(
        constraints:
            BoxConstraints(minHeight: 56, maxHeight: 56, maxWidth: 1100),
        color: Colors.transparent,
        child: Stack(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Center(
                    child: Text(
                      'ระบบวิเคราะห์ผู้ป่วยภาวะเปราะบางในผู้สูงอายุ ',
                      style: TextStyle(
                          fontFamily: "SukhumvitSet",
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withAlpha(170)),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[],
            )
          ],
        ),
      ),
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
