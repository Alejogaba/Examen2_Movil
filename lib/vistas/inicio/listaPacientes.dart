import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:libro_de_cobros/entidades/paciente.dart';
import 'package:libro_de_cobros/entidades/personal.dart';
import 'package:libro_de_cobros/vistas/generalWidgets/loading.dart';
import 'package:libro_de_cobros/vistas/perfil/perfilPaciente.dart';
import 'package:provider/provider.dart';

class ListaPacientes extends StatefulWidget {
  final modoSeleccionar;
  final contextPadre;
  ListaPacientes({Key key,this.modoSeleccionar,this.contextPadre}) : super(key: key);

  @override
  _ListaPacientesState createState() => _ListaPacientesState(this.modoSeleccionar,this.contextPadre);
}

class _ListaPacientesState extends State<ListaPacientes> {
  bool loading = false;
  bool modoSeleccionar;
  BuildContext contextPadre;
  _ListaPacientesState(this.modoSeleccionar, this.contextPadre);
 
  @override
  Widget build(BuildContext context) {
    var lista;
    try {
      final _listaPacientes = Provider.of<List<Paciente>>(context);
      lista = ListView.builder(
          itemCount: _listaPacientes.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: (){
                if (modoSeleccionar==false || modoSeleccionar==null) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => PerfilPaciente(
                            perfil: _listaPacientes, index: index)));
              } else {
                Navigator.pop(contextPadre,_listaPacientes[index]);
              }
              },
              onLongPress: () {
                setState(() {});
              },
              title: Row(
                children: [
                  Text(_listaPacientes[index].nombre +
                    ' ' +
                    _listaPacientes[index].apellido),
                Spacer(),
                Text(
                  _listaPacientes[index].estadoActivo ? 'Activo' : 'Inactivo',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: _listaPacientes[index].estadoActivo ? Colors.green : Colors.red
                  ),
                )
                ],
              ),
              subtitle: Row(children: [
                Text('Edad: '+_listaPacientes[index].edad.toString()),
                Spacer(),
                Text(
                  _listaPacientes[index].ciudad,
                  textAlign: TextAlign.right,
                ),
              ]),
              leading: CircleAvatar(
                child: (_listaPacientes[index].urlImagen == null || _listaPacientes[index].urlImagen.trim()=='')
                    ? Text(_listaPacientes[index]
                        .nombre
                        .toUpperCase()
                        .substring(0, 1))
                    : null,
                backgroundImage: (_listaPacientes[index].urlImagen != null)
                    ? NetworkImage(_listaPacientes[index].urlImagen)
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
