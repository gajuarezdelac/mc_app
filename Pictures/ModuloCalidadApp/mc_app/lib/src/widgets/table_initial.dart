import 'package:flutter/material.dart';

class TableInitial extends StatelessWidget {
  const TableInitial({Key key}) : super(key: key);

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
                label: Text('SiteId',
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
                label: Text('Reprogramacion',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Plano Subactividad',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Descripción',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Especialidad',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Sistema',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Frente',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('fecha Inicio',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('fecha Fin',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Estatus',
                    style: TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }
}
