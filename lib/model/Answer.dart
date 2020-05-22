import 'package:frailtyprojectweb/model/AnswerPack.dart';
import 'package:frailtyprojectweb/model/Question.dart';

class Answer {

  final String id;
  final String questionId;
  final String answerPack;
  final String value;
  final Question question;
  final AnswerPack answerPackDetail;


  Answer({this.id,this.questionId,this.answerPack,this.value,this.question,this.answerPackDetail});

  factory Answer.fromJson(Map<String, dynamic> json) {
    return new Answer(
        id: json['id'],
        questionId: json['questionId'],
        answerPack: json['answerPack'],
        value: json['value']
    );
  }

  factory Answer.fromJsonWithQuestion(Map<String, dynamic> json) {
    return new Answer(
        id: json['id'],
        questionId: json['questionId'],
        answerPack: json['answerPack'],
        value: json['value'],
        question: Question.fromJsonWithQuestionnaire(json['question'])
    );
  }

  factory Answer.fromJsonReport(Map<String, dynamic> json) {
    return new Answer(
        id: json['id'],
        questionId: json['questionId'],
        answerPack: json['answerPack'],
        value: json['value'],
        question: Question.fromJsonWithQuestionnaire(json['question']),
        answerPackDetail : AnswerPack.fromJsonAPI(json['answerPackDetail'])
    );
  }

  factory Answer.fromMap(Map map) {
    return new Answer(
        id: map['id'] as String,
        questionId: map['questionId'] as String,
        answerPack: map['answerPack'] as String,
        value: map['value'] as String
    );
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "questionId": questionId,
    "answerPack": answerPack,
    "value": value
  };

}