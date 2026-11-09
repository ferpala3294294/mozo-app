import 'package:flutter/material.dart';
import 'dart:async';
import 'detalle.dart';
import 'login_screen.dart';
import 'pedido_manager.dart';
import '../mesa_service.dart';
import 'notificaciones_mozo.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  static const Color azulFondo = Color(0xFF121A2B);
static const Color azulTarjeta = Color(0xFFFFFFFF);
static const Color azulTarjetaOcupada = Color(0xFF78A8C5);
static const Color azulOscuro = Color(0xFF1E293B);
static const Color fondo = Color(0xFFF8F6F0);

  final PedidoManager pedidoManager = PedidoManager.instancia;

    final List<bool> mesasOcupadas = [
    false, false, true, false, true,
    false, false, true, false, false,
  ];

  List<Map<String, dynamic>> mesasServidor = [];
  List<Map<String, dynamic>> seccionesServidor = [];
  bool cargandoMesas = true;
  String? errorMesas;

  String filtroSeleccionado = 'Todas';

  // Notificaciones locales de Mozo.
  // La cocina todavía no envía una señal que permita crear
  // automáticamente avisos de pedidos listos.
  Timer? temporizadorNotificaciones;

final Set<int> pedidosListosNotificados = {};

bool consultaInicialRealizada = false;
bool consultandoPedidos = false;

  @override
void initState() {
  super.initState();

  pedidoManager.addListener(actualizarPantalla);
  cargarMesas();

  temporizadorNotificaciones = Timer.periodic(
    const Duration(seconds: 5),
    (timer) {
      revisarPedidosListos();
    },
  );

  revisarPedidosListos();
}
  @override
void dispose() {
  temporizadorNotificaciones?.cancel();
  pedidoManager.removeListener(actualizarPantalla);
  super.dispose();
}

  void actualizarPantalla() {
    if (mounted) {
      setState(() {});
    }
  }

