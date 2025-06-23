// lib/features/notifications/views/notification_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentyapp/core/controllers/controller.dart'; // Tu AppController
import 'package:rentyapp/features/notifications/model/notification_model.dart';
import 'package:rentyapp/features/notifications/service/notification_service.dart';
import 'package:rentyapp/features/notifications/widgets/notification_card.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late final NotificationService _notificationService;
  late final String _userId;

  @override
  void initState() {
    super.initState();
    // Obtenemos el servicio y el ID de usuario desde el Provider
    _notificationService = context.read<NotificationService>();
    final appController = context.read<AppController>();
    _userId = appController.currentUser?.userId ?? '';

    // Marcar todas las notificaciones como leídas al entrar a la pantalla
    if (_userId.isNotEmpty) {
      _notificationService.markAllAsRead(_userId);
    }
  }

  // Función para agrupar notificaciones por fecha
  Map<String, List<NotificationModel>> _groupNotifications(List<NotificationModel> notifications) {
    final Map<String, List<NotificationModel>> grouped = {};
    final now = DateTime.now();

    for (var notif in notifications) {
      final difference = now.difference(notif.createdAt);
      String key;
      if (difference.inDays < 1 && now.day == notif.createdAt.day) {
        key = 'TODAY';
      } else if (difference.inDays < 7) {
        key = 'THIS WEEK';
      } else {
        key = 'EARLIER';
      }

      if (grouped[key] == null) {
        grouped[key] = [];
      }
      grouped[key]!.add(notif);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Notifications', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: _userId.isEmpty
          ? const Center(child: Text("Please log in to see notifications.", style: TextStyle(color: Colors.white70)))
          : StreamBuilder<List<NotificationModel>>(
        stream: _notificationService.getNotificationsStream(_userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.red)));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("You have no notifications.", style: TextStyle(color: Colors.white70)));
          }

          final notifications = snapshot.data!;
          final groupedNotifications = _groupNotifications(notifications);

          // Definimos el orden de las secciones
          final sections = ['TODAY', 'THIS WEEK', 'EARLIER']
              .where((key) => groupedNotifications.containsKey(key))
              .toList();

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: sections.length,
            itemBuilder: (context, index) {
              final key = sections[index];
              final notifsInSection = groupedNotifications[key]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
                    child: Text(
                      key,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  ...notifsInSection.map((notif) => NotificationCard(
                    notification: notif,
                    onTap: () {
                      // Marcar como leída si no lo está
                      if (!notif.isRead) {
                        _notificationService.markAsRead(_userId, notif.notificationId);
                      }
                      // TODO: Implementar navegación según metadata
                      // ej: Navigator.of(context).push(...)
                      print("Tapped notification: ${notif.title}");
                      print("Metadata: ${notif.metadata}");
                    },
                  )).toList(),
                ],
              );
            },
          );
        },
      ),
    );
  }
}