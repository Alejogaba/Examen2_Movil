import 'package:libro_de_cobros/entidades/cita.dart';
import 'package:flutter/material.dart';
import 'package:libro_de_cobros/servicios/database.dart';
import 'package:libro_de_cobros/vistas/inicio/principal.dart';


class PerfilCitaArchivada extends StatefulWidget {
  final index;
  final List<Cita> perfil;

  PerfilCitaArchivada({Key key, this.perfil, this.index});

  @override
  _PerfilCitaArchivadaState createState() => _PerfilCitaArchivadaState();
}

class _PerfilCitaArchivadaState extends State<PerfilCitaArchivada> {
  String estadosCita;
  bool modoSoloLectura;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos de la cita'),
        
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
                            Text('ID Cita: '+
                              widget.perfil[widget.index].idCita,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text("Estado: " +widget.perfil[widget.index].estado),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Nombre del paciente: '+widget.perfil[widget.index].nombrePaciente,
                                style: TextStyle(fontSize: 18)),
                                SizedBox(
                              height: 10,
                            ),
                            Text('ID del paciente: '+widget.perfil[widget.index].idPaciente,
                                style: TextStyle(fontSize: 18)),
                            
                            SizedBox(
                              height: 30,
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
                              height: 30,
                            ),
                            Column(
                              children: [
                                Text('Esta cita la atendió: '+widget
                                    .perfil[widget.index].nombrePersonalMedico),
                                SizedBox(
                                  height: 6,
                                ),
                                Text('UID: '+widget
                                    .perfil[widget.index].uidPersonalMedico),
                                SizedBox(
                                  height: 6,
                                ),
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
