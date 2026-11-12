import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'pedido_enviado_screen.dart';
import 'pedido_manager.dart';
import 'detalle.dart';
import '../producto_service.dart';
import '../usuario_sesion.dart';

class ConfirmarPedidoScreen extends StatefulWidget {
  final String mesa;
  final int idMesa;
  final List<Map<String, dynamic>> pedido;

  const ConfirmarPedidoScreen({
    super.key,
    required this.mesa,
     required this.idMesa,
    required this.pedido,
  });

  @override
  State<ConfirmarPedidoScreen> createState() =>
      _ConfirmarPedidoScreenState();
}

class _ConfirmarPedidoScreenState
    extends State<ConfirmarPedidoScreen> {
  late List<Map<String, dynamic>> pedido;

  final PedidoManager pedidoManager = PedidoManager.instancia;

  bool enviandoPedido = false;

  static const Color azulOscuro = Color(0xFF1E293B);
static const Color azulBoton = Color(0xFFE2E8F0);

  @override
  void initState() {
    super.initState();
    pedido = List<Map<String, dynamic>>.from(widget.pedido);
  }

  int calcularTotal() {
    int total = 0;

    for (final item in pedido) {
      total += (item['precio'] as num).round();
    }

    return total;
  }

  // ----------------------------------------------------------
  // ELIMINAR PRODUCTO
  // ----------------------------------------------------------

  void eliminarProducto(int index) {
    if (index < 0 || index >= pedido.length) return;

    final item = pedido[index];

    setState(() {
      pedido.removeAt(index);
    });

    pedidoManager.eliminarProductoItem(item);
  }

  // ----------------------------------------------------------
  // EDITAR PRODUCTO CON DATOS DE LARAVEL
  // ----------------------------------------------------------

  Future<void> editarProducto(
    int index,
    Map<String, dynamic> item,
  ) async {
    if (index < 0 || index >= pedido.length) return;

    String productoSeleccionado =
        (item['producto'] ?? '').toString();

    int cantidad =
        int.tryParse(item['cantidad'].toString()) ?? 1;

    String observacion =
        (item['detalle'] ?? '').toString();

    final categoriaActual =
        (item['categoria'] ?? '').toString().trim();

    final int precioAnterior = _aEntero(
      item['precioUnitario'] ?? item['precio'] ?? 0,
    );

    Map<String, int> productosCategoria = {};

    try {
      // Obtener el catálogo actual desde Laravel.
      final productosBD =
          await ProductoService.obtenerProductos();

      String normalizar(String valor) {
        return valor
            .toLowerCase()
            .trim()
            .replaceAll('á', 'a')
            .replaceAll('é', 'e')
            .replaceAll('í', 'i')
            .replaceAll('ó', 'o')
            .replaceAll('ú', 'u');
      }

      String obtenerCategoria(dynamic dato) {
        if (dato is Map) {
          return (
            dato['categoria'] ??
            dato['nombre'] ??
            dato['name'] ??
            ''
          ).toString().trim();
        }

        return (dato ?? '').toString().trim();
      }

      final categoriaBuscada =
          normalizar(categoriaActual);

      for (final productoBD in productosBD) {
        final nombre = (
          productoBD['nombre'] ??
          productoBD['producto'] ??
          ''
        ).toString().trim();

        if (nombre.isEmpty) continue;

        final categoriaBD = normalizar(
          obtenerCategoria(productoBD['categoria']),
        );

        bool mismaCategoria =
            categoriaBD == categoriaBuscada;

        // Algunas bebidas pueden estar separadas
        // en categorías como Gaseosas o Cervezas.
        if (categoriaBuscada == 'bebidas') {
          mismaCategoria = const {
            'bebidas',
            'gaseosas',
            'cervezas',
            'aguas saborizadas',
            'aguas',
          }.contains(categoriaBD);
        }

        if (!mismaCategoria) continue;

        final precio = _aEntero(
          productoBD['precio'] ?? 0,
        );

        productosCategoria[nombre] = precio;
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se pudieron cargar los productos desde Laravel. '
            'Verificá que el servidor esté funcionando.',
          ),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    // Mantener el producto actual si no aparece en
    // la respuesta de Laravel, para no perder el pedido.
    productosCategoria.putIfAbsent(
      productoSeleccionado,
      () => precioAnterior,
    );

    if (productosCategoria.isEmpty) {
      productosCategoria[productoSeleccionado] =
          precioAnterior;
    }

    final observacionController =
        TextEditingController(text: observacion);

    if (!mounted) {
      observacionController.dispose();
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final precioActual =
                productosCategoria[productoSeleccionado] ??
                precioAnterior;

            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: const Row(
                children: [
                  Icon(
                    Icons.edit,
                    color: azulOscuro,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Modificar producto',
                    style: TextStyle(
                      color: azulOscuro,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PRODUCTO',
                      style: TextStyle(
                        color: azulOscuro,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 7),
                    DropdownButtonFormField<String>(
                      value: productosCategoria
                              .containsKey(productoSeleccionado)
                          ? productoSeleccionado
                          : productosCategoria.keys.first,
                      isExpanded: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: azulOscuro,
                            width: 2,
                          ),
                        ),
                      ),
                      items: productosCategoria.keys.map(
                        (producto) {
                          return DropdownMenuItem<String>(
                            value: producto,
                            child: Text(
                              producto,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        },
                      ).toList(),
                      onChanged: (valor) {
                        if (valor == null) return;

                        setDialogState(() {
                          productoSeleccionado = valor;
                        });
                      },
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'PRECIO UNITARIO: \$ $precioActual',
                      style: const TextStyle(
                        color: Color(0xFF10B981),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'CANTIDAD',
                      style: TextStyle(
                        color: azulOscuro,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: azulBoton,
                        ),
                        borderRadius:
                            BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: IconButton(
                              onPressed: cantidad > 1
                                  ? () {
                                      setDialogState(() {
                                        cantidad--;
                                      });
                                    }
                                  : null,
                              icon: const Icon(
                                Icons.remove,
                                color: azulOscuro,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                '$cantidad',
                                style: const TextStyle(
                                  color: azulOscuro,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                              onPressed: () {
                                setDialogState(() {
                                  cantidad++;
                                });
                              },
                              icon: const Icon(
                                Icons.add,
                                color: azulOscuro,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'DETALLE / OBSERVACIÓN',
                      style: TextStyle(
                        color: azulOscuro,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 7),
                    TextField(
                      controller: observacionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText:
                            'Ej: Sin cebolla, sin tomate...',
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: azulOscuro,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text(
                    'CANCELAR',
                    style: TextStyle(
                      color: azulOscuro,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final nuevoPrecio =
                        productosCategoria[
                            productoSeleccionado] ??
                        precioActual;

                    final nuevaObservacion =
                        observacionController.text.trim();

                    pedidoManager.actualizarProducto(
                      item: item,
                      producto: productoSeleccionado,
                      cantidad: cantidad,
                      precioUnitario: nuevoPrecio,
                      observacion: nuevaObservacion,
                    );

                    setState(() {
                      pedido[index]['producto'] =
                          productoSeleccionado;

                      pedido[index]['cantidad'] =
                          cantidad;

                      pedido[index]['precioUnitario'] =
                          nuevoPrecio;

                      pedido[index]['precio'] =
                          nuevoPrecio * cantidad;

                      pedido[index]['detalle'] =
                          nuevaObservacion;
                    });

                    Navigator.pop(dialogContext);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD97706),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'GUARDAR',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    ).whenComplete(() {
      observacionController.dispose();
    });
  }

  // ----------------------------------------------------------
  // CONVERTIR PRECIO A ENTERO
  // ----------------------------------------------------------

  int _aEntero(dynamic valor) {
    if (valor is num) return valor.round();

    final texto = valor.toString().trim();

    final sinMoneda = texto
        .replaceAll(r'$', '')
        .replaceAll(' ', '');

    final sinSeparadorMiles =
        sinMoneda.replaceAll('.', '');

    final normalizado =
        sinSeparadorMiles.replaceAll(',', '.');

    return double.tryParse(normalizado)?.round() ?? 0;
  }

  // ----------------------------------------------------------
  // ENVIAR PEDIDO A LARAVEL
  // ----------------------------------------------------------

  Future<void> enviarPedido() async {
    if (pedido.isEmpty || enviandoPedido) return;

    setState(() {
      enviandoPedido = true;
    });

    try {
      final respuesta = await http
          .post(
            Uri.parse(
              'http://127.0.0.1:8000/api/cocina/pedidos',
            ),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'mesa': widget.mesa,
              'id_mesa': widget.idMesa,
              'usuario_id': UsuarioSesion.id,
  'nombre_creador': UsuarioSesion.nombre,
  'rol_creador': UsuarioSesion.rol,
              'items': pedido.map((item) {
                return {
                  'producto': item['producto'],
                  'cantidad': item['cantidad'],
                  'precio': item['precio'],
                  'descripcion': item['detalle'] ?? '',
                };
              }).toList(),
            }),
          )
          .timeout(const Duration(seconds: 15));

      dynamic resultado;

      try {
        resultado = jsonDecode(respuesta.body);
      } catch (_) {
        resultado = <String, dynamic>{};
      }

      if (respuesta.statusCode != 201) {
        String mensaje =
            'Laravel no pudo guardar el pedido.';

        if (resultado is Map) {
          mensaje = (
            resultado['mensaje'] ??
            resultado['message'] ??
            mensaje
          ).toString();

          if (resultado['errors'] is Map) {
            final errores = resultado['errors'] as Map;

            final mensajes = errores.values
                .expand(
                  (valor) =>
                      valor is List ? valor : [valor],
                )
                .map((valor) => valor.toString())
                .join('\n');

            if (mensajes.isNotEmpty) {
              mensaje = mensajes;
            }
          }
        }

        throw Exception(mensaje);
      }

      if (!mounted) return;

      final numeroMesa = int.tryParse(
        widget.mesa.replaceAll(
          RegExp(r'[^0-9]'),
          '',
        ),
      );

      // NUEVO: marcar como enviados solamente los productos
      // incluidos en este envío que Laravel aceptó.
      pedidoManager.marcarProductosEnviados(pedido);

      if (numeroMesa != null) {
        DetalleScreen.marcarPedidoEnviado(numeroMesa);
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PedidoEnviadoScreen(
            mesa: widget.mesa,
            producto: 'Pedido completo',
            cantidad: pedido.length,
            observacion: '',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      final mensaje =
          e.toString().startsWith('Exception: ')
              ? e.toString().substring(
                  'Exception: '.length,
                )
              : e.toString();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No se pudo enviar el pedido: $mensaje',
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 6),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          enviandoPedido = false;
        });
      }
    }
  }

  // ----------------------------------------------------------
  // BUILD
  // ----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121A2B),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Confirmar Pedido',
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
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'MESA:',
                      style: TextStyle(
                        color: azulOscuro,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: azulOscuro,
                        borderRadius:
                            BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.mesa.isEmpty
                            ? 'Sin mesa'
                            : widget.mesa,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'PEDIDO:',
                      style: TextStyle(
                        color: azulOscuro,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (pedido.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: Text(
                            'No hay productos en el pedido',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    else
                      ...pedido.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;

                        return _producto(index, item);
                      }),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'TOTAL:',
                          style: TextStyle(
                            color: azulOscuro,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$ ${calcularTotal()}',
                          style: const TextStyle(
                            color: azulOscuro,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: enviandoPedido
                          ? null
                          : () {
                              Navigator.pop(context);
                            },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 45),
                        side: const BorderSide(
                          color: azulOscuro,
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'CANCELAR',
                        style: TextStyle(
                          color: azulOscuro,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          pedido.isEmpty || enviandoPedido
                              ? null
                              : enviarPedido,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD97706),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        enviandoPedido
                            ? 'ENVIANDO...'
                            : 'ENVIAR',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
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

  // ----------------------------------------------------------
  // TARJETA DEL PRODUCTO
  // ----------------------------------------------------------

  Widget _producto(
    int index,
    Map<String, dynamic> item,
  ) {
    final detalle =
        (item['detalle'] ?? '').toString();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10),
  border: Border.all(
    color: const Color(0xFFE2E8F0),
    width: 1,
  ),
),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F6F0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              item['cantidad'].toString(),
              style: const TextStyle(
                color: Color(0xFF1E293B),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            '×',
            style: TextStyle(
              color: Color(0xFF1E293B),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  item['producto'].toString(),
                  style: const TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  detalle.isEmpty
                      ? 'Sin observaciones'
                      : detalle,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Modificar',
            onPressed: enviandoPedido
                ? null
                : () {
                    editarProducto(index, item);
                  },
            icon: const Icon(
              Icons.edit,
               color: Color(0xFF64748B),
            ),
          ),
          IconButton(
            tooltip: 'Eliminar',
            onPressed: enviandoPedido
                ? null
                : () {
                    eliminarProducto(index);
                  },
            icon: const Icon(
              Icons.delete,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}