import 'package:libro_de_cobros/entidades/paciente.dart';
import 'package:libro_de_cobros/servicios/database.dart';
import 'package:libro_de_cobros/vistas/formularios/adicionarModificarPaciente.dart';
import 'package:flutter/material.dart';
import 'package:libro_de_cobros/vistas/generalWidgets/call_icons_icons.dart';
import 'package:libro_de_cobros/vistas/inicio/principal.dart';
import 'package:libro_de_cobros/vistas/inicio/ventanaListaCitasdePaciente.dart';
import 'package:url_launcher/url_launcher.dart';

class PerfilPaciente extends StatelessWidget {
  final index;
  final List<Paciente> perfil;
  final bool modoSoloLectura;
  final int citasPendientes;
  PerfilPaciente(
      {Key key,
      this.perfil,
      this.index,
      this.modoSoloLectura,
      this.citasPendientes});

  @override
  Widget build(BuildContext context) {
    var iconoModificar = IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => AdicionarModificarPaciente(
                        nombre: perfil[index].nombre,
                        apellido: perfil[index].apellido,
                        estado: perfil[index].estadoActivo,
                        telefono: perfil[index].telefono,
                        fechaNacimiento:
                            DateTime.parse(perfil[index].fechaNacimiento),
                        ciudad: perfil[index].ciudad,
                        barrio: perfil[index].barrio,
                        direccion: perfil[index].direccion,
                        urlImagen: perfil[index].urlImagen,
                        idPaciente: perfil[index].identificacion,
                        modoEditar: true,
                      ))).whenComplete(() => Navigator.pop(context));
        });
    var iconoEliminar = IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          await confirmarEliminar(context, perfil[index].identificacion);
        });
    var botonListaCitas = ElevatedButton(
        onPressed: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => VentanaListaCitasdePaciente(
                      uid: perfil[index].identificacion)));
        },
        child: Text("+ Ver citas asignadas"));
    return Scaffold(
      appBar: AppBar(title: Text('Perfil Paciente'), actions: [
        (modoSoloLectura == false || modoSoloLectura == null)
            ? iconoModificar
            : SizedBox(),
        (modoSoloLectura == false ||
                modoSoloLectura == null && citasPendientes == 0)
            ? iconoEliminar
            : SizedBox()
      ]),
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
                            Text(perfil[index].edad.toString() + ' Años'),
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
                              ],
                            ),
                            SizedBox(height: 20),
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
                                    Text('Identificación: '),
                                    Text(perfil[index].identificacion),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text('Fecha de nacimiento: '),
                                    Text(perfil[index]
                                        .fechaNacimiento
                                        .split(' ')[0]),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text('Teléfono: '),
                                Text(perfil[index].telefono),
                                ElevatedButton(
                                    onPressed: () async {
                                      final url ='tel:'+perfil[index].telefono;
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    },
                                    child: Icon(Icons.call)),
                                    
                                     ElevatedButton(
                                    onPressed: () async {
                                      final url ="https://wa.me/57" + perfil[index].telefono;
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    },
                                    child: Icon(CallIcons.whatsapp_1)),
                              ],
                            ),
                            SizedBox(height: 20),
                            Text('Datos de residencia paciente',
                                style: TextStyle(fontSize: 18)),
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
                                ElevatedButton(
                                    onPressed: () async {
                                      final url =
                                          'https://www.google.com/maps/search/barrio+'+perfil[index].barrio.replaceAll(' ', '+')+',+' +
                                              perfil[index].ciudad +
                                              ',+Colombia';
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    },
                                    child: Text("+ Ver en mapa")),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            citasPendientes > 0
                                ? Text(
                                    'Citas asignadas: ' +
                                        citasPendientes.toString(),
                                    style: TextStyle(fontSize: 18))
                                : SizedBox(),
                            citasPendientes > 0 ? botonListaCitas : SizedBox(),
                          ],
                        ),
                      ),
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

formatoDireccion(String direccion) {
  String dir;
  if (direccion.contains('#')) {
    dir = direccion.split('#')[0];
    return dir.replaceAll(' ', '+');
  } else {
    return direccion.replaceAll(' ', '+');
  }
}

confirmarEliminar(context, ideliminar) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(children: [
          Text('¿Realmente Desea Eliminar a este paciente?'),
          SizedBox(height: 2),
        ]),
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
              DatabaseService().eliminarPaciente(ideliminar);
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
