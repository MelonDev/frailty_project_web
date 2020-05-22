import 'package:frailtyprojectweb/model/Question.dart';

class Questionnaire {
  final String id;
  final String name;
  final String description;
  final Question question;

  Questionnaire({this.id, this.name, this.description,this.question});

  factory Questionnaire.fromJson(Map<String, dynamic> json) {
    return new Questionnaire(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  factory Questionnaire.fromJsonWithQuestion(Map<String, dynamic> json) {
    return new Questionnaire(
      id: json['questionnaire']['id'],
      name: json['questionnaire']['name'],
      description: json['questionnaire']['description'],
      question: Question.fromJson(json['question'])
    );
  }

  factory Questionnaire.fromMap(Map map) {
    return new Questionnaire(
        id: map['id'] as String,
        name: map['name'] as String,
        description: map['description'] as String);
  }

  Map<String, dynamic> toMap() => {"id": id, "name": name, "description": description};

}
