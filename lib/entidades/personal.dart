import 'package:cloud_firestore/cloud_firestore.dart';

class Personal {
  final String uid;
  final String email;
  final String contrasena;
  final String nombre;
  final String apellido;
  final String urlImagen;
  final String tipo;
  final bool estadoActivo;
  final String trabajando;

  Personal(
      {this.uid,
      this.email,
      this.contrasena,
      this.nombre,
      this.apellido,
      this.urlImagen,
      this.tipo,
      this.estadoActivo,
      this.trabajando});

static Personal fromSnapshot(DocumentSnapshot snapshot) {
    return Personal(
         uid: snapshot.data['uid'] ?? '',
          email: snapshot.data['email'] ?? '',
          contrasena: snapshot.data['contrasena'] ?? '',
          nombre: snapshot.data['nombre'] ?? '',
          apellido: snapshot.data['apellido'] ?? '',
          urlImagen: snapshot.data['urlImagen'] ?? '',
          estadoActivo: snapshot.data['estadoActivo'] ?? false,
          tipo: snapshot.data['tipo'] ?? '',
          trabajando: snapshot.data['trabajando'] ?? '');
  }
}

