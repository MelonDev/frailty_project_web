import 'package:frailtyprojectweb/model/Account.dart';

class AnswerPack {
  final String id;
  final String takerId;
  final String dateTime;
  final Account taker;

  AnswerPack({this.id, this.takerId, this.dateTime, this.taker});

  factory AnswerPack.fromJson(Map<String, dynamic> json) {
    return new AnswerPack(
        id: json['id'], takerId: json['takerId'], dateTime: json['dateTime']);
  }

  factory AnswerPack.fromJsonAPI(Map<String, dynamic> json) {
    return new AnswerPack(
      id: json['id'],
      takerId: json['takerId'],
      dateTime: json['dateTime'],
      taker: Account.fromJson(json['taker']),
    );
  }

  factory AnswerPack.fromMap(Map map) {
    return new AnswerPack(
        id: map['id'] as String,
        takerId: map['takerId'] as String,
        dateTime: map['dateTime'] as String);
  }

  Map<String, dynamic> toMap() =>
      {"id": id, "takerId": takerId, "dateTime": dateTime};
}
