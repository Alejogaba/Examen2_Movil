class Usuario {
  final String uid;
  int index;
  String urlImagen;
  String nombre;
  String apellido;
  String profesion;
  DateTime fechaNacimiento;

  Usuario(this.nombre, this.apellido, {this.profesion, this.fechaNacimiento,
      this.index, this.urlImagen, this.uid});
}
