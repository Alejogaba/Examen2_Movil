import 'package:firebase_auth/firebase_auth.dart';
import 'package:libro_de_cobros/entidades/usuario.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

//retorna un usuario con atributos personalizados basado en un objeto FirebaseUser
  Usuario usuarioDeFirebase(FirebaseUser usuario) {
    return (usuario != null) ? Usuario('Anonimo', '', uid: usuario.uid) : null;
  }

//Retirna el id unico (UID) del usuario
  Future<String> getCurrentUid() async {
    return usuarioDeFirebase(await _auth.currentUser()).uid;
  }

//Stream con mapeo de usuario
  Stream<Usuario> get usuario {
    return _auth.onAuthStateChanged
        .map(usuarioDeFirebase);
  }

//inicio de secion como usuario anonimo
  Future inicioSesionAnonimo() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return user;
    } catch (e) {
      print('Error: No se puede iniciar sesión como usuario anonimo, ' +
          e.toString());
      return null;
    }
  }

//inicio de sesion con email y contraseña
  Future inicioSesionUarioContrasena(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

//Registrarse con usuario y contraseña
  Future registroConUsuarioyContrasena(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return usuarioDeFirebase(result.user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

//Cerrar sesión
  Future cerrarSesion() async {
    try {
      print('Se ha cerrado sesión');
      return _auth.signOut();
    } catch (e) {
      print('Error al cerrar sesión: ' + e.toString());
      return null;
    }
  }
}
