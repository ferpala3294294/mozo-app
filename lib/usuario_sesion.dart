class UsuarioSesion {
  UsuarioSesion._();

  static int id = 0;
  static String nombre = 'Admin';
  static String rol = 'Administrador';

  static void establecer({
    required int idUsuario,
    required String nombreUsuario,
    required String rolUsuario,
  }) {
    id = idUsuario;
    nombre = nombreUsuario;
    rol = rolUsuario;
  }

  static void limpiar() {
    id = 0;
    nombre = '';
    rol = '';
  }
}