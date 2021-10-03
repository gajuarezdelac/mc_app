import 'package:flutter/material.dart';

class TableInitialSNC extends StatelessWidget {
  const TableInitialSNC({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        child: DataTable(
          rows: const <DataRow>[
            DataRow(cells: <DataCell>[
              DataCell(Text('')), //Extracting from Map element the value
              DataCell(Text('')),
              DataCell(Text('')),
              DataCell(Text('')),
              DataCell(Text('')),
              DataCell(Text('')),
              DataCell(Text('')),
              DataCell(Text('')),
              DataCell(Text('')),
              DataCell(Text('')),
            ])
          ],
          columns: const <DataColumn>[
            DataColumn(
                label: Text('SalidaNoConformeId',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('PropuestaTecnicaId',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('ActividadId',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('SubActividadId',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Anexo',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Partida',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('PrimaveraId',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('NoActividadCliente',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Folio',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Acción',
                    style: TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }
}
