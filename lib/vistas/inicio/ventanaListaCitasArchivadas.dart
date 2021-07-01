import 'package:flutter/material.dart';
import 'package:libro_de_cobros/entidades/cita.dart';
import 'package:libro_de_cobros/entidades/personal.dart';
import 'package:libro_de_cobros/servicios/auth.dart';
import 'package:libro_de_cobros/servicios/database.dart';
import 'package:libro_de_cobros/vistas/autenticar/iniciarSesion.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:libro_de_cobros/vistas/inicio/listaCitas.dart';
import 'package:libro_de_cobros/vistas/inicio/listaPacientes.dart';
import 'package:provider/provider.dart';
import 'package:libro_de_cobros/vistas/inicio/listaPersonal.dart';

class VentanaListaCitasArchivadas extends StatefulWidget {
  VentanaListaCitasArchivadas({Key key}) : super(key: key);

  @override
  _VentanaListaCitasArchivadasState createState() =>
      _VentanaListaCitasArchivadasState();
}

class _VentanaListaCitasArchivadasState
    extends State<VentanaListaCitasArchivadas>
    with SingleTickerProviderStateMixin {
  AuthService authService = new AuthService();
  dynamic providerTipo = Personal;
  DateTime fechaInicial = DateTime.now().add(Duration(days: -7));
  DateTime fechaFinal = DateTime.now().add(Duration(days: 7));
  dynamic providerValue = DatabaseService().usuariosPersonal;
  String titulo = 'Lista personal de la salud';
  int tabIndex = 0;

  final List<Tab> myTabs = <Tab>[
    new Tab(
      child: ListaPersonal(),
    ),
    new Tab(child: ListaPacientes()),
    new Tab(child: Icon(Icons.view_agenda)),
  ];

  TabController _tabController;

  _VentanaListaCitasArchivadasState();

  @override
  void initState() {
    _tabController = new TabController(length: myTabs.length, vsync: this);

    //DatabaseService(uid: uid).usuarios;
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var streamProvider = StreamProvider<List<Cita>>.value(
      value: DatabaseService()
          .citasArchivadas,
      initialData: null,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Citas archivadas"),
          actions: [
            IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () async {
                final List<DateTime> picked =
                    await DateRangePicker.showDatePicker(
                        context: context,
                        initialFirstDate: fechaInicial,
                        initialLastDate: fechaFinal,
                        firstDate: new DateTime(2020),
                        lastDate: new DateTime(DateTime.now().year + 2));
                if (picked != null) {
                  print(picked);
                  setState(() {
                  });
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => IniciarSesion()));
                await authService.cerrarSesion();
              },
            ),
          ],
        ),
        body: ListaCitas(
          msgAtender: 'Lo atendió: ',
          citaArchivada: true,
        ),
      ),
    );
    return streamProvider;
  }
}
