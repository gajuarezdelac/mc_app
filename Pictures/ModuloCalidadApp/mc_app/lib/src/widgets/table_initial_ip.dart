import 'package:flutter/material.dart';

class TableInitialIP extends StatelessWidget {
  const TableInitialIP({Key key}) : super(key: key);

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
            ])
          ],
          columns: const <DataColumn>[
            DataColumn(
                label: Text('Partida',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Anexo',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('PartidaPU',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Id Primavera',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Actividad Cliente',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Folio',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Reprogramación',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Plano',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Descripción de actividad	',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Especialidad',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Sistema',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Del:',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label:
                    Text('Al:', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Estatus',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('%Avance',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Acciones',
                    style: TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }
}
