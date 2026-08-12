import 'package:flutter/material.dart';
import 'menu_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool ocultarPassword = true;

  static const Color azulOscuro = Color(0xFF12345A);
  static const Color azul = Color(0xFF4F86AE);
  static const Color azulClaro = Color(0xFFB5D3E8);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void iniciarSesion() {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completá el email y la contraseña'),
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MenuScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 10,
              left: -18,
              child: circulo(57, azulOscuro),
            ),

            Positioned(
              top: 36,
              left: 105,
              child: circulo(29, const Color(0xFFF0F5F9)),
            ),

            Positioned(
              top: 64,
              left: 74,
              child: circulo(34, azul),
            ),

            Positioned(
              bottom: 65,
              right: 27,
              child: circulo(34, azul),
            ),

            Positioned(
              bottom: 12,
              right: -2,
              child: circulo(27, azulClaro),
            ),

            Positioned(
              top: 430,
              right: -13,
              child: circulo(55, azulOscuro),
            ),

            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(27, 94, 27, 30),
                child: Column(
                  children: [
                    const Text(
                      'BIENVENIDOS',
                      style: TextStyle(
                        color: azulOscuro,
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 31),

                    campo(
                      controller: emailController,
                      hint: 'Email',
                      ocultar: false,
                    ),

                    const SizedBox(height: 7),

                    campo(
                      controller: passwordController,
                      hint: 'Contraseña',
                      ocultar: ocultarPassword,
                      sufijo: IconButton(
                        onPressed: () {
                          setState(() {
                            ocultarPassword = !ocultarPassword;
                          });
                        },
                        icon: Icon(
                          ocultarPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 17,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Te olvidaste la contraseña?',
                      style: TextStyle(
                        color: azulOscuro,
                        fontSize: 10,
                      ),
                    ),

                    const SizedBox(height: 10),

                    ElevatedButton(
                      onPressed: iniciarSesion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: azul,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(91, 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Iniciar Sesion',
                        style: TextStyle(fontSize: 10),
                      ),
                    ),

                    const SizedBox(height: 28),

                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 2,
                            color: azulOscuro,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            'O',
                            style: TextStyle(
                              color: azulOscuro,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 2,
                            color: azulOscuro,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    botonSocial(
                      texto: 'Continuar con Gmail',
                      icono: 'G',
                    ),

                    const SizedBox(height: 10),

                    botonSocial(
                      texto: 'Continuar con Apple',
                      icono: '●',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget circulo(double tamanio, Color color) {
    return Container(
      width: tamanio,
      height: tamanio,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget campo({
    required TextEditingController controller,
    required String hint,
    required bool ocultar,
    Widget? sufijo,
  }) {
    return SizedBox(
      height: 29,
      child: TextField(
        controller: controller,
        obscureText: ocultar,
        style: const TextStyle(fontSize: 10),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontSize: 10,
            color: Colors.black87,
          ),
          suffixIcon: sufijo,
          filled: true,
          fillColor: const Color(0xFFF9F9F9),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget botonSocial({
    required String texto,
    required String icono,
  }) {
    return SizedBox(
      height: 29,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFFF9F9F9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          '$icono     $texto',
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}