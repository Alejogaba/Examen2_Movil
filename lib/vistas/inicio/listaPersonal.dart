import 'package:flutter/material.dart';
import 'package:libro_de_cobros/entidades/personal.dart';
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
  bool modoSeleccionar;
  BuildContext contextPadre;
  bool adiccionarPersonalInactivo = false;
  _ListaPersonalState(this.modoSeleccionar, this.contextPadre);
  @override
  Widget build(BuildContext context) {
    final _listaPersonal = Provider.of<List<Personal>>(context);
    //print(usuario);
    return ListView.builder(
        itemCount: _listaPersonal.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () async {
              if (modoSeleccionar == false || modoSeleccionar == null) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => PerfilPersonal(
                            perfil: _listaPersonal, index: index)));
              } else {
                if (_listaPersonal[index].estadoActivo == false) {
                  await cajaAdvertencia(context,_listaPersonal[index].tipo);
                  if(adiccionarPersonalInactivo){
                    Navigator.pop(contextPadre, _listaPersonal[index]);
                  }
                }else{
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
  }

  String esActivo(bool estado) {
    if (estado == true) {
      return "Activo";
    } else {
      return "Inactivo";
    }
  }

  cajaAdvertencia(BuildContext context,String tipoPersonal) async {
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
              "Este "+tipoPersonal+" esta inactivo, ¿seguro que desea seleccionarlo?"),
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
}
