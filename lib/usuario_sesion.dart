
class UsuarioSesion {
  UsuarioSesion._();

  static String nombre = 'Admin';
  static String rol = 'Administrador';

  static void establecer({
    required String nombreUsuario,
    required String rolUsuario,
  }) {
    nombre = nombreUsuario;
    rol = rolUsuario;
  }

  static void limpiar() {
    nombre = '';
    rol = '';
  }
}
