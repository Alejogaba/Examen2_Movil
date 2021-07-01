import 'package:libro_de_cobros/entidades/cita.dart';
import 'package:flutter/material.dart';
import 'package:libro_de_cobros/entidades/paciente.dart';
import 'package:libro_de_cobros/entidades/personal.dart';
import 'package:libro_de_cobros/servicios/database.dart';
import 'package:libro_de_cobros/vistas/formularios/agendarCita.dart';
import 'package:libro_de_cobros/vistas/inicio/principal.dart';
import 'package:libro_de_cobros/vistas/perfil/perfilPaciente.dart';
import 'package:libro_de_cobros/vistas/perfil/perfilPersonal.dart';

class PerfilCita extends StatefulWidget {
  final index;
  final List<Cita> perfil;
  final bool modoSoloLectura;

  PerfilCita({Key key, this.perfil, this.index, this.modoSoloLectura});

  @override
  _PerfilCitaState createState() => _PerfilCitaState(this.modoSoloLectura);
}

class _PerfilCitaState extends State<PerfilCita> {
  String estadosCita;
  bool modoSoloLectura;

  _PerfilCitaState(this.modoSoloLectura);

  @override
  Widget build(BuildContext context) {
    var iconoModificar = IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          Paciente pacienteEdit = new Paciente(
              identificacion: widget.perfil[widget.index].idPaciente,
              nombre: widget.perfil[widget.index].nombrePaciente.split(' ')[0],
              apellido:
                  widget.perfil[widget.index].nombrePaciente.split(' ')[1],
              urlImagen: widget.perfil[widget.index].urlImagen);
          Personal personalEdit = new Personal(
              uid: widget.perfil[widget.index].uidPersonalMedico,
              nombre: widget.perfil[widget.index].nombrePersonalMedico
                  .split(' ')[0],
              apellido: widget.perfil[widget.index].nombrePersonalMedico
                  .split(' ')[1]);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => AgendarCita(
                        idCitaEdit: widget.perfil[widget.index].idCita,
                        pacienteEdit: pacienteEdit,
                        personalEdit: personalEdit,
                        fechaEdit: widget.perfil[widget.index].fechaHora,
                        horaEdit: widget.perfil[widget.index].hora,
                        estadoEdit: widget.perfil[widget.index].estado,
                      ))).whenComplete(() => Navigator.pop(context));
        });
    var iconoArchivar = IconButton(
        icon: Icon(Icons.archive_outlined),
        onPressed: () async {
          await cajaAdvertencia(context, widget.perfil[widget.index]);
        });
    if (estadosCita == null) estadosCita = widget.perfil[widget.index].estado;
    bool editarEstado = true;
    Text textoEtadoCita =
        Text('Estado de la cita: ' + widget.perfil[widget.index].estado);
    Padding dropdownEstadoCita = Padding(
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
            try {
              setState(() {
                estadosCita = value;
              });
              DatabaseService().insertarDatosCita(
                  widget.perfil[widget.index].uidPersonalMedico,
                  widget.perfil[widget.index].nombrePersonalMedico,
                  widget.perfil[widget.index].idPaciente,
                  widget.perfil[widget.index].nombrePaciente,
                  DateTime.parse(widget.perfil[widget.index].fechaHora),
                  widget.perfil[widget.index].hora,
                  value,
                  widget.perfil[widget.index].urlImagen,
                  idCita: widget.perfil[widget.index].idCita);
              print("Estado de la cita modificado exitosamente");
            } catch (e) {
              print("Error al modificar estado de la cita: " + e.message);
            }
          }),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos de la cita'),
        actions: [
          modoSoloLectura == false || modoSoloLectura == null
              ? iconoModificar
              : SizedBox(),
          modoSoloLectura == false || modoSoloLectura == null
              ? iconoArchivar
              : SizedBox(),
        ],
      ),
      body: ListView(children: [
        Container(
          padding: EdgeInsets.fromLTRB(10, 50, 10, 0),
          width: double.maxFinite,
          child: Card(
            elevation: 5,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -50,
                  left: (MediaQuery.of(context).size.width / 2) - 55,
                  child: Container(
                    height: 100,
                    width: 100,
                    //color: Colors.blue,
                    child: Card(
                      elevation: 2,
                      child:
                          Image.network(widget.perfil[widget.index].urlImagen),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Column(
                          children: [
                            Text(
                              widget.perfil[widget.index].nombrePaciente,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            editarEstado ? dropdownEstadoCita : textoEtadoCita,
                            SizedBox(
                              height: 5,
                            ),
                            Text('Datos del paciente',
                                style: TextStyle(fontSize: 18)),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text('Nombre y apellido: '),
                                    Text(widget
                                        .perfil[widget.index].nombrePaciente),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text('Identificación: '),
                                    Text(
                                        widget.perfil[widget.index].idPaciente),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  Paciente paciente = await DatabaseService()
                                      .getPaciente(widget
                                          .perfil[widget.index].idPaciente);
                                  List<Paciente> _listaPacientes = [];
                                  _listaPacientes.add(paciente);
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => PerfilPaciente(
                                                perfil: _listaPacientes,
                                                index: 0,
                                                modoSoloLectura: true,
                                                citasPendientes: 0,
                                              )));
                                },
                                child: Text("+ Ver más")),
                            SizedBox(
                              height: 20,
                            ),
                            Text('Datos de la cita',
                                style: TextStyle(fontSize: 18)),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text('Fecha: '),
                                    Text(DateTime.parse(widget
                                            .perfil[widget.index].fechaHora)
                                        .toString()
                                        .split(" ")[0]),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text('Hora: '),
                                    Text(widget.perfil[widget.index].hora),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Column(
                              children: [
                                Text('Esta cita la atendera: '),
                                SizedBox(
                                  height: 6,
                                ),
                                Text(widget
                                    .perfil[widget.index].nombrePersonalMedico),
                                SizedBox(
                                  height: 6,
                                ),
                                ElevatedButton(
                                    onPressed: () async {
                                      Personal personal =
                                          await DatabaseService().getPersonal(
                                              widget.perfil[widget.index]
                                                  .uidPersonalMedico);
                                      List<Personal> _listaPersonal = [];
                                      _listaPersonal.add(personal);
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => PerfilPersonal(
                                                    perfil: _listaPersonal,
                                                    index: 0,
                                                    modoSoloLectura: true,
                                                    citasPendientes: 0,
                                                  )));
                                    },
                                    child: Text("+ Ver más")),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Regresar'))
      ]),
    );
  }

  cajaAdvertencia(BuildContext context, Cita cita) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(children: [
            Image.network(
              'https://www.lineex.es/wp-content/uploads/2018/06/alert-icon-red-11-1.png',
              width: 50,
              height: 50,
              fit: BoxFit.contain,
            ),
            Text('  Advertencia ')
          ]),
          content: Text(
              "¿Desea archivar esta cita?, una vez archivada no se podra modificar"),
          actions: <Widget>[
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              child: Icon(Icons.cancel),
              onPressed: () => {Navigator.pop(context)},
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
              child: Icon(Icons.check_circle),
              onPressed: () {
                DatabaseService().archivarCita(cita);
                DatabaseService().eliminarCita(cita.idCita);
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => Principal()));
              },
            ),
          ],
        );
      },
    );
  }
}
