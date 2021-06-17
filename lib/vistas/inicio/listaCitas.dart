import 'package:flutter/material.dart';
import 'package:libro_de_cobros/entidades/cita.dart';
import 'package:libro_de_cobros/servicios/auth.dart';
import 'package:libro_de_cobros/servicios/pdf_api.dart';
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
  AuthService authService = new AuthService();

  @override
  Widget build(BuildContext context) {
    var lista;
    try {
      final _listaCitas = Provider.of<List<Cita>>(context);
      PdfApi.generarTablaCita(_listaCitas);
      lista = ListView.builder(
          itemCount: _listaCitas.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            PerfilCita(perfil: _listaCitas, index: index)));
              },
              onLongPress: () {
                setState(() {});
              },
              title: Row(
                children: [
                  Text(_listaCitas[index].nombrePaciente),
                  Spacer(),
                  Text(
                    definirFecha(_listaCitas[index].fechaHora) +
                        ' ' +
                        _listaCitas[index].hora,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )
                ],
              ),
              subtitle: Row(children: [
                Text('Lo atendera: ' + _listaCitas[index].nombrePersonalMedico),
                Spacer(),
                Text(
                  _listaCitas[index].estado,
                  textAlign: TextAlign.right,
                ),
              ]),
              leading: CircleAvatar(
                child: (_listaCitas[index].urlImagen == null ||
                        _listaCitas[index].urlImagen.trim() == '')
                    ? Text(_listaCitas[index]
                        .nombrePaciente
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

  String definirFecha(String fechaString) {
    DateTime fecha = DateTime.parse(fechaString);
    DateTime fechaActual = DateTime.now();
    if (fecha.year == fechaActual.year &&
        fecha.month == fechaActual.month &&
        fecha.day == fechaActual.day) {
      return "Hoy";
    } else {
      int diasRestantes = fecha.day - fechaActual.day;
      if (diasRestantes == 1) {
        return "Mañana";
      } else {
        if (diasRestantes <= 7 && diasRestantes > 1) {
          return definirDia(fecha.weekday);
        } else {
          if (diasRestantes > 7 && (fecha.year == fechaActual.year)) {
            return fecha.day.toString() + ' de ' + definirMes(fecha.month);
          } else {
            return fecha.toString().split(' ')[0];
          }
        }
      }
    }
  }

  String definirDia(int numeroSemana) {
    switch (numeroSemana) {
      case 1:
        return "Lunes";
        break;
      case 2:
        return "Martes";
        break;
      case 3:
        return "Miercoles";
      case 4:
        return "Jueves";
        break;
      case 5:
        return "Viernes";
        break;
      case 6:
        return "Sábado";
        break;
      case 7:
        return "Domingo";
        break;
      default:
        return "Indefinido";
    }
  }

  String definirMes(int numMes) {
    switch (numMes) {
      case 1:
        return "Enero";
        break;
      case 2:
        return "Febrero";
        break;
      case 3:
        return "Marzo";
      case 4:
        return "Abril";
        break;
      case 5:
        return "Mayo";
        break;
      case 6:
        return "Junio";
        break;
      case 7:
        return "Julio";
        break;
      case 8:
        return "Agosto";
        break;
      case 9:
        return "Septiembre";
        break;
      case 10:
        return "Octubre";
        break;
      case 11:
        return "Noviembre";
        break;
      case 12:
        return "Diciembre";
        break;
      default:
        return "Indefinido";
    }
  }

  String esActivo(bool estado) {
    if (estado == true) {
      return "Activo";
    } else {
      return "Inactivo";
    }
  }
}
