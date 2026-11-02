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
  const verde = Color(0xFF22A982);

  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AnimatedBuilder(
        animation: servicio,
        builder: (context, _) {
          return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            title: Row(
              children: [
                const Icon(
                  Icons.notifications,
                  color: naranja,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Notificaciones',
                    style: TextStyle(
                      color: azulOscuro,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (servicio.notificaciones.isNotEmpty)
                  TextButton(
                    onPressed: servicio.limpiar,
                    style: TextButton.styleFrom(
                      foregroundColor: naranja,
                    ),
                    child: const Text('Limpiar'),
                  ),
              ],
            ),
            content: SizedBox(
              width: 360,
              child: servicio.notificaciones.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.notifications_none,
                            size: 48,
                            color: Color(0xFF64748B),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'No hay notificaciones nuevas.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: azulOscuro),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: servicio.notificaciones.length,
                      separatorBuilder: (_, __) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(
                            Icons.notifications_active,
                            color: naranja,
                          ),
                          title: Text(
                            servicio.notificaciones[index],
                            style: const TextStyle(
                              color: azulOscuro,
                            ),
                          ),
                          trailing: IconButton(
                            tooltip: 'Marcar como vista',
                            icon: const Icon(
                              Icons.close,
                              color: azulOscuro,
                            ),
                            onPressed: () {
                              servicio.eliminar(index);
                            },
                          ),
                        );
                      },
                    ),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: naranja,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cerrar'),
              ),
            ],
          );
        },
      );
    },
  );
}
