import 'package:flutter/material.dart';
import 'confirmar_pedido_screen.dart';
import 'pedido_manager.dart';

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

  final PedidoManager pedidoManager = PedidoManager.instancia;

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

  final Map<String, List<Map<String, dynamic>>> productosPorCategoria = {
    'Sandwiches': [
      {
        'nombre': 'Hamburguesa Simple',
        'precio': 10000,
      },
      {
        'nombre': 'Hamburguesa Mexicana',
        'precio': 8500,
      },
      {
        'nombre': 'Lomito Simple',
        'precio': 15000,
      },
      {
        'nombre': 'Lomito Completo',
        'precio': 17000,
      },
      {
        'nombre': 'Charly',
        'precio': 15000,
      },
      {
        'nombre': 'Suizo',
        'precio': 16000,
      },
    ],
    'Empanadas': [
      {
        'nombre': 'Carne',
        'precio': 3000,
      },
      {
        'nombre': 'Pollo',
        'precio': 3000,
      },
      {
        'nombre': 'Jamón y Queso',
        'precio': 3200,
      },
    ],
    'Pizzas': [
      {
        'nombre': 'Muzzarella',
        'precio': 8000,
      },
      {
        'nombre': 'Especial',
        'precio': 10000,
      },
      {
        'nombre': 'Napolitana',
        'precio': 9000,
      },
    ],
    'Bebidas': [
      {
        'nombre': 'Coca Cola',
        'precio': 3000,
      },
      {
        'nombre': 'Sprite',
        'precio': 2800,
      },
      {
        'nombre': 'Agua',
        'precio': 2000,
      },
    ],
  };

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

  List<String> get productos {
    if (categoria == null) {
      return [];
    }

    return productosPorCategoria[categoria]!
        .map((item) => item['nombre'] as String)
        .toList();
  }

  void agregarAlPedido() {
    if (mesa == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Seleccioná una mesa.'),
        ),
      );
      return;
    }

    if (categoria == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Seleccioná una categoría.'),
        ),
      );
      return;
    }

    if (producto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Seleccioná un producto.'),
        ),
      );
      return;
    }

    final productoEncontrado =
        productosPorCategoria[categoria]!.firstWhere(
      (item) => item['nombre'] == producto,
    );

    final precioUnitario =
        productoEncontrado['precio'] as int;

    final numeroMesa = int.parse(
      mesa!.replaceAll('Mesa ', ''),
    );

    pedidoManager.agregarProducto(
      mesa: numeroMesa,
      producto: producto!,
      categoria: categoria!,
      cantidad: cantidad,
      precioUnitario: precioUnitario,
      observacion: tipoPapa ?? '',
    );

    setState(() {
      producto = null;
      tipoPapa = null;
      cantidad = 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Producto agregado al pedido.'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void enviarPedido() {
    if (pedidoManager.pedido.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay productos en el pedido.'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmarPedidoScreen(
          mesa: mesa ?? '',
          pedido: pedidoManager.pedido,
        ),
      ),
    );
  }

  @override
  void dispose() {
    pedidoManager.removeListener(actualizarPantalla);
    super.dispose();
  }

  void actualizarPantalla() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    pedidoManager.addListener(actualizarPantalla);
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

                        child: Text(
                          'Carrito: ${pedidoManager.cantidadProductos}',
                          style: const TextStyle(
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
                                producto = null;
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
                            opciones: cantidades
                                .map((e) => e.toString())
                                .toList(),
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
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: columnaBotones(
                            categorias,
                            categoria,
                            (valor) {
                              setState(() {
                                categoria = valor;
                                producto = null;
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
                            cantidades
                                .map((e) => e.toString())
                                .toList(),
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

                    const SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,

                      child: ElevatedButton.icon(
                        onPressed: agregarAlPedido,

                        icon: const Icon(
                          Icons.add_shopping_cart,
                        ),

                        label: const Text(
                          'AGREGAR AL CARRITO',
                        ),

                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF062D55),

                          foregroundColor:
                              Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ==========================
                    // CARRITO
                    // ==========================

                    Container(
                      width: double.infinity,

                      padding: const EdgeInsets.all(12),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(10),
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [
                          const Text(
                            'MI PEDIDO',
                            style: TextStyle(
                              color: Color(0xFF062D55),
                              fontWeight:
                                  FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),

                          const SizedBox(height: 10),

                          if (pedidoManager.pedido.isEmpty)
                            const Padding(
                              padding:
                                  EdgeInsets.symmetric(
                                vertical: 20,
                              ),

                              child: Center(
                                child: Text(
                                  'El carrito está vacío.',
                                ),
                              ),
                            ),

                          ...pedidoManager.pedido
                              .asMap()
                              .entries
                              .map(
                            (entry) {
                              final index = entry.key;
                              final item = entry.value;

                              return Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),

                                decoration:
                                    const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color:
                                          Color(0xFFE9E9E9),
                                    ),
                                  ),
                                ),

                                child: Row(
                                  children: [
                                    Text(
                                      '${item['cantidad']} x',
                                      style:
                                          const TextStyle(
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(width: 10),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                        children: [
                                          Text(
                                            item['producto'],
                                            style:
                                                const TextStyle(
                                              fontWeight:
                                                  FontWeight.bold,
                                            ),
                                          ),

                                          if ((item['detalle']
                                                  as String)
                                              .isNotEmpty)
                                            Text(
                                              item['detalle'],
                                              style:
                                                  const TextStyle(
                                                fontSize: 11,
                                                color:
                                                    Colors.grey,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),

                                    Text(
                                      '\$${item['precio']}',
                                      style:
                                          const TextStyle(
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),

                                    IconButton(
                                      onPressed: () {
                                        pedidoManager
                                            .eliminarProducto(
                                          index,
                                        );
                                      },

                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 15),

                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,
                            children: [
                              const Text(
                                'TOTAL:',
                                style: TextStyle(
                                  color:
                                      Color(0xFF062D55),
                                  fontWeight:
                                      FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),

                              Text(
                                '\$ ${pedidoManager.total}',
                                style: const TextStyle(
                                  color:
                                      Color(0xFF062D55),
                                  fontWeight:
                                      FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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

              child: SizedBox(
                width: double.infinity,

                child: ElevatedButton.icon(
                  onPressed: enviarPedido,

                  icon: const Icon(
                    Icons.send,
                  ),

                  label: const Text(
                    'ENVIAR PEDIDO',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF062D55),

                    foregroundColor:
                        Colors.white,

                    minimumSize:
                        const Size(0, 45),

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                  ),
                ),
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

      padding: const EdgeInsets.symmetric(
        horizontal: 6,
      ),

      decoration: BoxDecoration(
        color: const Color(0xFF062D55),
        borderRadius: BorderRadius.circular(4),
      ),

      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: opciones.contains(valor)
              ? valor
              : null,

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

          dropdownColor:
              const Color(0xFF062D55),

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
        final bool activo =
            seleccionado == opcion;

        return Padding(
          padding:
              const EdgeInsets.only(
            bottom: 2,
          ),

          child: SizedBox(
            width: double.infinity,
            height: 29,

            child: ElevatedButton(
              onPressed: () {
                onChanged(opcion);
              },

              style:
                  ElevatedButton.styleFrom(
                backgroundColor: activo
                    ? const Color(0xFF174A75)
                    : const Color(0xFF062D55),

                foregroundColor:
                    Colors.white,

                padding: EdgeInsets.zero,

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(3),
                ),
              ),

              child: Text(
                opcion,
                textAlign:
                    TextAlign.center,
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