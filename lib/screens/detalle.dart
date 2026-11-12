import 'package:flutter/material.dart';
import 'confirmar_pedido_screen.dart';
import 'pedido_manager.dart';
import 'categorias_screen.dart';
import 'login_screen.dart';
import '../mesa_service.dart';
import 'notificaciones_mozo.dart';

class DetalleScreen extends StatefulWidget {
  final int mesa;
  final int idMesa;

  const DetalleScreen({
    super.key,
    required this.mesa,
    required this.idMesa,
  });

  // MESAS QUE YA ENVIARON EL PEDIDO
  static final Set<int> mesasConPedidoEnviado = {};

  static void marcarPedidoEnviado(int mesa) {
    mesasConPedidoEnviado.add(mesa);
  }

  @override
  State<DetalleScreen> createState() => _DetalleScreenState();
}

class _DetalleScreenState extends State<DetalleScreen> {
  static const Color azulOscuro = Color(0xFF1E293B);
static const Color azul = Color(0xFF64748B);
static const Color fondo = Color(0xFFF8F6F0);
static const Color azulMuyClaro = Color(0xFFFFFFFF);
  final PedidoManager pedidoManager = PedidoManager.instancia;
  List<Map<String, dynamic>> pedidosServidor = [];
bool cargandoPedidos = true;
Future<void> cargarPedidosServidor() async {
  try {
    final pedidos =
        await MesaService.obtenerPedidosPendientes(widget.idMesa);

    if (!mounted) return;

    setState(() {
      pedidosServidor = pedidos;
      cargandoPedidos = false;
    });
  } catch (e) {
    if (!mounted) return;

    setState(() {
      cargandoPedidos = false;
    });

    debugPrint('Error al cargar pedidos pendientes: $e');
  }
}
  @override
  void initState() {
    super.initState();
    pedidoManager.addListener(actualizarPantalla);
    pedidoManager.registrarIdMesa(widget.mesa, widget.idMesa);
cargarPedidosServidor();
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
                            const Text(
                              'Fernando Palavecino',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF1E293B),
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Mozo',
                              style: TextStyle(
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
                            ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(
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

  // =====================================================
  // ¿EL PEDIDO DE ESTA MESA YA FUE ENVIADO?
  // =====================================================
  bool get pedidoFueEnviado {
    return DetalleScreen.mesasConPedidoEnviado.contains(
      widget.mesa,
    );
  }

  // =====================================================
  // TODOS LOS PRODUCTOS DE ESTA MESA
  // =====================================================
  List<Map<String, dynamic>> get pedidoMesa {
  final productosServidor = <Map<String, dynamic>>[];

  for (final pedido in pedidosServidor) {
    final detalles = pedido['detalles'] as List? ?? [];

    for (final detalle in detalles) {
      final cantidad = (detalle['cantidad'] as num?)?.toInt() ?? 0;
      final subtotal = (detalle['subtotal'] as num?)?.round() ??
          (((detalle['precio_unitario'] as num?) ?? 0) * cantidad)
              .round();

      productosServidor.add({
        'producto': detalle['nombre'] ?? 'Producto',
        'categoria': '',
        'detalle': detalle['descripcion'] ?? '',
        'cantidad': cantidad,
        'precio': subtotal,
        'enviado': true,
      });
    }
  }

  final productosLocales = pedidoManager.productosPendientesDeMesa(
    widget.mesa,
    idMesa: widget.idMesa,
  );

  return [...productosServidor, ...productosLocales];
}

  // =====================================================
  // PRODUCTOS PENDIENTES DE ENVIAR A COCINA
  // =====================================================
  List<Map<String, dynamic>> get pedidoPendienteMesa {
  return pedidoManager.productosPendientesDeMesa(
    widget.mesa,
    idMesa: widget.idMesa,
  );
}

  bool get tienePendientes {
    return pedidoPendienteMesa.isNotEmpty;
  }

  // =====================================================
  // ¿HAY PRODUCTOS PARA ESTA MESA?
  // =====================================================
  bool get tieneProductos {
    return pedidoMesa.isNotEmpty;
  }

  // =====================================================
  // ABRIR CONFIRMACIÓN DEL PEDIDO
  // ENVÍA SOLAMENTE LOS PRODUCTOS NUEVOS
  // =====================================================
  void confirmarYEnviarPedido() {
    final productosPendientes = pedidoPendienteMesa;

    if (productosPendientes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay productos nuevos para enviar.'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmarPedidoScreen(
          mesa: 'MESA ${widget.mesa}',
            idMesa: widget.idMesa,
          pedido: List<Map<String, dynamic>>.from(
            productosPendientes,
          ),
        ),
      ),
    );
  }

  int get totalMesa {
  return pedidoMesa.fold<int>(
    0,
    (total, producto) =>
        total + ((producto['precio'] as num?)?.round() ?? 0),
  );
}

  int get cantidadMesa {
  return pedidoMesa.fold<int>(
    0,
    (total, producto) =>
        total + ((producto['cantidad'] as num?)?.toInt() ?? 0),
  );
}
  String formatoPrecio(int precio) {
    return '\$${precio.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match.group(1)}.',
        )},00';
  }

  IconData iconoCategoria(String categoria) {
    switch (categoria) {
      case 'Sandwiches':
        return Icons.lunch_dining;
      case 'Pizzas':
        return Icons.local_pizza;
      case 'Empanadas':
        return Icons.bakery_dining;
      case 'Bebidas':
        return Icons.local_drink;
      default:
        return Icons.restaurant;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      body: SafeArea(
        child: Column(
          children: [
            // =====================================================
            // BARRA SUPERIOR
            // =====================================================
            Container(
              height: 62,
              color: const Color(0xFF121A2B),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      abrirPanelUsuario(context);
                    },
                    icon: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Detalle del pedido',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Mesa ${widget.mesa}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
  onPressed: () => mostrarNotificacionesMozo(context),
  icon: const Icon(
    Icons.notifications,
    color: Colors.white,
    size: 27,
  ),
),
                ],
              ),
            ),

            // =====================================================
            // CONTENIDO
            // =====================================================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
                child: Column(
                  children: [
                    // INFORMACIÓN DE LA MESA
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: azulMuyClaro,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              color: azulOscuro,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.table_restaurant,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Mesa ${widget.mesa}',
                            style: const TextStyle(
                              color: azulOscuro,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ENCABEZADO RESUMEN
                    Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: const BoxDecoration(
                            color: azulOscuro,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.receipt_long,
                            color: Colors.white,
                            size: 21,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Resumen del pedido',
                                style: TextStyle(
                                  color: azulOscuro,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Productos agregados',
                                style: TextStyle(
                                  color: azul,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD97706),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '$cantidadMesa productos',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // SIN PRODUCTOS
                    if (!tieneProductos)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 35),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.shopping_cart_outlined,
                              color: Color(0xFF1E293B),
                              size: 50,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'No hay productos para esta mesa.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Agregá productos para comenzar el pedido.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // PRODUCTOS DE LA MESA
                    if (tieneProductos)
                      ...pedidoMesa.map((item) {
                        final categoria =
                            item['categoria'] as String? ?? '';

                        final detalle =
                            item['detalle'] as String? ?? '';

                        final enviado = item['enviado'] == true;

                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 7),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: const BoxDecoration(
                                    color: Color(0xFFE2E8F0),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  iconoCategoria(categoria),
                                  color: azulOscuro,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['producto'],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: azulOscuro,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      'Cantidad: ${item['cantidad']}',
                                      style: const TextStyle(
                                        color: azul,
                                        fontSize: 10,
                                      ),
                                    ),
                                    if (detalle.isNotEmpty) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        detalle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: azul,
                                          fontSize: 9,
                                        ),
                                      ),
                                    ],
                                    if (enviado) ...[
                                      const SizedBox(height: 3),
                                      const Text(
                                        'Ya enviado a cocina',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                formatoPrecio(item['precio'] as int),
                                style: const TextStyle(
                                  color: azulOscuro,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                    const SizedBox(height: 4),

                    // CONFIRMAR Y ENVIAR SOLAMENTE LOS PENDIENTES
                    if (tienePendientes)
                      GestureDetector(
                        onTap: confirmarYEnviarPedido,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 13,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD97706),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Confirmar y enviar pedido',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Revisar los productos nuevos antes de enviarlos',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 9,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right,
                                color: Colors.white,
                                size: 27,
                              ),
                            ],
                          ),
                        ),
                      ),

                    // PEDIDO ENVIADO, SIN PRODUCTOS PENDIENTES
                    if (pedidoFueEnviado &&
                        tieneProductos &&
                        !tienePendientes)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFFA5D6A7),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 24,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Pedido enviado correctamente.',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 12),

                    // AGREGAR MÁS PRODUCTOS
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoriasScreen(
                              mesa: widget.mesa,
                                idMesa: widget.idMesa,
                              
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: const Color(0xFFE2E8F0),
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                  color: Color(0xFF64748B),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 21,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Agregar más productos',
                                    style: TextStyle(
                                      color: azulOscuro,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Volver a las categorías',
                                    style: TextStyle(
                                      color: azul,
                                      fontSize: 9,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right,
                              color: azulOscuro,
                              size: 26,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // TOTAL DE TODOS LOS PRODUCTOS DE LA MESA
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 13,
                      ),
                      decoration: BoxDecoration(
                        color: azulMuyClaro,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total del pedido',
                                  style: TextStyle(
                                    color: azulOscuro,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  'Productos agregados',
                                  style: TextStyle(
                                    color: azul,
                                    fontSize: 9,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            formatoPrecio(totalMesa),
                            style: const TextStyle(
                              color: Color(0xFFD97706),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
}
