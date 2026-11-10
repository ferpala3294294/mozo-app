import 'package:flutter/material.dart';
import 'menu_screen.dart';
import 'login_screen.dart';
import '../usuario_sesion.dart';

class PedidoEnviadoScreen extends StatelessWidget {
  final String mesa;
  final String producto;
  final int cantidad;
  final String observacion;

  const PedidoEnviadoScreen({
    super.key,
    required this.mesa,
    required this.producto,
    required this.cantidad,
    required this.observacion,
  });

  static const Color azulFondo = Color(0xFFF8F6F0);
static const Color azulOscuro = Color(0xFF1E293B);
static const Color azul = Color(0xFF64748B);
static const Color verde = Color(0xFF10B981);

  // =====================================================
  // PANEL DE USUARIO
  // =====================================================

  void abrirPanelUsuario(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Perfil',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.centerRight,
          child: Material(
            color: Colors.transparent,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final anchoPantalla = constraints.maxWidth;

                final anchoPanel = anchoPantalla < 600
                    ? anchoPantalla * 0.88
                    : 420.0;

                return SizedBox(
                  width: anchoPanel,
                  height: double.infinity,
                  child: Container(
                    color: Colors.white,
                    child: SafeArea(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // BOTÓN CERRAR
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: Color(0xFF1E293B),
                                  size: 32,
                                ),
                              ),
                            ),

                            const SizedBox(height: 25),

                            // FOTO / ÍCONO DE USUARIO
                            Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFE2E8F0),
                                border: Border.all(
                                    color: const Color(0xFF1E293B),
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 85,
                                color: Color(0xFF1E293B),
                              ),
                            ),

                            const SizedBox(height: 25),

                            // NOMBRE
                            Text(
  UsuarioSesion.nombre,
  textAlign: TextAlign.center,
  style: const TextStyle(
    color: Color(0xFF1E293B),
    fontSize: 26,
    fontWeight: FontWeight.bold,
  ),
),

                            const SizedBox(height: 8),

                            // ROL
                            Text(
  UsuarioSesion.rol,
  style: const TextStyle(
    color: Color(0xFF64748B),
    fontSize: 20,
  ),
),

                            const SizedBox(height: 30),

                            const Divider(
                               color: Color(0xFFE2E8F0),
                              thickness: 1,
                              indent: 30,
                              endIndent: 30,
                            ),

                            // CERRAR SESIÓN
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 35,
                                vertical: 8,
                              ),
                              leading: const Icon(
  Icons.logout,
  color: Color(0xFFD97706),
  size: 30,
),
                              title: const Text(
  'Cerrar sesión',
  style: TextStyle(
    color: Color(0xFFD97706),
    fontSize: 20,
    fontWeight: FontWeight.w600,
  ),
),
                              onTap: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const LoginScreen(),
                                  ),
                                  (route) => false,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
      transitionBuilder: (
        context,
        animation,
        secondaryAnimation,
        child,
      ) {
        final desplazamiento = Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
        );

        return SlideTransition(
          position: desplazamiento,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: azulFondo,
      body: SafeArea(
        child: Column(
          children: [
            // =====================================================
            // BARRA SUPERIOR
            // =====================================================

            Container(
              height: 58,
              color: const Color(0xFF121A2B),
              child: Row(
                children: [
                  const SizedBox(width: 25),

                  const Expanded(
                    child: Center(
                      child: Text(
                        'Pedido enviado',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // =================================================
                  // BOTÓN USUARIO
                  // =================================================

                  Container(
                    margin: const EdgeInsets.only(right: 15),
                    width: 39,
                    height: 39,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        abrirPanelUsuario(context);
                      },
                      icon: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 27,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // =====================================================
            // CONTENIDO
            // =====================================================

            Expanded(
              child: Stack(
                children: [
                  // =================================================
                  // DETALLES DECORATIVOS DEL FONDO
                  // =================================================

                  Positioned(
                    top: -80,
                    left: -70,
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: azul.withOpacity(0.08),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: -100,
                    right: -70,
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: azul.withOpacity(0.08),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 100,
                    left: 55,
                    child: Icon(
                      Icons.auto_awesome,
                      size: 22,
                      color: azul.withOpacity(0.18),
                    ),
                  ),

                  Positioned(
                    top: 210,
                    right: 55,
                    child: Icon(
                      Icons.auto_awesome,
                      size: 18,
                      color: azul.withOpacity(0.16),
                    ),
                  ),

                  Positioned(
                    bottom: 120,
                    left: 75,
                    child: Icon(
                      Icons.auto_awesome,
                      size: 17,
                      color: azul.withOpacity(0.15),
                    ),
                  ),

                  // =================================================
                  // CONTENIDO PRINCIPAL
                  // =================================================

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 25,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 35),

                        // =============================================
                        // CÍRCULO DE CONFIRMACIÓN
                        // =============================================

                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: verde,
                            boxShadow: [
                              BoxShadow(
                                color: verde.withOpacity(0.25),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.8),
                                width: 3,
                              ),
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 75,
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // =============================================
                        // MESA
                        // =============================================

                        Text(
                          mesa.isEmpty ? 'Sin mesa' : mesa,
                          style: const TextStyle(
                            color: azulOscuro,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // LÍNEA DECORATIVA
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 65,
                              height: 2,
                              color: azul.withOpacity(0.20),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: azul,
                              ),
                            ),
                            Container(
                              width: 65,
                              height: 2,
                              color: azul.withOpacity(0.20),
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        // =============================================
                        // MENSAJE
                        // =============================================

                        const Text(
                          '¡Tu pedido fue enviado\na cocina correctamente!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: azulOscuro,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                          ),
                        ),

                        const Spacer(),

                        // =============================================
                        // BOTÓN ENTENDIDO
                        // =============================================

                        SizedBox(
                          width: 150,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const MenuScreen(),
                                ),
                                (route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD97706),
foregroundColor: Colors.white,
elevation: 3,
shadowColor: const Color(0xFFD97706).withOpacity(0.25),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Entendido',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}