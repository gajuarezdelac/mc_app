import '../acceptance_criteria_model.dart';

class FormingCSParams {
  String jointId;
  int employeeId;
  String initialDate;
  String finalDate;
  String comments;
  String reasonFN;
  String action;
  bool repair;
  List<AcceptanceCriteriaconformadoModel> acceptanceCriteriaId;

  FormingCSParams({
    this.jointId,
    this.employeeId,
    this.initialDate,
    this.finalDate,
    this.comments,
    this.reasonFN,
    this.action,
    this.repair,
    this.acceptanceCriteriaId,
  });
}
