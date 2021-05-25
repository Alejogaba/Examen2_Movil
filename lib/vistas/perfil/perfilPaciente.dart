import 'package:libro_de_cobros/entidades/cita.dart';
import 'package:libro_de_cobros/entidades/paciente.dart';
import 'package:libro_de_cobros/servicios/database.dart';
import 'package:libro_de_cobros/vistas/formularios/adicionarModificarPaciente.dart';
import 'package:flutter/material.dart';

class PerfilPaciente extends StatelessWidget {
  final index;
  final List<Paciente> perfil;
  List<Cita> citasPendientes = [];
  PerfilPaciente({Key key, this.perfil, this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil Paciente'),
        actions: [
          IconButton(icon: Icon(Icons.edit), onPressed: (){
            Navigator.push(context,
                      MaterialPageRoute(builder: (_) => 
                      AdicionarModificarPaciente(
                        nombre: perfil[index].nombre,
                        apellido: perfil[index].apellido,
                        estado: perfil[index].estadoActivo,
                        telefono: perfil[index].telefono,
                        fechaNacimiento: DateTime.parse(perfil[index].fechaNacimiento),
                        ciudad: perfil[index].ciudad,
                        barrio: perfil[index].barrio,
                        direccion: perfil[index].direccion,
                        urlImagen: perfil[index].urlImagen,
                        idPaciente: perfil[index].identificacion,
                        modoEditar: true,)));
          }),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              citasPendientes = await DatabaseService()
                  .citasPendientesPaciente(perfil[index].identificacion);
              confirmarEliminar(context, perfil[index].identificacion, citasPendientes);
            })
        ]
      ),
      body: ListView(children: [
        Container(
          padding: EdgeInsets.fromLTRB(10, 50, 10, 0),
          height: 460,
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
                      child: Image.network(perfil[index].urlImagen),
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
                              perfil[index].nombre+' '+perfil[index].apellido,
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(perfil[index].edad.toString()+' Años'),
                            SizedBox(
                              height: 20,
                            ),
                            Text('Estado actual'),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                               Column(
                                    children: [
                                      Text('Activo'),
                                      CircleAvatar(
                                        child: Text(perfil[index].estadoActivo == false ? "NO" : "SI"),
                                        backgroundColor:
                                            perfil[index].estadoActivo == false
                                                ? Colors.red
                                                : Colors.green,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            Text('Datos del paciente'),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                 Column(
                                    children: [
                                      Text('Identificación: '),
                                      Text(perfil[index].identificacion),
                                    ],
                                  ),
                               Column(
                                    children: [
                                      Text('Fecha de nacimiento: '),
                                      Text(perfil[index].fechaNacimiento),
                                    ],
                                  ),
                              ],
                            ),
                            Column(
                                    children: [
                                      Text('Teléfono: '),
                                      Text(perfil[index].telefono),
                                    ],
                                  ),
                            Text('Datos de residencia paciente'),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                 Column(
                                    children: [
                                      Text('Ciudad: '),
                                      Text(perfil[index].ciudad),
                                    ],
                                  ),
                               Column(
                                    children: [
                                      Text('Barrio: '),
                                      Text(perfil[index].barrio),
                                    ],
                                  ),
                              ],
                            ),
                             Column(
                                    children: [
                                      Text('Dirección: '),
                                      Text(perfil[index].direccion),
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
}

void confirmarEliminar(context, ideliminar, List<Cita> citasPendientes) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(children: [
          Text('Realmente Desea Eliminar?'),
          Text('Aún tiene ' +
              citasPendientes.length.toString() +
              ' citas pendientes'),
        ]),
        actions: <Widget>[
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            ),
            child: Icon(Icons.cancel),
            onPressed: () => {
            Navigator.pop(context)},
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
            ),
            child: Icon(Icons.check_circle),
            onPressed: () {
              DatabaseService()
                  .eliminarPaciente(citasPendientes,ideliminar);
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
