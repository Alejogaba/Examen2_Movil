import 'package:flutter/material.dart';
import 'package:libro_de_cobros/servicios/auth.dart';
import 'package:libro_de_cobros/vistas/inicio/principal.dart';

class Registro extends StatefulWidget {
  Registro({Key key}) : super(key: key);

  @override
  _RegistroState createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  List<String> credenciales = [];

  TextEditingController usernameController;
  TextEditingController passwordController;
  String error = '';

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    usernameController = new TextEditingController();
    passwordController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        backgroundColor: Colors.green[600],
        elevation: 0.0,
        title: Text('Registro'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 190,
                height: 190,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                            "https://cdn.pixabay.com/photo/2016/11/08/15/21/user-1808597_640.png"))),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
              ),
              TextFormField(
                  validator: (val) =>
                      val.isEmpty ? 'Ingrese un correo electronico' : null,
                  controller: usernameController),
              Padding(
                padding: const EdgeInsets.all(24.0),
              ),
              TextFormField(
                obscureText: true,
                validator: (val) => val.length < 6
                    ? 'Ingrese una contraseña mayor a 5 caracteres'
                    : null,
                controller: passwordController,
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
              ),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                          if (states.contains(MaterialState.disabled))
                            return Colors.red;
                          return Colors.green[600];
                        }),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    side:
                                        BorderSide(color: Colors.lightGreen)))),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        dynamic result =
                            await _auth.registroConUsuarioyContrasena(
                                usernameController.text.trim(),
                                passwordController.text.trim());
                        if (result == null) {
                          setState(() {
                            error = 'Please supply a valid email';
                          });
                        } else {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (_) => Principal()));
                        }
                      }
                    },
                    child: Text(
                      "Crear cuenta",
                      style: TextStyle(fontSize: 25),
                    )),
              ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              )
            ],
          ),
        ),
      ),
    );
  }

  inicioSesion(BuildContext context, TextEditingController controladorNombre,
      TextEditingController controladorContrasena) async {
    AuthService authService = new AuthService();
    dynamic resultado = await authService.inicioSesionAnonimo();
    print(authService.usuarioDeFirebase(resultado).uid);
/*
    setState(() {
      if (controladorNombre.text.isEmpty || controladorNombre.text.isEmpty) {
        cajatexto(context, "No deje campos vacios");
      } else {
        if (controladorNombre.text.contains(' ') ||
            controladorContrasena.text.contains(' ')) {
          cajatexto(context, "No ingrese espacios en blanco");
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => Principal()));
        }
      }
    });*/
  }

  Future<dynamic> cajatexto(BuildContext context, String mensaje) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                'Aviso',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Text(
                '$mensaje',
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Ok",
                      style: TextStyle(color: Colors.grey),
                    ))
              ],
            ));
  }
}
