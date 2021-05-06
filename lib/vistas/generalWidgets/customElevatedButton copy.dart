import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final dynamic funcion=null;

  const CustomElevatedButton({Key key, @required dynamic funcion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) return Colors.red;
              return Colors.green[600];
            }),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: BorderSide(color: Colors.lightGreen)))),
        onPressed: () {
          // ignore: unnecessary_statements
          funcion;
        },
        child: Text(
          "Iniciar sesión",
          style: TextStyle(fontSize: 25),
        ));
  }
}
