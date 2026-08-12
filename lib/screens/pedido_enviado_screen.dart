import 'package:flutter/material.dart';

class PedidoEnviadoScreen extends StatelessWidget {
  const PedidoEnviadoScreen({super.key});

  static const Color azulFondo = Color(0xFF4E82A6);
  static const Color azulOscuro = Color(0xFF174A75);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: azulFondo,
      body: SafeArea(
        child: Column(
          children: [
            // BARRA SUPERIOR
            Container(
              height: 58,
              color: Colors.white,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.menu,
                      color: azulOscuro,
                      size: 28,
                    ),
                  ),

                  const Expanded(
                    child: Center(
                      child: Text(
                        'Pedido enviado',
                        style: TextStyle(
                          color: azulOscuro,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(right: 15),
                    width: 39,
                    height: 39,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: azulOscuro,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: azulOscuro,
                      size: 27,
                    ),
                  ),
                ],
              ),
            ),

            // CONTENIDO
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 35,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    const Text(
                      'Pedido enviado',
                      style: TextStyle(
                        color: azulOscuro,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // CÍRCULO DE CONFIRMACIÓN
                    Container(
                      width: 130,
                      height: 130,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 75,
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Mesa 2',
                      style: TextStyle(
                        color: azulOscuro,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      '¡Tu pedido fue enviado\na cocina correctamente!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: azulOscuro,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                    ),

                    const Spacer(),

                    // BOTÓN ENTENDIDO
                    SizedBox(
                      width: 150,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: azulOscuro,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          'Entendido',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}