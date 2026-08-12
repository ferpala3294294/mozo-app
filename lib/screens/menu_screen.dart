import 'package:flutter/material.dart';
import 'pedidos_screen.dart';
import 'categoria_sandwiches_screen.dart';
import 'categoria_pizzas_screen.dart';
import 'categoria_empanadas_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  static const Color azulFondo = Color(0xFF4E82A6);
  static const Color azulTarjeta = Color(0xFF7199B6);
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
                    onPressed: () {},
                    icon: const Icon(
                      Icons.menu,
                      color: azulOscuro,
                      size: 28,
                    ),
                  ),

                  const Text(
                    'Menú',
                    style: TextStyle(
                      color: azulOscuro,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Spacer(),

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
                  horizontal: 27,
                  vertical: 32,
                ),
                child: Column(
                  children: [
                    // SANDWICHES
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const CategoriaSandwichesScreen(),
                          ),
                        );
                      },
                      child: categoria(
                        icono: Icons.lunch_dining,
                        texto: 'Sandwiches',
                      ),
                    ),

                    const SizedBox(height: 10),

                    // PIZZAS
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const CategoriaPizzasScreen(),
                          ),
                        );
                      },
                      child: categoria(
                        icono: Icons.local_pizza,
                        texto: 'Pizzas',
                      ),
                    ),

                    const SizedBox(height: 10),

                    // EMPANADAS
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const CategoriaEmpanadasScreen(),
                          ),
                        );
                      },
                      child: categoria(
                        icono: Icons.bakery_dining,
                        texto: 'Empanadas',
                      ),
                    ),

                    const SizedBox(height: 10),

                    // BEBIDAS
                    categoria(
                      icono: Icons.local_drink,
                      texto: 'Bebidas',
                    ),

                    const Spacer(),

                    // SIGUIENTE
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const PedidosScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 17,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Siguiente',
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ),
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

  Widget categoria({
    required IconData icono,
    required String texto,
  }) {
    return Container(
      height: 61,
      decoration: BoxDecoration(
        color: azulTarjeta,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 61,
            height: 61,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icono,
              color: azulOscuro,
              size: 38,
            ),
          ),

          Expanded(
            child: Center(
              child: Text(
                texto,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}