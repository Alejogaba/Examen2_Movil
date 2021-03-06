import 'package:libro_de_cobros/servicios/database.dart';
import 'package:libro_de_cobros/vistas/formularios/adicionarModificarPersonal.dart';
import 'package:libro_de_cobros/entidades/personal.dart';
import 'package:flutter/material.dart';
import 'package:libro_de_cobros/vistas/inicio/principal.dart';
import 'package:libro_de_cobros/vistas/inicio/ventanaListaCitasdePersonal.dart';

// ignore: must_be_immutable
class PerfilPersonal extends StatelessWidget {
  final index;
  final bool modoSoloLectura;
  final List<Personal> perfil;
  final int citasPendientes;
  final int citasAsignadas;
  PerfilPersonal(
      {Key key,
      this.perfil,
      this.index,
      this.modoSoloLectura,
      this.citasPendientes,
      this.citasAsignadas});

  @override
  Widget build(BuildContext context) {
    print(citasPendientes);
    var iconoModificar = IconButton(
        icon: Icon(Icons.edit),
        onPressed: () async {
          await Navigator.push(
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
                      ))).whenComplete(() => Navigator.pop(context));
        });
    var iconoEliminar = IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          await confirmarEliminar(context, perfil[index].uid);
        });
    var botonListaCitas = ElevatedButton(
        onPressed: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      VentanaListaCitasdePersonal(uid: perfil[index].uid)));
        },
        child: Text("+ Ver citas asignadas"));
    return Scaffold(
      appBar: AppBar(title: Text('Perfil personal medico'), actions: [
        (modoSoloLectura == false || modoSoloLectura == null)
            ? iconoModificar
            : SizedBox(),
        (modoSoloLectura == false ||
                modoSoloLectura == null && citasAsignadas == 0)
            ? iconoEliminar
            : SizedBox()
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
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(perfil[index].tipo),
                            SizedBox(
                              height: 20,
                            ),
                            Text('Estado actual',
                                style: TextStyle(fontSize: 18)),
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
                                          citasPendientes > 0 ? "NO" : "SI"),
                                      backgroundColor: citasPendientes > 0
                                          ? Colors.red
                                          : Colors.green,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text('Credenciales',
                                style: TextStyle(fontSize: 18)),
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
                                    Text('Contrase??a: '),
                                    Text(perfil[index].contrasena),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            citasPendientes > 0
                                ? Text(
                                    'Citas pendientes: ' +
                                        citasPendientes.toString(),
                                    style: TextStyle(fontSize: 18))
                                : SizedBox(),
                            citasPendientes > 0 ? botonListaCitas : SizedBox(),
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

confirmarEliminar(context, ideliminar) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(children: [
          Text('Realmente Desea Eliminar a este personal medico?'),
        ]),
        actions: <Widget>[
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            ),
            child: Icon(Icons.cancel),
            onPressed: () => {
              Navigator.pop(context),
            },
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
            ),
            child: Icon(Icons.check_circle),
            onPressed: () {
              DatabaseService(uid: ideliminar).eliminarPersonal();
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
