import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:libro_de_cobros/entidades/cita.dart';
import 'package:libro_de_cobros/entidades/paciente.dart';
import 'package:libro_de_cobros/entidades/personal.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class User {
  final String name;
  final int age;

  const User({this.name, this.age});
}

class PdfApi {
  static Future<File> generarTablaPersonal(List<Personal> listaPersonal) async {
    final pdf = Document();

     pdf.addPage(MultiPage(
      build: (context) => [
        SizedBox(height: 0.1 * PdfPageFormat.cm),
        buildTitle("Reporte personal de la salud",24,FontWeight.bold),
        buildTitle("Fecha y hora de ultima actualización: "+ 
        DateFormat.yMd().add_jm().format(DateTime.now()),15.5,FontWeight.normal),
        buildTablePersonal(listaPersonal),
      ],
    ));

    return saveDocument(name: 'personal.pdf', pdf: pdf);
  }

  static Future<File> generarTablaPacientes(List<Paciente> listaPacientes) async {
    final pdf = Document();

     pdf.addPage(MultiPage(
      build: (context) => [
        SizedBox(height: 0.1 * PdfPageFormat.cm),
        buildTitle("Reporte pacientes",24,FontWeight.bold),
        buildTitle("Fecha y hora de ultima actualización: "+ 
        DateFormat.yMd().add_jm().format(DateTime.now()),15.5,FontWeight.normal),
        buildTablePacientes(listaPacientes),
      ],
    ));

    return saveDocument(name: 'pacientes.pdf', pdf: pdf);
  }

  static Future<File> generarTablaCita(List<Cita> listaCitas) async {
    final pdf = Document();

     pdf.addPage(MultiPage(
      build: (context) => [
        SizedBox(height: 0.1 * PdfPageFormat.cm),
        buildTitle("Reporte citas",24,FontWeight.bold),
        buildTitle("Fecha y hora de ultima actualización: "+ 
        DateFormat.yMd().add_jm().format(DateTime.now()),15.5,FontWeight.normal),
        buildTableCitas(listaCitas),
      ],
    ));

    return saveDocument(name: 'citas.pdf', pdf: pdf);
  }

  static buildText({
    String title,
    String value,
    double width = double.infinity,
    TextStyle titleStyle,
    bool unite = false,
  }) async {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }

    static Widget buildTablePersonal(List<Personal> listaPersonal) {
     final headers = ['Nombre', 'Ocupación', 'Activo'];

    
    final data = listaPersonal.map((personal) => [personal.nombre + ' ' +
    personal.apellido, personal.tipo, personal.estadoActivo ? 'SI':'NO']).toList();


    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
      },
    );
  }

  
    static Widget buildTablePacientes(List<Paciente> listaPaciente) {
     final headers = ['Nombre', 'Edad', 'Ciudad','Activo'];

    
    final data = listaPaciente.map((paciente) => [paciente.nombre + ' ' +
    paciente.apellido, paciente.edad, paciente.ciudad, paciente.estadoActivo ? 'SI':'NO']).toList();


    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
      },
    );
  }

  
    static Widget buildTableCitas(List<Cita> listaCitas) {
     final headers = ['Fecha', 'Hora', 'Estado'];

    
    final data = listaCitas.map((cita) => [cita.fechaHora,cita.hora, cita.estado]).toList();


    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
      },
    );
  }

  static Widget buildTitle(String texto,double tamano,FontWeight fuente) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            texto,
            style: TextStyle(fontSize: tamano, fontWeight: fuente),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Future<File> saveDocument({
    String name,
    Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getExternalStorageDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFilePersonal(String nombreArchivo) async {
    final dir = await getExternalStorageDirectory();
    final url = dir.path+'/'+nombreArchivo;

    await OpenFile.open(url);
  }

   
}
