class JointTraceabilityParams {
  String traceabilityId;
  int frontId; // -Retirar luego!!

  // Filtros
  bool isFilter;
  String plainDetailId;
  String juntaNo;
  double volumen;
  String obraId;

  bool isTraceabilityOne;

  JointTraceabilityParams({
    this.isFilter = false,
    this.plainDetailId = '',
    this.traceabilityId,
    this.obraId,
    this.frontId,
    this.isTraceabilityOne,
    this.volumen,
    this.juntaNo = '',
  });
}
