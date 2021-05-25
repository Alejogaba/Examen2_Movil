import 'package:libro_de_cobros/entidades/cita.dart';
import 'package:libro_de_cobros/servicios/database.dart';
import 'package:libro_de_cobros/vistas/formularios/adicionarModificarPersonal.dart';
import 'package:libro_de_cobros/entidades/personal.dart';
import 'package:flutter/material.dart';

class PerfilPersonal extends StatelessWidget {
  final index;
  final List<Personal> perfil;
  List<Cita> citasPendientes = [];
  PerfilPersonal({Key key, this.perfil, this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Perfil Mensajero'), actions: [
        IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AdicionarModificarPersonal(
                            nombre: perfil[index].nombre,
                            apellido: perfil[index].apellido,
                            estado: perfil[index].estadoActivo,
                            email: perfil[index].email,
                            contrasena: perfil[index].contrasena,
                            urlImagen: perfil[index].urlImagen,
                            trabajando: perfil[index].trabajando,
                            tipo: perfil[index].tipo,
                            uid: perfil[index].uid,
                          )));
            }),
        IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              citasPendientes = await DatabaseService()
                  .citasPendientesPersonal(perfil[index].uid);
              confirmarEliminar(context, perfil[index].uid, citasPendientes);
            })
      ]),
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
                              perfil[index].nombre +
                                  ' ' +
                                  perfil[index].apellido,
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(perfil[index].tipo),
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
                                      child: Text(
                                          perfil[index].estadoActivo == false
                                              ? "NO"
                                              : "SI"),
                                      backgroundColor:
                                          perfil[index].estadoActivo == false
                                              ? Colors.red
                                              : Colors.green,
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text('Libre'),
                                    CircleAvatar(
                                      child: Text(
                                          perfil[index].trabajando == "Libre"
                                              ? "SI"
                                              : "NO"),
                                      backgroundColor:
                                          perfil[index].trabajando == "Libre"
                                              ? Colors.green
                                              : Colors.red,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text('Credenciales'),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text('Correo electronico: '),
                                    Text(perfil[index].email),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text('Contraseña: '),
                                    Text(perfil[index].contrasena),
                                  ],
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
              DatabaseService(uid: ideliminar)
                  .eliminarPersonal(citasPendientes);
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
