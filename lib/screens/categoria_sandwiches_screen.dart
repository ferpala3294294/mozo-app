import 'package:flutter/material.dart';

class CategoriaSandwichesScreen extends StatefulWidget {
  const CategoriaSandwichesScreen({super.key});

  @override
  State<CategoriaSandwichesScreen> createState() =>
      _CategoriaSandwichesScreenState();
}

class _CategoriaSandwichesScreenState
    extends State<CategoriaSandwichesScreen> {
  String productoSeleccionado = 'Suizo';

  static const Color azulOscuro = Color(0xFF174A75);
  static const Color azulBoton = Color(0xFF4E82A6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // BARRA SUPERIOR
            Container(
              height: 67,
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
                      size: 27,
                    ),
                  ),

                  const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Categoría',
                          style: TextStyle(
                            color: azulOscuro,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Sandwiches',
                          style: TextStyle(
                            color: azulOscuro,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(right: 12),
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(7, 8, 7, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // FILTROS
                    Row(
                      children: [
                        filtro(),
                        const SizedBox(width: 14),
                        filtro(),
                        const SizedBox(width: 14),
                        filtro(),
                        const SizedBox(width: 14),
                        filtro(),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // HAMBURGUESAS
                    tituloSeccion('Hamburguesas'),

                    filaProductos([
                      producto(
                        nombre: 'Hamburguesa Simple',
                        precio: '\$10.000,00',
                      ),
                      producto(
                        nombre: 'Hamburguesa Mexicana',
                        precio: '\$8.500,00',
                      ),
                    ]),

                    const SizedBox(height: 8),

                    // LOMITOS
                    tituloSeccion('Lomitos'),

                    filaProductos([
                      producto(
                        nombre: 'Lomito Simple',
                        precio: '\$15.000,00',
                      ),
                      producto(
                        nombre: 'Lomito Completo',
                        precio: '\$17.000,00',
                      ),
                    ]),

                    const SizedBox(height: 8),

                    // CHARLY / SUIZO
                    tituloSeccion('Charly / Suizo'),

                    filaProductos([
                      producto(
                        nombre: 'Charly',
                        precio: '\$15.000,00',
                      ),
                      producto(
                        nombre: 'Suizo',
                        precio: '\$16.000,00',
                        seleccionado: productoSeleccionado == 'Suizo',
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget filtro() {
    return Expanded(
      child: Container(
        height: 25,
        decoration: BoxDecoration(
          color: azulBoton,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget tituloSeccion(String texto) {
    return Padding(
      padding: const EdgeInsets.only(left: 1, bottom: 5),
      child: Text(
        texto,
        style: const TextStyle(
          color: azulOscuro,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget filaProductos(List<Widget> productos) {
    return Row(
      children: [
        Expanded(child: productos[0]),
        const SizedBox(width: 20),
        Expanded(child: productos[1]),
      ],
    );
  }

  Widget producto({
    required String nombre,
    required String precio,
    bool seleccionado = false,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          productoSeleccionado = nombre;
        });
      },
      child: Container(
        height: 87,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: seleccionado ? Colors.blue : Colors.transparent,
            width: seleccionado ? 2 : 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            // ESPACIO PARA IMAGEN
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: const Color(0xFFD8D8D8),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Center(
                  child: Icon(
                    Icons.image_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),

            // NOMBRE
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  nombre,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 7,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // PRECIO
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 5,
                  bottom: 3,
                ),
                child: Text(
                  precio,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 6,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}