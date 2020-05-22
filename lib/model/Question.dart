import 'package:frailtyprojectweb/model/Questionnaire.dart';

class Question{

  final String id;
  final String message;
  final String type;
  final int position;
  final String questionnaireId;
  final String category;
  final Questionnaire questionnaire;

  Question({this.id, this.message, this.type,this.position,this.questionnaireId,this.category,this.questionnaire});

  factory Question.fromJson(Map<String, dynamic> json) {
    return new Question(
      id: json['id'],
      message: json['message'],
      type: json['type'],
      position: json['position'],
      questionnaireId: json['questionnaireId'],
      category: json['category'],

    );
  }

  factory Question.fromJsonWithQuestionnaire(Map<String, dynamic> json) {
    return new Question(
      id: json['id'],
      message: json['message'],
      type: json['type'],
      position: json['position'],
      questionnaireId: json['questionnaireId'],
      category: json['category'],
      questionnaire: Questionnaire.fromJson(json['questionnaire'])

    );
  }


  factory Question.fromMap(Map map) {
    return new Question(
        id: map['id'] as String,
        message: map['message'] as String,
        type: map['type'] as String,
        position: map['position'] as int,
        questionnaireId: map['questionnaireId'] as String,
        category: map['category'] as String)
        ;
  }

  Map<String, dynamic> toMap() => {"id": id, "message": message, "type": type,"position":position,"questionnaireId":questionnaireId,"category":category};
}