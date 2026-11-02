import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'categoria_sandwiches_screen.dart';
import 'categoria_empanadas_screen.dart';
import 'categoria_bebidas_screen.dart';
import 'detalle.dart';
import 'pedido_manager.dart';
import '../producto_service.dart';

class CategoriaPizzasScreen extends StatefulWidget {
  final int mesa;
  final int idMesa;

  const CategoriaPizzasScreen({
    super.key,
    required this.mesa,
    required this.idMesa,
  });

  @override
  State<CategoriaPizzasScreen> createState() =>
      _CategoriaPizzasScreenState();
}

class _CategoriaPizzasScreenState extends State<CategoriaPizzasScreen> {
  String productoSeleccionado = '';

  final Color azulOscuro = const Color(0xFF1E293B);
final Color azul = const Color(0xFF1E293B);
final Color fondo = const Color(0xFFF8F6F0);

  final PedidoManager pedidoManager = PedidoManager.instancia;

  // Productos que vienen de Laravel
  List<Map<String, dynamic>> productos = [];

  bool cargandoProductos = true;
  String errorProductos = '';

  @override
  void initState() {
    super.initState();

    pedidoManager.addListener(_actualizarPedido);

    cargarProductos();
  }

  void _actualizarPedido() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    pedidoManager.removeListener(_actualizarPedido);
    super.dispose();
  }

  // ============================================================
  // CARGAR PRODUCTOS DESDE LARAVEL
  // ============================================================

  Future<void> cargarProductos() async {
    try {
      final datos = await ProductoService.obtenerProductos();

      if (!mounted) return;

      setState(() {
        productos = datos;
        cargandoProductos = false;
        errorProductos = '';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        cargandoProductos = false;
        errorProductos = 'No se pudieron cargar los productos.';
      });
    }
  }

  // ============================================================
  // FORMATO DEL PRECIO
  // ============================================================

  String formatearPrecio(dynamic precio) {
    final numero = double.tryParse(precio.toString())?.round() ?? 0;

    final texto = numero.toString();
    final partes = <String>[];

    for (int i = texto.length; i > 0; i -= 3) {
      final inicio = i - 3 < 0 ? 0 : i - 3;
      partes.insert(0, texto.substring(inicio, i));
    }

    return '\$${partes.join('.')},00';
  }

  int convertirPrecio(String precio) {
    final limpio = precio
        .replaceAll('\$', '')
        .replaceAll('.', '')
        .replaceAll(',00', '')
        .trim();

    return int.tryParse(limpio) ?? 0;
  }

  
  // ============================================================
  // URL DE LA IMAGEN
  // ============================================================

  
  String obtenerUrlImagen(dynamic imagen) {
    if (imagen == null || imagen.toString().trim().isEmpty) {
      return '';
    }

    String ruta = imagen.toString().trim().replaceAll('\\', '/');

    if (ruta.startsWith('http://') || ruta.startsWith('https://')) {
      return ruta;
    }

    while (ruta.startsWith('/')) {
      ruta = ruta.substring(1);
    }

    if (ruta.startsWith('storage/')) {
      ruta = ruta.substring('storage/'.length);
    }

    if (!ruta.contains('/')) {
      ruta = 'productos/$ruta';
    }

    return 'http://127.0.0.1:8000/api/imagen-producto/$ruta';
  }


  // ============================================================
  // PRODUCTOS DE PIZZAS
  // ============================================================

  Widget productosPizzas() {
    final pizzas = productos.where((producto) {
      final categoriaData = producto['categoria'];

      String categoria = '';

      // Laravel devuelve:
      //
      // "categoria": {
      //   "id": 1,
      //   "categoria": "Pizzas"
      // }

      if (categoriaData is Map) {
        categoria = (categoriaData['categoria'] ?? '')
            .toString()
            .toLowerCase()
            .trim();
      } else {
        // Por compatibilidad, por si alguna vez viene como texto
        categoria = categoriaData
            .toString()
            .toLowerCase()
            .trim();
      }

      return categoria == 'pizzas';
    }).toList();

    if (pizzas.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Center(
          child: Text(
            'No hay pizzas disponibles',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF64748B),
            ),
          ),
        ),
      );
    }

    final List<Widget> filas = [];

    for (int i = 0; i < pizzas.length; i += 2) {
      final tarjeta1 = producto(
        nombre: pizzas[i]['nombre'].toString(),
        precio: formatearPrecio(pizzas[i]['precio']),
        imagen: pizzas[i]['imagen'],
      );

      Widget tarjeta2 = const SizedBox();

      if (i + 1 < pizzas.length) {
        tarjeta2 = producto(
          nombre: pizzas[i + 1]['nombre'].toString(),
          precio: formatearPrecio(pizzas[i + 1]['precio']),
          imagen: pizzas[i + 1]['imagen'],
        );
      }

      filas.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: tarjeta1),
            const SizedBox(width: 20),
            Expanded(child: tarjeta2),
          ],
        ),
      );

      if (i + 2 < pizzas.length) {
        filas.add(const SizedBox(height: 8));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        tituloSeccion('Pizzas'),
        ...filas,
      ],
    );
  }

  // ============================================================
  // PANEL PARA AGREGAR PRODUCTO
  // ============================================================

  void abrirPanelAgregarPedido({
    required String nombre,
    required String precio,
  }) {
    int cantidad = 1;

    final observacionController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(25),
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 45,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
  Icons.local_pizza,
  size: 60,
  color: Color(0xFF64748B),
),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      nombre,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      precio,
                      style: TextStyle(
                        fontSize: 19,
                        color: azulOscuro,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (cantidad > 1) {
                              setModalState(() {
                                cantidad--;
                              });
                            }
                          },
                          icon: const Icon(
                            Icons.remove_circle_outline,
                          ),
                          iconSize: 32,
                          color: azulOscuro,
                        ),

                        Text(
                          '$cantidad',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        IconButton(
                          onPressed: () {
                            setModalState(() {
                              cantidad++;
                            });
                          },
                          icon: const Icon(
                            Icons.add_circle_outline,
                          ),
                          iconSize: 32,
                          color: azulOscuro,
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: observacionController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'Observación',
                        hintText: 'Ej: sin cebolla...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD97706),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          pedidoManager.agregarProducto(
                            mesa: widget.mesa,
                            producto: nombre,
                            categoria: 'Pizzas',
                            cantidad: cantidad,
                            precioUnitario: convertirPrecio(precio),
                            observacion:
                                observacionController.text.trim(),
                          );

                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Agregar al pedido',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ============================================================
  // PANEL USUARIO
  // ============================================================

  void abrirPanelUsuario() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 35,
                  child: Icon(
                    Icons.person,
                    size: 40,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Usuario',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Cerrar sesión'),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 67,
              color: const Color(0xFF121A2B),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                  const Expanded(
                    child: Center(
                      child: Text(
                        'Pizzas',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  IconButton(
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetalleScreen(
                            mesa: widget.mesa,
                            idMesa: widget.idMesa,
                          ),
                        ),
                      );
                    },
                  ),

                  IconButton(
                    icon: const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    onPressed: abrirPanelUsuario,
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: categoriaBoton(
                            'Sandwiches',
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      CategoriaSandwichesScreen(
                                    mesa: widget.mesa,
                                    idMesa: widget.idMesa,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: categoriaBoton(
                            'Pizzas',
                            () {},
                            seleccionado: true,
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: categoriaBoton(
                            'Empanadas',
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      CategoriaEmpanadasScreen(
                                    mesa: widget.mesa,
                                    idMesa: widget.idMesa,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: categoriaBoton(
                            'Bebidas',
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      CategoriaBebidasScreen(
                                    mesa: widget.mesa,
                                    idMesa: widget.idMesa,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    if (cargandoProductos)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (errorProductos.isNotEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Text(
                            errorProductos,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      )
                    else
                      productosPizzas(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // BOTÃ“N DE CATEGORÃA
  // ============================================================

  Widget categoriaBoton(
    String texto,
    VoidCallback onTap, {
    bool seleccionado = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: seleccionado
    ? const Color(0xFFD97706)
    : azul,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            texto,
            style: TextStyle(
  color: seleccionado
      ? Colors.white
      : const Color(0xFFE2E8F0),
  fontSize: 13,
  fontWeight: FontWeight.bold,
),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // TÃTULO DE SECCIÃ“N
  // ============================================================

  Widget tituloSeccion(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        titulo,
        style: TextStyle(
          color: azulOscuro,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ============================================================
  // PRODUCTO
  // ============================================================

  Widget producto({
    required String nombre,
    required String precio,
    dynamic imagen,
  }) {
    final urlImagen = obtenerUrlImagen(imagen);
    debugPrint('IMAGEN: $imagen | URL: $urlImagen');

    return GestureDetector(
      onTap: () {
        setState(() {
          productoSeleccionado = nombre;
        });

        abrirPanelAgregarPedido(
          nombre: nombre,
          precio: precio,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 90,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: urlImagen.isNotEmpty
                  ? Image.network(
                      urlImagen,
                      fit: BoxFit.cover,
                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return const Icon(
                          Icons.image_not_supported,
                          size: 45,
                          color: Color(0xFF64748B),
                        );
                      },
                      loadingBuilder: (
                        context,
                        child,
                        loadingProgress,
                      ) {
                        if (loadingProgress == null) {
                          return child;
                        }

                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    )
                  : const Icon(
  Icons.local_pizza,
  size: 45,
  color: Color(0xFF64748B),
),
            ),

            const SizedBox(height: 10),

            Text(
              nombre,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF1E293B),
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              precio,
              style: TextStyle(
                color: const Color(0xFF64748B),
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
