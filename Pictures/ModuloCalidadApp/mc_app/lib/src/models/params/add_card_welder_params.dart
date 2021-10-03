class AddCardWelderParams {
  String jointId;
  String card;
  String consecutiveWeldingFN = '';
  int consecutiveWelding = 0;
  bool acceptInactiveWelder=false;

  AddCardWelderParams({
    this.jointId,
    this.card,
    this.consecutiveWeldingFN,
    this.consecutiveWelding,
    this.acceptInactiveWelder=false,
  });
}
