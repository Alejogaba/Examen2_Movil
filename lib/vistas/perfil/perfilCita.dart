import 'package:libro_de_cobros/entidades/cita.dart';

import '../../main.dart';
import 'package:libro_de_cobros/entidades/personal.dart';
import 'package:flutter/material.dart';

class PerfilCita extends StatelessWidget {
  final index;
  final List<Cita> perfil;
  PerfilCita({Key key, this.perfil, this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil Mensajero'),
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
                              perfil[index].nombrePaciente,
                              style: TextStyle(fontSize: 20),
                            ),
                            Text('Estado de la cita: '+perfil[index].estado),
                            SizedBox(
                              height: 20,
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
                                      Text('Nombre y apellido: '),
                                      Text(perfil[index].nombrePaciente),
                                    ],
                                  ),
                                Column(
                                    children: [
                                      Text('Identificación: '),
                                      Text(perfil[index].idPaciente),
                                    ],
                                  ),
                              ],
                            ),
                            Text('Datos de la cita'),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                               Column(
                                    children: [
                                      Text('Fecha: '),
                                      Text(perfil[index].fechaHora),
                                    ],
                                  ),
                                Column(
                                    children: [
                                      Text('Hora: '),
                                      Text(perfil[index].hora),
                                    ],
                                  ),
                              ],
                            ),
                            Column(
                                    children: [
                                      Text('Esta cita la atendera: '),
                                      Text(perfil[index].nombrePersonalMedico),
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
