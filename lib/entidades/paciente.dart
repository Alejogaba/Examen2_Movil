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
}
