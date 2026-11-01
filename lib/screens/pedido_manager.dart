
import 'package:flutter/material.dart';

class PedidoManager extends ChangeNotifier {
  PedidoManager._();

  static final PedidoManager instancia = PedidoManager._();

  final List<Map<String, dynamic>> _pedido = [];
  int _siguienteId = 1;
  final Map<int, int> _idMesaPorNumero = {};
  void registrarIdMesa(int mesa, int idMesa) {
  _idMesaPorNumero[mesa] = idMesa;
}

  List<Map<String, dynamic>> get pedido =>
      List.unmodifiable(_pedido);

  List<Map<String, dynamic>> pedidoDeMesa(int mesa) {
    return _pedido
        .where((producto) => producto['mesa'] == mesa)
        .toList();
  }

  // Productos que todavía no se enviaron a la cocina.
  List<Map<String, dynamic>> productosPendientesDeMesa(
  int mesa, {
  int? idMesa,
}) {
  return _pedido.where((producto) {
    final pertenece = idMesa != null
        ? producto['idMesa'] == idMesa
        : producto['mesa'] == mesa;

    return pertenece && producto['enviado'] != true;
  }).toList();
}

  int get cantidadProductos {
    int total = 0;

    for (final producto in _pedido) {
      total += producto['cantidad'] as int;
    }

    return total;
  }

  int get total {
    int resultado = 0;

    for (final producto in _pedido) {
      resultado += producto['precio'] as int;
    }

    return resultado;
  }

  void agregarProducto({
    required int mesa,
    required String producto,
    required String categoria,
    required int cantidad,
    required int precioUnitario,
    String observacion = '',
  }) {
    _pedido.add({
      'idLocal': _siguienteId++,
      'mesa': mesa,
      'producto': producto,
      'idMesa': _idMesaPorNumero[mesa],
      'categoria': categoria,
      'cantidad': cantidad,
      'precio': precioUnitario * cantidad,
      'precioUnitario': precioUnitario,
      'detalle': observacion,
      'enviado': false,
    });

    notifyListeners();
  }

  // Marca como enviados solamente los productos confirmados.
  void marcarProductosEnviados(
    List<Map<String, dynamic>> productos,
  ) {
    final ids = productos
        .map((producto) => producto['idLocal'])
        .where((id) => id != null)
        .toSet();

    if (ids.isEmpty) return;

    for (final producto in _pedido) {
      if (ids.contains(producto['idLocal'])) {
        producto['enviado'] = true;
      }
    }

    notifyListeners();
  }

  // ELIMINAR UN PRODUCTO ESPECÍFICO
  void eliminarProductoItem(Map<String, dynamic> item) {
    final indice = _pedido.indexWhere(
      (producto) => identical(producto, item),
    );

    if (indice == -1) return;

    _pedido.removeAt(indice);
    notifyListeners();
  }

  // ACTUALIZAR UN PRODUCTO ESPECÍFICO
  void actualizarProducto({
    required Map<String, dynamic> item,
    required String producto,
    required int cantidad,
    required int precioUnitario,
    required String observacion,
  }) {
    final indice = _pedido.indexWhere(
      (productoGuardado) => identical(productoGuardado, item),
    );

    if (indice == -1) return;

    _pedido[indice]['producto'] = producto;
    _pedido[indice]['cantidad'] = cantidad;
    _pedido[indice]['precioUnitario'] = precioUnitario;
    _pedido[indice]['precio'] = precioUnitario * cantidad;
    _pedido[indice]['detalle'] = observacion;

    notifyListeners();
  }

  // ESTE MÉTODO SE MANTIENE POR COMPATIBILIDAD
  void eliminarProducto(int index) {
    if (index < 0 || index >= _pedido.length) return;

    _pedido.removeAt(index);
    notifyListeners();
  }

  void eliminarProductoDeMesa(int mesa, int index) {
    final productosDeMesa = _pedido
        .asMap()
        .entries
        .where((entry) => entry.value['mesa'] == mesa)
        .toList();

    if (index < 0 || index >= productosDeMesa.length) return;

    final indiceReal = productosDeMesa[index].key;

    _pedido.removeAt(indiceReal);
    notifyListeners();
  }

  void limpiarPedido() {
    _pedido.clear();
    notifyListeners();
  }
}
