import 'package:flutter/material.dart';
import 'package:libro_de_cobros/servicios/auth.dart';
import 'package:libro_de_cobros/servicios/database.dart';
import 'package:libro_de_cobros/vistas/generalWidgets/loading.dart';
import 'package:libro_de_cobros/vistas/inicio/principal.dart';
import 'package:libro_de_cobros/vistas/inicio/ventanaListaCitasdePersonal.dart';
import '../generalWidgets/customTextField.dart';

class IniciarSesion extends StatefulWidget {
  IniciarSesion({Key key}) : super(key: key);

  @override
  _IniciarSesionState createState() => _IniciarSesionState();
}

class _IniciarSesionState extends State<IniciarSesion> {
  List<String> credenciales = [];
  bool loading = true;
  TextEditingController usernameController;
  TextEditingController passwordController;
  String error = '';

  //final AuthService _auth = AuthService();

  @override
  void initState() {
    usernameController = new TextEditingController();
    passwordController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var scafold = Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        backgroundColor: Colors.green[600],
        elevation: 0.0,
        title: Text('Inicio de sesión'),
        /* actions: <Widget>[
          TextButton.icon(
            style: TextButton.styleFrom(primary: Colors.black),
            icon: Icon(Icons.person),
            label: Text('Registro'),
            onPressed: () => {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => Registro()))
            },
          ),
        ],*/
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('images/flutter.png'),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
            ),
            CustomTextField(
              customController: usernameController,
              labelText: "Nombre de usuario",
              isPassword: false,
            ),
            CustomTextField(
              customController: passwordController,
              labelText: "Contraseña",
              isPassword: true,
            ),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled))
                          return Colors.red;
                        return Colors.green[600];
                      }),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                              side: BorderSide(color: Colors.lightGreen)))),
                  onPressed: () {
                    inicioSesion(
                        context, usernameController, passwordController);
                  },
                  child: Text(
                    "Iniciar sesión",
                    style: TextStyle(fontSize: 25),
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0),
              child: FittedBox(
                  fit: BoxFit.contain,
                  child:
                      null /*TextButton(
                  child: (Text("Iniciar sesión como usuario anonimo",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.green,
                          fontSize: 15,
                          fontWeight: FontWeight.bold))),
                  onPressed: () {
                    inicioSesionAnonimo(context);
                  },
                ),*/
                  ),
            ),
            SizedBox(height: 12.0),
            Text(
              error,
              style: TextStyle(color: Colors.red, fontSize: 14.0),
            )
          ],
        ),
      ),
    );
    return loading ? scafold : Loading();
  }

  inicioSesion(BuildContext context, TextEditingController controladorNombre,
      TextEditingController controladorContrasena) async {
    loading = false;
    AuthService authService = new AuthService();
    dynamic resultado = await authService.inicioSesionUarioContrasena(
        controladorNombre.text, controladorContrasena.text);
    print('Funcion iniciar sesion');

    if (controladorNombre.text.isEmpty || controladorNombre.text.isEmpty) {
      print("No deje campos vacios");
      setState(() {
        loading = true;
        error = "No deje campos vacios";
      });
    } else {
      if (controladorNombre.text.contains(' ') ||
          controladorContrasena.text.contains(' ')) {
        print("No ingrese espacios en blanco");
        setState(() {
          loading = true;
          error = "No ingrese espacios en blanco";
        });
      } else {
        if (resultado.toString().contains("Error")) {
          print("No se pudo iniciar sesión");
          setState(() {
            cajaAdvertencia(context, resultado.toString());
            loading = true;
            error = "No se pudo iniciar sesión";
          });
        } else {
          print(authService.usuarioDeFirebase(resultado).uid);
          if (authService.usuarioDeFirebase(resultado).uid ==
              "YO7JpX5Mk8dLJ73F7suCiBAj4i33") {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => Principal()));
          } else {
            print("No es administrador");
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => VentanaListaCitasdePersonal()));
          }
        }
      }
    }
  }
/*
  inicioSesionAnonimo(BuildContext context) async {
    AuthService authService = new AuthService();
    dynamic resultado = await authService.inicioSesionAnonimo();
    print('Funcion iniciar sesion anonimo');
    print(authService.usuarioDeFirebase(resultado).uid);

    if (resultado == null) {
      print("No se pudo iniciar sesión");
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => Principal()));
    }
  */

  cajaAdvertencia(BuildContext context, String msg) async {
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
          content: Text(msg),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.grey),
              child: Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
