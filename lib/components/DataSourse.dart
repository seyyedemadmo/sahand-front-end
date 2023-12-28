import "package:Sahand/api/api_client.dart";
import 'package:Sahand/components/Dialogs.dart';
import "package:Sahand/models/Parameter.dart";
import "package:flutter/material.dart";

class ParameterData extends DataTableSource {

  final List<dynamic> _data;
  final APIClient _client;
  BuildContext _context;
  Function callback;
  ParameterData(this._data, this._client ,this._context, this.callback);

  @override
  DataRow? getRow(int index) {
    return DataRow(
      cells: [
        DataCell(Text(_data[index]["key"].toString())),
        DataCell(Text(_data[index]["value"].toString())),
        DataCell(Text(_data[index]["device"].toString())),
        DataCell(Text(_data[index]["address"].toString())),
        DataCell(Row(
          children: <Widget>[
            IconButton(
              onPressed: (){
                showDialog(context: _context, builder: (_context) => EditParameterPopUp(ParameterModel.fromJson(_data[index]),_client, callback));
              } ,
              icon: Icon(Icons.edit), 
            ),
            IconButton(
              onPressed: (){
                showDialog(context: _context, builder: (_context) => DeleteParameterDialog( _client,ParameterModel.fromJson(_data[index]), callback));
              },
              icon: const Icon(Icons.delete),
            ),
          ], 
        )),
      ]
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;

}

class DeviceData extends DataTableSource{
  final List<dynamic> _data;
  final APIClient _client;
  BuildContext _context;
  Function callback;
  DeviceData(this._data, this._client ,this._context, this.callback);

  @override
  DataRow? getRow(int index) {
    return DataRow(
      cells: [
        DataCell(Text(_data[index]["id"].toString())),
        DataCell(Text(_data[index]["chip_id"].toString())),
        DataCell(Text(_data[index]["receive_at"].toString())),
        DataCell(Text(_data[index]["data"].toString())),
        DataCell(Text(_data[index]["device"].toString())),
        DataCell(Row(
          children: <Widget>[
            IconButton(
              onPressed: (){
                showDialog(context: _context, builder: (_context) => EditParameterPopUp(ParameterModel.fromJson(_data[index]),_client, callback));
              } ,
              icon: Icon(Icons.edit), 
            ),
            IconButton(
              onPressed: (){
                showDialog(context: _context, builder: (_context) => DeleteParameterDialog( _client,ParameterModel.fromJson(_data[index]), callback));
              },
              icon: const Icon(Icons.delete),
            ),
          ], 
        )),
      ]
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;

}