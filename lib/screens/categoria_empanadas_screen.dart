import 'package:flutter/material.dart';

class CategoriaEmpanadasScreen extends StatefulWidget {
  const CategoriaEmpanadasScreen({super.key});

  @override
  State<CategoriaEmpanadasScreen> createState() =>
      _CategoriaEmpanadasScreenState();
}

class _CategoriaEmpanadasScreenState
    extends State<CategoriaEmpanadasScreen> {
  String productoSeleccionado = '';

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
                          'Empanadas',
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
                padding: const EdgeInsets.fromLTRB(
                  7,
                  8,
                  7,
                  20,
                ),
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

                    const SizedBox(height: 8),

                    // TÍTULO
                    tituloSeccion('Empanadas'),

                    // PRIMERA FILA
                    filaProductos([
                      producto(
                        nombre: 'Empanada de Carne',
                        precio: '\$7.500,00',
                      ),
                      producto(
                        nombre: 'Empanada de Matambre',
                        precio: '\$15.500,00',
                      ),
                    ]),

                    const SizedBox(height: 8),

                    // SEGUNDA FILA
                    filaProductos([
                      producto(
                        nombre: 'Empanada de Pescado',
                        precio: '\$12.500,00',
                      ),
                      producto(
                        nombre: 'Empanada de Pollo',
                        precio: '\$15.500,00',
                      ),
                    ]),

                    const SizedBox(height: 8),

                    // TERCERA FILA
                    filaProductos([
                      producto(
                        nombre: 'Empanada de Carne',
                        precio: '\$18.500,00',
                      ),
                      producto(
                        nombre: 'Empanada de Queso con Espinaca',
                        precio: '\$19.500,00',
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
      padding: const EdgeInsets.only(
        left: 1,
        bottom: 5,
      ),
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
        Expanded(
          child: productos[0],
        ),
        const SizedBox(width: 20),
        Expanded(
          child: productos[1],
        ),
      ],
    );
  }

  Widget producto({
    required String nombre,
    required String precio,
  }) {
    final seleccionado = productoSeleccionado == nombre;

    return GestureDetector(
      onTap: () {
        setState(() {
          productoSeleccionado = nombre;
        });
      },
      child: Container(
        height: 91,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: seleccionado
                ? Colors.blue
                : Colors.transparent,
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
            // ESPACIO PARA LA IMAGEN
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
                padding: const EdgeInsets.only(
                  left: 5,
                ),
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