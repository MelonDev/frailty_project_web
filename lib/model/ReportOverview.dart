import 'package:frailtyprojectweb/model/Answer.dart';
import 'package:frailtyprojectweb/model/ReportPackWithAnswer.dart';

class ReportOverview {

  final ReportPackWithAnswer reportPackWithAnswer;
  final List<Answer> list;

  ReportOverview(this.reportPackWithAnswer, this.list);

}