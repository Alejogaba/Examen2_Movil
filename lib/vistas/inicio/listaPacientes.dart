import 'package:flutter/material.dart';
import 'package:libro_de_cobros/entidades/paciente.dart';
import 'package:libro_de_cobros/servicios/pdf_api.dart';
import 'package:libro_de_cobros/vistas/generalWidgets/loading.dart';
import 'package:libro_de_cobros/vistas/perfil/perfilPaciente.dart';
import 'package:provider/provider.dart';

class ListaPacientes extends StatefulWidget {
  final modoSeleccionar;
  final contextPadre;
  ListaPacientes({Key key, this.modoSeleccionar, this.contextPadre})
      : super(key: key);

  @override
  _ListaPacientesState createState() =>
      _ListaPacientesState(this.modoSeleccionar, this.contextPadre);
}

class _ListaPacientesState extends State<ListaPacientes> {
  bool loading = false;
  bool adiccionarPacienteInactivo = false;
  bool modoSeleccionar;
  BuildContext contextPadre;
  _ListaPacientesState(this.modoSeleccionar, this.contextPadre);

  @override
  Widget build(BuildContext context) {
    var lista;
    try {
      final _listaPacientes = Provider.of<List<Paciente>>(context);
      PdfApi.generarTablaPacientes(_listaPacientes);
      lista = ListView.builder(
          itemCount: _listaPacientes.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () async {
                if (modoSeleccionar == false || modoSeleccionar == null) {
                  retornarPaciente(context, _listaPacientes, index);
                } else {
                  if(_listaPacientes[index].estadoActivo==false){
                    await cajaAdvertencia(context);
                    if(adiccionarPacienteInactivo){
                      Navigator.pop(contextPadre, _listaPacientes[index]);
                    }
                  }else{
                    Navigator.pop(contextPadre, _listaPacientes[index]);
                  }
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
                        color: _listaPacientes[index].estadoActivo
                            ? Colors.green
                            : Colors.red),
                  )
                ],
              ),
              subtitle: Row(children: [
                Text('Edad: ' + _listaPacientes[index].edad.toString()),
                Spacer(),
                Text(
                  _listaPacientes[index].ciudad,
                  textAlign: TextAlign.right,
                ),
              ]),
              leading: CircleAvatar(
                child: (_listaPacientes[index].urlImagen == null ||
                        _listaPacientes[index].urlImagen.trim() == '')
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

  void retornarPaciente(
      BuildContext context, List<Paciente> _listaPacientes, int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) =>
                PerfilPaciente(perfil: _listaPacientes, index: index)));
  }

  String esActivo(bool estado) {
    if (estado == true) {
      return "Activo";
    } else {
      return "Inactivo";
    }
  }

  cajaAdvertencia(BuildContext context) async {
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
              "Este paciente esta inactivo, ¿seguro que desea seleccionarlo?"),
          actions: <Widget>[
            ElevatedButton(
              child: Text("Si"),
              onPressed: () {
                adiccionarPacienteInactivo = true;
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text("Cancelar"),
              onPressed: () {
                adiccionarPacienteInactivo = false;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