Future<void> cargarMesas() async {
  if (!mounted) return;

  setState(() {
    cargandoMesas = true;
    errorMesas = null;
  });

  try {
    final resultadoMesas = await MesaService.obtenerMesas();

    List<Map<String, dynamic>> resultadoSecciones =
        seccionesServidor;

    try {
      resultadoSecciones = await MesaService.obtenerSecciones();
    } catch (e) {
      debugPrint('Error al cargar secciones: $e');
    }

    if (!mounted) return;

    setState(() {
      mesasServidor = resultadoMesas;
      seccionesServidor = resultadoSecciones;

      if (filtroSeleccionado != 'Todas' &&
          !seccionesServidor.any(
            (s) => s['seccion'].toString().toLowerCase() ==
                filtroSeleccionado.toLowerCase(),
          )) {
        filtroSeleccionado = 'Todas';
      }

      cargandoMesas = false;
    });
  } catch (e) {
    if (!mounted) return;

    setState(() {
      errorMesas = e.toString();
      cargandoMesas = false;
    });
  }
}

  List<Map<String, dynamic>> get mesasFiltradas {
  if (filtroSeleccionado == 'Todas') {
    return mesasServidor;
  }

  return mesasServidor.where((mesa) {
    final seccion = (mesa['seccion'] ?? '')
        .toString()
        .trim()
        .toLowerCase();

    return seccion == filtroSeleccionado.toLowerCase();
  }).toList();
}
int totalMesa(Map<String, dynamic> mesa) {
  final numero = int.parse(mesa['numero_mesa'].toString());
  final idMesa = int.parse(mesa['id_mesa'].toString());

  // Importe que viene de la base de datos.
  final montoServidor =
      (mesa['monto_pendiente'] as num?)?.round() ?? 0;

  // Productos locales que todavía no fueron enviados.
  final productosLocales =
      pedidoManager.productosPendientesDeMesa(
    numero,
    idMesa: idMesa,
  );

  final totalLocal = productosLocales.fold<int>(0, (total, producto) {
    final precio = producto['precio'];
    return total + (precio is num ? precio.round() : 0);
  });

  return montoServidor + totalLocal;
}
  String formatoPrecio(int precio) {
    final numero = precio.toString();
    final resultado = StringBuffer();

    for (int i = 0; i < numero.length; i++) {
      resultado.write(numero[i]);

      final restantes = numero.length - i - 1;
      if (restantes > 0 && restantes % 3 == 0) {
        resultado.write('.');
      }
    }

    return '\$$resultado,00';
  }

  void abrirNotificaciones() {
  mostrarNotificacionesMozo(context);
}
  void agregarNotificacionLocal(String mensaje) {
  NotificacionesMozo.instancia.agregarTodas([mensaje]);
  setState(() {});
}
  Future<void> revisarPedidosListos() async {
  if (!mounted || consultandoPedidos) return;

  consultandoPedidos = true;

  try {
    final pedidos = await MesaService.obtenerPedidosCocina();

    if (!mounted) return;

    // La primera consulta registra los pedidos que ya estaban listos.
    if (!consultaInicialRealizada) {
      for (final pedido in pedidos) {
        final estado = int.tryParse(
          pedido['fk_id_estado'].toString(),
        );

        final idPedido = int.tryParse(
          pedido['id_pedido'].toString(),
        );

        if (estado == 3 && idPedido != null) {
          pedidosListosNotificados.add(idPedido);
        }
      }

      consultaInicialRealizada = true;
      return;
    }

    final nuevosAvisos = <String>[];

    for (final pedido in pedidos) {
      final estado = int.tryParse(
        pedido['fk_id_estado'].toString(),
      );

      final idPedido = int.tryParse(
        pedido['id_pedido'].toString(),
      );

      if (estado == 3 &&
          idPedido != null &&
          !pedidosListosNotificados.contains(idPedido)) {
        pedidosListosNotificados.add(idPedido);

        final numeroMesa =
            pedido['numero_mesa']?.toString() ?? 'sin número';

        nuevosAvisos.add(
          'El pedido de la Mesa $numeroMesa está listo.',
        );
      }
    }

    if (nuevosAvisos.isNotEmpty && mounted) {
  NotificacionesMozo.instancia.agregarTodas(nuevosAvisos);
  setState(() {});
}
  } catch (e) {
    debugPrint('Error al revisar pedidos listos: $e');
  } finally {
    consultandoPedidos = false;
  }
}

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
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(
                                  Icons.close,
                                  color: azulOscuro,
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
                                color: fondo,
                                border: Border.all(
                                  color: azulOscuro,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 85,
                                color: azulOscuro,
                              ),
                            ),
                            const SizedBox(height: 25),
                            const Text(
                              'Admin',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: azulOscuro,
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
                                    builder: (_) => const LoginScreen(),
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
  Color? colorEstadoPedido(Map<String, dynamic> mesa) {
  final estado = (mesa['estado'] ?? '')
      .toString()
      .trim()
      .toLowerCase();

  switch (estado) {
    case 'recibido':
      return const Color(0xFF2585D8);

    case 'preparando':
    case 'en preparación':
    case 'en preparacion':
      return const Color(0xFFF28C28);

    case 'listo':
      return const Color(0xFF22A565);

    default:
      return null;
  }
}
Widget tarjetaMesa(Map<String, dynamic> mesa) {
  final numero = int.parse(mesa['numero_mesa'].toString());
  final seccion = (mesa['seccion'] ?? 'Sin sección').toString();

  final ocupada = numero > 0 &&
      numero <= mesasOcupadas.length &&
      mesasOcupadas[numero - 1];

  final total = totalMesa(mesa);
final colorEstado =
    total > 0 ? colorEstadoPedido(mesa) : null;

  return GestureDetector(
    onTap: () async {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => 
          DetalleScreen(
  mesa: numero,
  idMesa: int.parse(mesa['id_mesa'].toString()),
)
        ),
      );

      // Actualiza el estado cuando volvemos del detalle.
      cargarMesas();
    },
    child: Container(
      decoration: BoxDecoration(
        color: ocupada ? azulTarjetaOcupada : azulTarjeta,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
  Icons.table_restaurant,
  color: Color(0xFF64748B),
  size: 38,
),
          const SizedBox(height: 8),

          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Mesa $numero',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),

              if (colorEstado != null) ...[
                const SizedBox(width: 7),
                Container(
                  width: 11,
                  height: 11,
                  decoration: BoxDecoration(
                    color: colorEstado,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 5),
          Text(
            seccion,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF64748B), 
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            formatoPrecio(total),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF1E293B), 
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget botonFiltro(String nombre) {
    final seleccionado = filtroSeleccionado == nombre;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(nombre),
        selected: seleccionado,
        onSelected: (_) {
          setState(() {
            filtroSeleccionado = nombre;
          });
        },
        selectedColor: const Color(0xFFD97706),
        backgroundColor: const Color(0xFFFFFFFF),
        labelStyle: TextStyle(
  color: seleccionado
      ? Colors.white
      : const Color(0xFF1E293B),
  fontWeight: FontWeight.w600,
),
        side: BorderSide(
  color: seleccionado
      ? const Color(0xFFD97706)
      : const Color(0xFFE2E8F0),
),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mesas = mesasFiltradas;

    return Scaffold(
      backgroundColor: fondo,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 62,
              color: fondo,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Sandwichería Gabriel',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: azulOscuro,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
  tooltip: 'Actualizar mesas',
  onPressed: cargarMesas,
  icon: const Icon(
    Icons.refresh,
    color: azulOscuro,
  ),
),
                  IconButton(
                    tooltip: 'Notificaciones',
                    onPressed: abrirNotificaciones,
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(
                          Icons.notifications_none,
                          color: azulOscuro,
                          size: 28,
                        ),
                         if (NotificacionesMozo.instancia.tieneNotificaciones)
                          Positioned(
                            right: -2,
                            top: -2,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Color(0xFFD97706),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 6),
                    width: 39,
                    height: 39,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: azulOscuro,
                      border: Border.all(
                        color: azulOscuro,
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => abrirPanelUsuario(context),
                      icon: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              color: azulFondo,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              child: const Text(
                'Mesas',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
  botonFiltro('Todas'),

  ...seccionesServidor.map((seccion) {
    return botonFiltro(
      seccion['seccion'].toString(),
    );
  }).toList(),
],
                ),
              ),
            ),
            Expanded(
  child: cargandoMesas
      ? const Center(child: CircularProgressIndicator())
      : errorMesas != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'No se pudieron cargar las mesas.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: cargarMesas,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            )
          : mesas.isEmpty
              ? const Center(
                  child: Text('No hay mesas para esta ubicación.'),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final columnas =
                        constraints.maxWidth < 600 ? 2 : 5;

                    return RefreshIndicator(
                      onRefresh: cargarMesas,
                      child: GridView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: mesas.length,
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columnas,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio:
                              constraints.maxWidth < 600 ? 1.05 : 1.0,
                        ),
                                                itemBuilder: (context, index) {
                          return tarjetaMesa(mesas[index]);
                        },
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
}