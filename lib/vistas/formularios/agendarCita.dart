import 'dart:io';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:libro_de_cobros/entidades/paciente.dart';
import 'package:libro_de_cobros/entidades/personal.dart';
import 'package:libro_de_cobros/servicios/database.dart';
import 'package:libro_de_cobros/vistas/formularios/buscarPaciente.dart';
import 'package:libro_de_cobros/vistas/formularios/buscarPersonal.dart';
import 'package:libro_de_cobros/vistas/generalWidgets/customTextFormField.dart';
import 'package:libro_de_cobros/vistas/generalWidgets/loading.dart';

class AgendarCita extends StatefulWidget {
  @override
  _AgendarCitaState createState() => _AgendarCitaState();
}

class _AgendarCitaState extends State<AgendarCita> {
  TextEditingController controlPersonal = TextEditingController();
  TextEditingController controlPaciente = TextEditingController();
  TextEditingController controlApellido = TextEditingController();
  TextEditingController controlIdentificacion = TextEditingController();
  TextEditingController controlTrabajando = TextEditingController();
  TextEditingController controlDireccion = TextEditingController();
  TextEditingController controlBarrio = TextEditingController();
  TextEditingController controlEstado = TextEditingController();
  TextEditingController controlTiempo = TextEditingController();
  TextEditingController controladorimagenUrl = new TextEditingController();
  List<String> listaTipo = ["Medico", "Enfermero", "Fisioterapeuta"];
  String tipo = '';
  String trabajando;
  String urlImagen;
  String uidPersonal;
  String idPaciente;
  String urlImagenPaciente;
  String estadosCita="No atendido";
  int horaReloj = 0;
  int minutoReloj = 0;
  File imageFile;
  Personal personal;
  TimeOfDay hora = TimeOfDay.now();
  bool loading = true;

  DateTime fechaSeleccionada;
  DateTime fechaNacimiento;

  bool estaActivo = false;
  bool estaTrabajando = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (fechaNacimiento != null) {
      fechaSeleccionada = fechaNacimiento;
    } else {
      fechaSeleccionada = DateTime.now();
    }
    if (urlImagen != null) {
      controladorimagenUrl.text = urlImagen;
    } else {
      controladorimagenUrl.text =
          "https://www.adl-logistica.org/wp-content/uploads/2019/07/imagen-perfil-sin-foto-300x300.png";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var material = MaterialApp(
      title: 'Lista de clientes',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Agendar Cita"),
        ),
        body: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(25.0),
                    child: TextFormField(
                      readOnly: true,
                      style: TextStyle(fontSize: 20),
                      validator: (val) =>
                          val.isEmpty ? 'No deje campos vacios' : null,
                      onTap: () async {
                        final Personal result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => BuscarPersonal()));
                        if (result != null) {
                          setState(() {
                            uidPersonal = result.uid;
                            controlPersonal.text =
                                result.nombre + ' ' + result.apellido;
                          });
                        }
                      },
                      controller: controlPersonal,
                      decoration: InputDecoration(
                          labelText: "Personal médico",
                          suffixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {},
                          )),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(25.0),
                    child: TextFormField(
                      readOnly: true,
                      style: TextStyle(fontSize: 20),
                      validator: (val) =>
                          val.isEmpty ? 'No deje campos vacios' : null,
                      onTap: () async {
                        final Paciente result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => BuscarPaciente()));
                        if (result != null) {
                          setState(() {
                            idPaciente = result.identificacion;
                            urlImagenPaciente = result.urlImagen;
                            controlPaciente.text =
                                result.nombre + ' ' + result.apellido;
                          });
                        }
                      },
                      controller: controlPaciente,
                      decoration: InputDecoration(
                          labelText: "Paciente",
                          suffixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {},
                          )),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: TextField(
                      readOnly: true,
                      style: TextStyle(fontSize: 20),
                      controller: null,
                      onTap: () {
                        _selectDate(context);
                      },
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(Icons.date_range),
                            onPressed: () {},
                          ),
                          filled: true,
                          hintStyle: TextStyle(fontSize: 20),
                          labelStyle: TextStyle(fontSize: 20),
                          hintText: fechaSeleccionada
                              .toLocal()
                              .toString()
                              .split(' ')[0],
                          labelText: "Fecha",
                          fillColor: Colors.white70),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(25.0),
                    child: TextFormField(
                      readOnly: true,
                      style: TextStyle(fontSize: 20),
                      validator: (val) =>
                          val.isEmpty ? 'No deje campos vacios' : null,
                      onTap: () async {
                        setState(() {
                          Navigator.of(context).push(
                            showPicker(
                              context: context,
                              value: hora,
                              onChange: onTimeChanged,
                            ),
                          );
                        });
                      },
                      controller: controlTiempo,
                      decoration: InputDecoration(
                          labelText: "Hora",
                          suffixIcon: IconButton(
                            icon: Icon(Icons.timer),
                            onPressed: () {},
                          )),
                    ),
                  ),
                  
                  Padding(
                    padding: EdgeInsets.all(25.0),
                    child: DropdownButton(
                      value: estadosCita,
                      items: [
                        DropdownMenuItem(
                          child: Text("Estado de la cita: No atendido"),
                          value: "No atendido",
                        ),
                        DropdownMenuItem(
                          child: Text("Estado de la cita: Atendido"),
                          value: "Atendido",
                        ),
                        DropdownMenuItem(
                          child: Text("Estado de la cita: En servicio"),
                          value: "En servicio",
                        ),
                        DropdownMenuItem(
                            child: Text("Estado de la cita: Asignado"), value: "Asignado"),
                        DropdownMenuItem(
                            child: Text("Estado de la cita: Anulado"), value: "Anulado")
                      ],
                      onChanged: (value) {
                        setState(() {
                          estadosCita= value;
                        });
                      }),
                      ),
                  ElevatedButton(
                    child: Text("Asignar cita"),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        loading = false;
                        await DatabaseService().insertarDatosCita(
                            uidPersonal,
                            controlPersonal.text,
                            idPaciente,
                            controlPaciente.text,
                            fechaSeleccionada.add(Duration(
                                hours: horaReloj, minutes: minutoReloj)),
                            controlTiempo.text,
                            estadosCita,
                            urlImagenPaciente);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    return loading ? material : Loading();
  }

  void popupButtonSelected(String value) {
    print(value);
  }

  // ignore: missing_return
  String estadoTrabajando(bool trabaja) {
    // ignore: unnecessary_statements
    trabaja ? "En servicio" : "Libre";
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: fechaSeleccionada,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)));
    if (picked != null && picked != fechaSeleccionada)
      setState(() {
        fechaSeleccionada = picked;
      });
  }

  calcularEdad(DateTime fechaNacimiento) {
    DateTime fechaActual = DateTime.now();
    int age = fechaActual.year - fechaNacimiento.year;
    int month1 = fechaActual.month;
    int month2 = fechaNacimiento.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = fechaActual.day;
      int day2 = fechaNacimiento.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  void onTimeChanged(TimeOfDay p1) {
    print(p1.periodOffset);
    print(p1.period);
    print(p1.hourOfPeriod);
    horaReloj = p1.hour;
    minutoReloj = p1.minute;
    controlTiempo.text = p1.hourOfPeriod.toString() +
        ':' +
        (p1.minute == 0 ? '00' : p1.minute.toString()) +
        ' ' +
        (p1.period.toString() == "DayPeriod.am" ? 'AM' : 'PM');
    print('hora: ' + hora.toString());
  }
}
