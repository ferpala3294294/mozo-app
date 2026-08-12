import 'package:flutter/material.dart';
import 'pedido_enviado_screen.dart';

class PedidosScreen extends StatefulWidget {
  const PedidosScreen({super.key});

  @override
  State<PedidosScreen> createState() => _PedidosScreenState();
}

class _PedidosScreenState extends State<PedidosScreen> {
  String? mesa;
  String? categoria;
  String? producto;
  String? tipoPapa;
  int cantidad = 1;

  final List<String> mesas = [
    'Mesa 1',
    'Mesa 2',
    'Mesa 3',
    'Mesa 4',
    'Mesa 5',
  ];

  final List<String> categorias = [
    'Sandwiches',
    'Empanadas',
    'Pizzas',
    'Bebidas',
  ];

  final List<String> productos = [
    'Hamburguesa',
    'Milanesa',
    'Lomito',
  ];

  final List<String> papas = [
    'Con papa',
    'Sin papa',
  ];

  final List<int> cantidades = [
    1,
    2,
    3,
    4,
    5,
  ];

  void enviarPedido() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PedidoEnviadoScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E9E9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF72B5E4),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Sandwichería Gabriel',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Nuevo',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          child: selector(
                            valor: mesa,
                            hint: 'Mesa',
                            opciones: mesas,
                            onChanged: (valor) {
                              setState(() {
                                mesa = valor;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: selector(
                            valor: categoria,
                            hint: 'Categoría',
                            opciones: categorias,
                            onChanged: (valor) {
                              setState(() {
                                categoria = valor;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: selector(
                            valor: producto,
                            hint: 'Producto',
                            opciones: productos,
                            onChanged: (valor) {
                              setState(() {
                                producto = valor;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: selector(
                            valor: cantidad.toString(),
                            hint: 'Cantidad',
                            opciones:
                                cantidades.map((e) => e.toString()).toList(),
                            onChanged: (valor) {
                              if (valor != null) {
                                setState(() {
                                  cantidad = int.parse(valor);
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: columnaBotones(
                            categorias,
                            categoria,
                            (valor) {
                              setState(() {
                                categoria = valor;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: columnaBotones(
                            productos,
                            producto,
                            (valor) {
                              setState(() {
                                producto = valor;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: columnaBotones(
                            papas,
                            tipoPapa,
                            (valor) {
                              setState(() {
                                tipoPapa = valor;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: columnaBotones(
                            cantidades.map((e) => e.toString()).toList(),
                            cantidad.toString(),
                            (valor) {
                              if (valor != null) {
                                setState(() {
                                  cantidad = int.parse(valor);
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            mesa = null;
                            categoria = null;
                            producto = null;
                            tipoPapa = null;
                            cantidad = 1;
                          });
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 28,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    Container(
                      width: 100,
                      height: 2,
                      color: Colors.white,
                    ),

                    const SizedBox(height: 12),

                    Container(
                      width: 100,
                      height: 2,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                12,
                8,
                12,
                18,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 85,
                    height: 30,
                    decoration: BoxDecoration(
                      color: const Color(0xFF062D55),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      '\$     0',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: enviarPedido,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF062D55),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(105, 30),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Enviar Pedido',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
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

  Widget selector({
    required String? valor,
    required String hint,
    required List<String> opciones,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF062D55),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: opciones.contains(valor) ? valor : null,
          hint: Text(
            hint,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 8,
            ),
          ),
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
            size: 16,
          ),
          dropdownColor: const Color(0xFF062D55),
          isExpanded: true,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 8,
          ),
          items: opciones.map((opcion) {
            return DropdownMenuItem<String>(
              value: opcion,
              child: Text(opcion),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget columnaBotones(
    List<String> opciones,
    String? seleccionado,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      children: opciones.map((opcion) {
        final bool activo = seleccionado == opcion;

        return Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: SizedBox(
            width: double.infinity,
            height: 29,
            child: ElevatedButton(
              onPressed: () {
                onChanged(opcion);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: activo
                    ? const Color(0xFF174A75)
                    : const Color(0xFF062D55),
                foregroundColor: Colors.white,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              child: Text(
                opcion,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 8,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}