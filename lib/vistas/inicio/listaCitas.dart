import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:libro_de_cobros/entidades/cita.dart';
import 'package:libro_de_cobros/entidades/paciente.dart';
import 'package:libro_de_cobros/entidades/personal.dart';
import 'package:libro_de_cobros/vistas/generalWidgets/loading.dart';
import 'package:libro_de_cobros/vistas/perfil/perfilCita.dart';
import 'package:provider/provider.dart';

class ListaCitas extends StatefulWidget {
  
  ListaCitas({Key key}) : super(key: key);

  @override
  _ListaCitasState createState() => _ListaCitasState();
}

class _ListaCitasState extends State<ListaCitas> {
  bool loading = false;
 
  @override
  Widget build(BuildContext context) {
    var lista;
    try {
      final _listaCitas = Provider.of<List<Cita>>(context);
      lista = ListView.builder(
          itemCount: _listaCitas.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: (){
                 Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => PerfilCita(
                            perfil: _listaCitas, index: index)));
              
              },
              onLongPress: () {
                setState(() {});
              },
              title: Row(
                children: [
                  Text(_listaCitas[index].nombrePaciente),
                Spacer(),
                Text(
                  DateTime.parse(_listaCitas[index].fechaHora).toString().split(" ")[0]+' '+_listaCitas[index].hora,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                )
                ],
              ),
              subtitle: Row(children: [
                Text('Lo atendera: '+_listaCitas[index].nombrePersonalMedico),
                Spacer(),
                Text(
                  _listaCitas[index].estado,
                  textAlign: TextAlign.right,
                ),
              ]),
              leading: CircleAvatar(
                child: (_listaCitas[index].urlImagen == null || _listaCitas[index].urlImagen.trim()=='')
                    ? Text(_listaCitas[index].nombrePaciente
                        .toUpperCase()
                        .substring(0, 1))
                    : null,
                backgroundImage: (_listaCitas[index].urlImagen != null)
                    ? NetworkImage(_listaCitas[index].urlImagen)
                    : null,
              ),
            );
          });
      loading = true;
    } catch (e) {
      lista = null;
      print(e.toString());
      loading = false;
    }
    //print(usuario);

    return loading ? lista : Loading();
  }

  

  String esActivo(bool estado) {
    if (estado == true) {
      return "Activo";
    } else {
      return "Inactivo";
    }
  }
}
