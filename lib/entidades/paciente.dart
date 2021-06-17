import 'package:cloud_firestore/cloud_firestore.dart';

class Paciente {
  final String identificacion;
  final String nombre;
  final String apellido;
  final String fechaNacimiento;
  final int edad;
  final bool estadoActivo;
  final String direccion;
  final String barrio;
  final String telefono;
  final String ciudad;
  final String urlImagen;

  Paciente(
      {this.identificacion,
      this.nombre,
      this.apellido,
      this.urlImagen,
      this.fechaNacimiento,
      this.edad,
      this.estadoActivo,
      this.direccion,
      this.barrio,
      this.telefono,
      this.ciudad});

static Paciente fromSnapshot(DocumentSnapshot snapshot) {
    return Paciente(
         identificacion: snapshot.data['identificacion'] ?? '',
          nombre: snapshot.data['nombre'] ?? '',
          apellido: snapshot.data['apellido'] ?? '',
          urlImagen: snapshot.data['urlImagen'] ?? '',
          fechaNacimiento: snapshot.data['fechaNacimiento'] ?? '',
          edad: snapshot.data['edad'] ?? 0,
          estadoActivo: snapshot.data['estadoActivo'] ?? false,
          direccion: snapshot.data['direccion'] ?? '',
          barrio: snapshot.data['barrio'] ?? '',
          telefono: snapshot.data['telefono'] ?? '',
          ciudad: snapshot.data['ciudad'] ?? '');
  }
}
