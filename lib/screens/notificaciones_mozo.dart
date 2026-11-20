import 'package:flutter/material.dart';

class NotificacionesMozo extends ChangeNotifier {
  NotificacionesMozo._();

  static final NotificacionesMozo instancia =
      NotificacionesMozo._();

  final List<String> _notificaciones = [];

  List<String> get notificaciones =>
      List.unmodifiable(_notificaciones);

  bool get tieneNotificaciones => _notificaciones.isNotEmpty;

  void agregarTodas(List<String> avisos) {
    if (avisos.isEmpty) return;

    _notificaciones.insertAll(0, avisos);
    notifyListeners();
  }

  void eliminar(int index) {
    if (index < 0 || index >= _notificaciones.length) return;

    _notificaciones.removeAt(index);
    notifyListeners();
  }

  void limpiar() {
    _notificaciones.clear();
    notifyListeners();
  }
}


Future<void> mostrarNotificacionesMozo(BuildContext context) {
  final servicio = NotificacionesMozo.instancia;

  const azulOscuro = Color(0xFF172438);
  const naranja = Color(0xFFD97706);

  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AnimatedBuilder(
        animation: servicio,
        builder: (context, _) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              width: 420,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // ENCABEZADO
                  Row(
                    children: [
                      const Icon(
                        Icons.notifications,
                        color: naranja,
                        size: 30,
                      ),
                      const SizedBox(width: 10),

                      const Expanded(
                        child: Text(
                          'Notificaciones',
                          style: TextStyle(
                            color: azulOscuro,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      if (servicio.notificaciones.isNotEmpty)
                        TextButton(
                          onPressed: servicio.limpiar,
                          child: const Text(
                            'Limpiar',
                            style: TextStyle(
                              color: naranja,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const Divider(),

                  const SizedBox(height: 8),

                  // CONTENIDO
                  Flexible(
                    child: servicio.notificaciones.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 30),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.notifications_none,
                                  size: 55,
                                  color: Color(0xFF64748B),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'No hay notificaciones nuevas',
                                  style: TextStyle(
                                    color: azulOscuro,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: servicio.notificaciones.length,
                            itemBuilder: (context, index) {

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(18),
                                  border: Border.all(
                                    color: const Color(0xFFE5E7EB),
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      blurRadius: 8,
                                      color: Color(0x22000000),
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),

                                child: Row(
                                  children: [

                                    Container(
                                      width: 45,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        color: naranja,
                                        borderRadius:
                                            BorderRadius.circular(50),
                                      ),
                                      child: const Icon(
                                        Icons.restaurant,
                                        color: Colors.white,
                                      ),
                                    ),

                                    const SizedBox(width: 12),

                                    Expanded(
                                      child: Text(
                                        servicio.notificaciones[index],
                                        style: const TextStyle(
                                          color: azulOscuro,
                                          fontSize: 15,
                                          fontWeight:
                                              FontWeight.w600,
                                        ),
                                      ),
                                    ),

                                    IconButton(
                                      tooltip: 'Eliminar',
                                      icon: const Icon(
                                        Icons.close,
                                        color: azulOscuro,
                                      ),
                                      onPressed: () {
                                        servicio.eliminar(index);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),

                  const SizedBox(height: 10),

                  // BOTÓN CERRAR
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: naranja,
                        foregroundColor: Colors.white,
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () =>
                          Navigator.pop(dialogContext),
                      child: const Text(
                        'Cerrar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}