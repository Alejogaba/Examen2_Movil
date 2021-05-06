import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {Key key,
      @required this.customController,
      this.labelText,
      })
      : super(key: key);

  final TextEditingController customController;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(25.0),
      child: TextFormField(
          style: TextStyle(fontSize: 20),
          validator: (val) => val.isEmpty
                    ? 'No deje campos vacios'
                    : null,
          controller: customController,
          decoration: InputDecoration(labelText: labelText),
          ),
    );
  }
}