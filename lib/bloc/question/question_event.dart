part of 'question_bloc.dart';

@immutable
abstract class QuestionEvent {}
class InitialQuestionEvent extends QuestionEvent {}

class RunQuestionEvent extends QuestionEvent {

  final Questionnaire questionnaire;

  RunQuestionEvent(this.questionnaire);
}
