class AddCardWelderNotValidParams {
  String jointId;
  String welderId;
  String weldingId;
  String name;
  String card;
  String category;
  String consecutiveWeldingFN = ''; // FolioSoldadura
  int consecutiveWelding = 0; // Consecutivo

  AddCardWelderNotValidParams({
    this.jointId,
    this.welderId,
    this.weldingId,
    this.name,
    this.card,
    this.category,
    this.consecutiveWeldingFN,
    this.consecutiveWelding,
  });
}
