import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:libro_de_cobros/entidades/cita.dart';
import 'package:libro_de_cobros/entidades/paciente.dart';
import 'package:libro_de_cobros/entidades/personal.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

//Insertar datos de personal medico a firestore
  Future<void> insertarDatosPersonal(
      String email,
      String contrasena,
      String nombre,
      String apellido,
      String urlImagen,
      String tipo,
      bool estadoActivo,
      String trabajando) async {
    final CollectionReference collection =
        Firestore.instance.collection('Personal');
    return await collection.document(uid).setData({
      'uid': uid,
      'email': email,
      'contrasena': contrasena,
      'nombre': nombre,
      'apellido': apellido,
      'urlImagen': urlImagen,
      'tipo': tipo,
      'estadoActivo': estadoActivo,
      'trabajando': trabajando
    });
  }

//Insertar datos de paciente a firestore
  Future<void> insertarDatosPaciente(
    String identificacion,
    String nombre,
    String apellido,
    String urlImagen,
    DateTime fechaNacimiento,
    int edad,
    bool estadoActivo,
    String direccion,
    String barrio,
    String telefono,
  ) async {
    final CollectionReference collection =
        Firestore.instance.collection('Pacientes');
    return await collection.document(identificacion).setData({
      'identificacion': identificacion,
      'nombre': nombre,
      'apellido': apellido,
      'urlImagen': urlImagen,
      'fechaNacimiento': fechaNacimiento.toString(),
      'edad': edad,
      'estadoActivo': estadoActivo,
      'direccion': direccion,
      'barrio': barrio,
      'telefono': telefono,
      'ciudad': 'Valledupar'
    });
  }

//Insertar datos de cita a firestore
  Future<void> insertarDatosCita(
    String uidPersonalMedico,
    String nombrePersonalMedico,
    String idPaciente,
    String nombrePaciente,
    DateTime fechaHora,
    String hora,
    String estado,
    String urlImagen,
  ) async {
    final CollectionReference collection =
        Firestore.instance.collection('Citas');
    String id = collection.document().documentID.toString();
    return await collection.document(id).setData({
      'uidPersonalMedico': uidPersonalMedico,
      'nombrePersonalMedico': nombrePersonalMedico,
      'idPaciente': idPaciente,
      'nombrePaciente': nombrePaciente,
      'idCita': id,
      'fechaHora': fechaHora.toString(),
      'hora': hora,
      'estado': estado,
      'urlImagen': urlImagen,
    });
  }

//Cargar datos personal medico desde firestore
  List<Personal> _personalListFromSnapshot(QuerySnapshot snapshots) {
    return snapshots.documents.map((doc) {
      return Personal(
          uid: doc.data['uid'] ?? '',
          email: doc.data['email'] ?? '',
          contrasena: doc.data['contrasena'] ?? '',
          nombre: doc.data['nombre'] ?? '',
          apellido: doc.data['apellido'] ?? '',
          urlImagen: doc.data['urlImagen'] ?? '',
          estadoActivo: doc.data['estadoActivo'] ?? false,
          tipo: doc.data['tipo'] ?? '',
          trabajando: doc.data['trabajando'] ?? '');
    }).toList();
  }

//Cargar datos pacientes desde firestore
  List<Paciente> _pacienteListFromSnapshot(QuerySnapshot snapshots) {
    return snapshots.documents.map((doc) {
      return Paciente(
          identificacion: doc.data['identificacion'] ?? '',
          nombre: doc.data['nombre'] ?? '',
          apellido: doc.data['apellido'] ?? '',
          urlImagen: doc.data['urlImagen'] ?? '',
          fechaNacimiento: doc.data['fechaNacimiento'] ?? '',
          edad: doc.data['edad'] ?? 0,
          estadoActivo: doc.data['estadoActivo'] ?? false,
          direccion: doc.data['direccion'] ?? '',
          barrio: doc.data['barrio'] ?? '',
          telefono: doc.data['telefono'] ?? '',
          ciudad: doc.data['ciudad'] ?? '');
    }).toList();
  }

//Cargar datos citas desde firestore
  List<Cita> _citasListFromSnapshot(QuerySnapshot snapshots) {
    return snapshots.documents.map((doc) {
      return Cita(
        uidPersonalMedico: doc.data['uidPersonalMedico'] ?? '',
        nombrePersonalMedico: doc.data['nombrePersonalMedico'] ?? '',
        idPaciente: doc.data['idPaciente'] ?? '',
        nombrePaciente: doc.data['nombrePaciente'] ?? '',
        idCita: doc.data['idCita'] ?? '',
        fechaHora: doc.data['fechaHora'] ?? '',
        hora: doc.data['hora'] ?? '',
        estado: doc.data['estado'] ?? '',
        urlImagen: doc.data['urlImagen'] ?? '',
      );
    }).toList();
  }

  Stream<List<Paciente>> get usuariosPacientes {
    try {
      final CollectionReference collection =
          Firestore.instance.collection('Pacientes');
      return collection.snapshots().map(_pacienteListFromSnapshot);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Stream<List<Personal>> get usuariosPersonal {
    final CollectionReference collection =
        Firestore.instance.collection('Personal');
    return collection.snapshots().map(_personalListFromSnapshot);
  }

  Stream<List<Cita>> get citas {
    final CollectionReference collection =
        Firestore.instance.collection('Citas');
    return collection.snapshots().map(_citasListFromSnapshot);
  }
}
