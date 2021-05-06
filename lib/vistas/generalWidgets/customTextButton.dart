import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: (Text("Crear cuenta nueva",
          style: TextStyle(
              decoration: TextDecoration.underline,
              color: Colors.green,
              fontSize: 15,
              fontWeight: FontWeight.bold))),
      onPressed: () {},
    );
  }
}