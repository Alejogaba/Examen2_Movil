import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageStorage {
  final String uid;
  final String idPaciente;
  final File file;
  ImageStorage({this.uid, this.file, this.idPaciente});

  final StorageReference storage = FirebaseStorage().ref();

//Subir imagen Personal
  Future<void> subirImagenPersonal() async {
    try {
      await storage.child('/Personal/' + uid + ".jpg").putFile(file);
      print("Imagen subida con exito");
    } catch (e) {
      // e.g, e.code == 'canceled'
      print("No se pudo subir la imagen");
    }
  }

//Subir imagen Paciente
  Future<void> subirImagenPaciente() async {
    try {
      await storage.child('/Pacientes/' +idPaciente+ ".jpg").putFile(file);
      print("Imagen subida con exito");
    } catch (e) {
      // e.g, e.code == 'canceled'
      print("No se pudo subir la imagen");
    }
  }
}
