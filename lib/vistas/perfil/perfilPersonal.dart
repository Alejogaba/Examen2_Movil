import '../../main.dart';
import 'package:libro_de_cobros/entidades/personal.dart';
import 'package:flutter/material.dart';

class PerfilPersonal extends StatelessWidget {
  final index;
  final List<Personal> perfil;
  PerfilPersonal({Key key, this.perfil, this.index});

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
                              perfil[index].nombre+' '+perfil[index].apellido,
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
                                        child: Text(perfil[index].estadoActivo == false ? "NO" : "SI"),
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
                                        child: Text(perfil[index].trabajando == "Libre" ? "SI" : "NO"),
                                        backgroundColor:
                                            perfil[index].trabajando == "Libre"
                                                ? Colors.green
                                                : Colors.red,
                                      ),
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
