import 'package:flutter/material.dart';
import 'package:libro_de_cobros/entidades/cita.dart';
import 'package:libro_de_cobros/entidades/personal.dart';
import 'package:libro_de_cobros/servicios/database.dart';
import 'package:libro_de_cobros/servicios/pdf_api.dart';
import 'package:libro_de_cobros/vistas/generalWidgets/loading.dart';
import 'package:libro_de_cobros/vistas/perfil/perfilPersonal.dart';
import 'package:provider/provider.dart';

class ListaPersonal extends StatefulWidget {
  final modoSeleccionar;
  final contextPadre;
  ListaPersonal({Key key, this.modoSeleccionar, this.contextPadre})
      : super(key: key);

  @override
  _ListaPersonalState createState() =>
      _ListaPersonalState(this.modoSeleccionar, this.contextPadre);
}

class _ListaPersonalState extends State<ListaPersonal> {
  bool loading = false;
  bool modoSeleccionar;
  BuildContext contextPadre;
  bool adiccionarPersonalInactivo = false;
  List<Cita> citasPendientes = [];
  List<Cita> citasAsignadas = [];
  _ListaPersonalState(this.modoSeleccionar, this.contextPadre);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var lista;
    try {
      final _listaPersonal = Provider.of<List<Personal>>(context);
      PdfApi.generarTablaPersonal(_listaPersonal);
      //print(usuario);
      lista = ListView.builder(
          itemCount: _listaPersonal.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () async {
                if (modoSeleccionar == false || modoSeleccionar == null) {
                  citasPendientes = await DatabaseService().citasPendientesPersonal(_listaPersonal[index].uid);
                  print(citasPendientes.length.toString() + ' citas pendientes');
                  citasAsignadas = await DatabaseService().citasAsignadasPersonal(_listaPersonal[index].uid);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => PerfilPersonal(
                              perfil: _listaPersonal, index: index,citasPendientes: citasPendientes.length,citasAsignadas: citasAsignadas.length)));
                } else {
                  if (_listaPersonal[index].estadoActivo == false) {
                    await cajaAdvertencia(context, _listaPersonal[index].tipo);
                    if (adiccionarPersonalInactivo) {
                      Navigator.pop(contextPadre, _listaPersonal[index]);
                    }
                  } else {
                    Navigator.pop(contextPadre, _listaPersonal[index]);
                  }
                }
              },
              onLongPress: () {
                setState(() {});
              },
              title: Row(
                children: [
                  Text(_listaPersonal[index].nombre +
                      ' ' +
                      _listaPersonal[index].apellido),
                  Spacer(),
                  Text(
                    _listaPersonal[index].estadoActivo ? 'Activo' : 'Inactivo',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: _listaPersonal[index].estadoActivo
                            ? Colors.green
                            : Colors.red),
                  )
                ],
              ),
              subtitle: Row(children: [
                Image.asset(iconoTipoPersonal(_listaPersonal[index].tipo)),
                SizedBox(width: 8),
                Text(_listaPersonal[index].tipo),
                Spacer(),
                Text(
                  _listaPersonal[index].trabajando,
                  textAlign: TextAlign.right,
                ),
              ]),
              leading: CircleAvatar(
                child: (_listaPersonal[index].urlImagen == null ||
                        _listaPersonal[index].urlImagen.trim() == '')
                    ? Text(_listaPersonal[index]
                        .nombre
                        .toUpperCase()
                        .substring(0, 1))
                    : null,
                backgroundImage: (_listaPersonal[index].urlImagen != null)
                    ? NetworkImage(_listaPersonal[index].urlImagen)
                    : null,
              ),
            );
          });
      loading = true;
    } catch (e) {
      print("Error lista Personal: " + e.message);
      loading = false;
    }

    return loading ? lista : Loading();
  }

  String esActivo(bool estado) {
    if (estado == true) {
      return "Activo";
    } else {
      return "Inactivo";
    }
  }

  cajaAdvertencia(BuildContext context, String tipoPersonal) async {
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
          content: Text("Este " +
              tipoPersonal +
              " esta inactivo, ¿seguro que desea seleccionarlo?"),
          actions: <Widget>[
            ElevatedButton(
              child: Text("Si"),
              onPressed: () {
                adiccionarPersonalInactivo = true;
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text("Cancelar"),
              onPressed: () {
                adiccionarPersonalInactivo = false;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String iconoTipoPersonal(String tipo) {
    if (tipo == "Fisioterapeuta") {
      return "images/fisioterapia.png";
    }else{
      if(tipo=="Medico"){
         return "images/medico.png";
      }else{
         return "images/enfermera.png";
      }
    }
  }
}
