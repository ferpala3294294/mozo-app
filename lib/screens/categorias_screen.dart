import 'package:flutter/material.dart';
import 'categoria_sandwiches_screen.dart';
import 'categoria_pizzas_screen.dart';
import 'categoria_empanadas_screen.dart';
import 'categoria_bebidas_screen.dart';
import 'categoria_combos_screen.dart';
import 'detalle.dart';

class CategoriasScreen extends StatelessWidget {
  final int mesa;
  final int idMesa;

  const CategoriasScreen({
    super.key,
    required this.mesa,
    required this.idMesa,
    
  });

  static const Color azulFondo = Color(0xFFF8F6F0);
static const Color azulTarjeta = Color(0xFFFFFFFF);
static const Color azulOscuro = Color(0xFF1E293B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: azulFondo,
      body: SafeArea(
        child: Column(
          children: [
            // BARRA SUPERIOR
            Container(
              height: 82,
              color: const Color(0xFF121A2B),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Categorías',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Mesa $mesa',
                          style: const TextStyle(
                            color: Color(0xFFE2E8F0),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),
                ],
              ),
            ),

            // CONTENIDO
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final ancho = constraints.maxWidth;
                  final altoDisponible = constraints.maxHeight;

                  final esCelular = ancho < 600;

                  final double paddingHorizontal = esCelular
                      ? (ancho * 0.06).clamp(20.0, 28.0)
                      : 40.0;

                  // TARJETAS UN POCO MÁS CHICAS
                  final double altoTarjeta = esCelular
                       ? (altoDisponible * 0.070).clamp(56.0, 66.0)
    : 64.0;

                  // ESPACIO ENTRE TARJETAS
                  final double espacio = esCelular ? 9.0 : 14.0;

                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: paddingHorizontal,
                        vertical: esCelular ? 16.0 : 30.0,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 900,
                        ),
                        child: Column(
                          children: [
                            const Text(
                              '¿Qué querés pedir?',
                              style: TextStyle(
                                color: azulOscuro,
                                fontSize: 27,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 8),

                            Text(
                              'Mesa $mesa',
                              style: const TextStyle(
                                color: azulOscuro,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const SizedBox(height: 28),

                            // SANDWICHES
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CategoriaSandwichesScreen(
                                      mesa: mesa,
                                        idMesa: idMesa,
                                    ),
                                  ),
                                );
                              },
                              child: categoria(
                                icono: Icons.lunch_dining,
                                texto: 'Sandwiches',
                                alto: altoTarjeta,
                                ancho: ancho,
                              ),
                            ),

                            SizedBox(height: espacio),

                            // PIZZAS
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CategoriaPizzasScreen(
                                      mesa: mesa,
                                        idMesa: idMesa,
                                    ),
                                  ),
                                );
                              },
                              child: categoria(
                                icono: Icons.local_pizza,
                                texto: 'Pizzas',
                                alto: altoTarjeta,
                                ancho: ancho,
                              ),
                            ),

                            SizedBox(height: espacio),

                            // EMPANADAS
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CategoriaEmpanadasScreen(
                                      mesa: mesa,
                                        idMesa: idMesa,
                                    ),
                                  ),
                                );
                              },
                              child: categoria(
                                icono: Icons.bakery_dining,
                                texto: 'Empanadas',
                                alto: altoTarjeta,
                                ancho: ancho,
                              ),
                            ),

                            SizedBox(height: espacio),

                            // BEBIDAS
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CategoriaBebidasScreen(
                                      mesa: mesa,
                                        idMesa: idMesa,
                                    ),
                                  ),
                                );
                              },
                              child: categoria(
                                icono: Icons.local_drink,
                                texto: 'Bebidas',
                                alto: altoTarjeta,
                                ancho: ancho,
                              ),
                            ),

                            SizedBox(height: espacio),
                            // COMBOS
GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoriaCombosScreen(
          mesa: mesa,
          idMesa: idMesa,
        ),
      ),
    );
  },
  child: categoria(
    icono: Icons.fastfood,
    texto: 'Combos',
    alto: altoTarjeta,
    ancho: ancho,
  ),
),

SizedBox(height: espacio),
                            // VER PEDIDO
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetalleScreen(
  mesa: mesa,
   idMesa: idMesa,
),
                                  ),
                                );
                              },
                              child: categoria(
                                icono: Icons.shopping_cart_outlined,
                                texto: 'Ver pedido',
                                alto: altoTarjeta,
                                ancho: ancho,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
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
    required double alto,
    required double ancho,
  }) {
    final bool esCelular = ancho < 600;

    return SizedBox(
      width: double.infinity,
      height: alto,
      child: Container(
        decoration: BoxDecoration(
  color: texto == 'Ver pedido'
      ? const Color(0xFFD97706)
      : azulTarjeta,
  borderRadius: BorderRadius.circular(
    esCelular ? 15 : 14,
  ),
),
        child: Row(
          children: [
            // CUADRADO DEL ICONO
            SizedBox(
              width: alto,
              height: alto,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    esCelular ? 15 : 14,
                  ),
                ),
                child: Center(
                  child: Icon(
                    icono,
                    color: azulOscuro,
                    size: esCelular
                        ? (alto * 0.48).clamp(40.0, 55.0)
                        : (alto * 0.52).clamp(28.0, 42.0),
                  ),
                ),
              ),
            ),

            // TEXTO
            Expanded(
              child: Center(
                child: Text(
                  texto,
                  textAlign: TextAlign.center,
                  style: TextStyle(
  color: texto == 'Ver pedido'
      ? Colors.white
      : azulOscuro,
  fontSize: esCelular ? 21 : 20,
  fontWeight: FontWeight.bold,
),
                ),
              ),
            ),

            // ESPACIO DEL LADO DERECHO
            SizedBox(
              width: alto,
              height: alto,
            ),
          ],
        ),
      ),
    );
  }
}