import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityModel {
  final String id;
  final String title;
  final String description;
  final String date;
  final String iconName;
  final String colorHex;
  final int pontos;
  final DateTime createdAt;

  ActivityModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.iconName,
    required this.colorHex,
    required this.pontos,
    required this.createdAt,
  });

  factory ActivityModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ActivityModel(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      date: data['date'] ?? '',
      iconName: data['iconName'] ?? 'event',
      colorHex: data['colorHex'] ?? '#059A00',
      pontos: data['pontos'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'iconName': iconName,
      'colorHex': colorHex,
      'pontos': pontos,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}