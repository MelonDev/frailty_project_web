part of 'question_bloc.dart';

@immutable
abstract class QuestionState {}

class InitialQuestionState extends QuestionState {}

class LoadingQuestionState extends QuestionState {}

class ReadyQuestionState extends QuestionState {

  final List<Question> data;
  final List<Questionnaire> dataQues;

  final List<DataRow> dataRowList;


  final Questionnaire questionnaire;

  ReadyQuestionState(this.questionnaire,this.data,this.dataRowList,{this.dataQues});
}
