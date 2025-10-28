import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:escoteiro/models/activity_model.dart';
import 'package:escoteiro/services/activity_service.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ManageActivitiesScreen extends StatefulWidget {
  const ManageActivitiesScreen({super.key});

  @override
  State<ManageActivitiesScreen> createState() => _ManageActivitiesScreenState();
}

class _ManageActivitiesScreenState extends State<ManageActivitiesScreen> {
  final ActivityService _activityService = ActivityService();

  void _showActivityDialog({ActivityModel? activity}) {
    showDialog(
      context: context,
      builder: (context) => ActivityFormDialog(
        activity: activity,
        onSave: (newActivity) async {
          try {
            if (activity == null) {
              await _activityService.createActivity(newActivity);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Atividade criada com sucesso!'),
                    backgroundColor: Color(0xFF059A00),
                  ),
                );
              }
            } else {
              await _activityService.updateActivity(activity.id, newActivity);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Atividade atualizada com sucesso!'),
                    backgroundColor: Color(0xFF059A00),
                  ),
                );
              }
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Erro: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
      ),
    );
  }

  void _deleteActivity(ActivityModel activity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Deseja realmente excluir "${activity.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _activityService.deleteActivity(activity.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Atividade excluída com sucesso!'),
                      backgroundColor: Color(0xFF059A00),
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro ao excluir: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE2F0E1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF059A00),
        foregroundColor: Colors.white,
        title: const Text('Gerenciar Atividades'),
        elevation: 0,
      ),
      body: StreamBuilder<List<ActivityModel>>(
        stream: _activityService.getActivities(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Erro: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF059A00),
              ),
            );
          }

          final activities = snapshot.data!;

          if (activities.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_busy,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhuma atividade cadastrada',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              final color = Color(
                int.parse(activity.colorHex.replaceFirst('#', '0xFF')),
              );

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Icon(
                    _getIconData(activity.iconName),
                    color: color,
                    size: 32,
                  ),
                  title: Text(
                    activity.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${activity.date} • ${activity.pontos} pontos',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Color(0xFF059A00)),
                        onPressed: () => _showActivityDialog(activity: activity),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteActivity(activity),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showActivityDialog(),
        backgroundColor: const Color(0xFF059A00),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'terrain':
        return Icons.terrain;
      case 'medical_services':
        return Icons.medical_services_outlined;
      case 'local_florist':
        return Icons.local_florist_outlined;
      case 'people':
        return Icons.people_outline;
      case 'sports':
        return Icons.sports;
      case 'school':
        return Icons.school;
      case 'volunteer_activism':
        return Icons.volunteer_activism;
      default:
        return Icons.event;
    }
  }
}

class ActivityFormDialog extends StatefulWidget {
  final ActivityModel? activity;
  final Function(ActivityModel) onSave;

  const ActivityFormDialog({
    super.key,
    this.activity,
    required this.onSave,
  });

  @override
  State<ActivityFormDialog> createState() => _ActivityFormDialogState();
}

class _ActivityFormDialogState extends State<ActivityFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _dateController;
  late TextEditingController _pontosController;
  late String _selectedIcon;
  late Color _selectedColor;

  final List<Map<String, dynamic>> _availableIcons = [
    {'name': 'terrain', 'icon': Icons.terrain},
    {'name': 'medical_services', 'icon': Icons.medical_services_outlined},
    {'name': 'local_florist', 'icon': Icons.local_florist_outlined},
    {'name': 'people', 'icon': Icons.people_outline},
    {'name': 'sports', 'icon': Icons.sports},
    {'name': 'school', 'icon': Icons.school},
    {'name': 'volunteer_activism', 'icon': Icons.volunteer_activism},
    {'name': 'event', 'icon': Icons.event},
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.activity?.title ?? '');
    _descriptionController = TextEditingController(text: widget.activity?.description ?? '');
    _dateController = TextEditingController(text: widget.activity?.date ?? '');
    _pontosController = TextEditingController(text: widget.activity?.pontos.toString() ?? '');
    _selectedIcon = widget.activity?.iconName ?? 'event';
    _selectedColor = widget.activity != null
        ? Color(int.parse(widget.activity!.colorHex.replaceFirst('#', '0xFF')))
        : const Color(0xFF059A00);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _pontosController.dispose();
    super.dispose();
  }

  void _pickColor() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Escolher cor'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _selectedColor,
            onColorChanged: (color) {
              setState(() {
                _selectedColor = color;
              });
            },
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.activity == null ? 'Nova Atividade' : 'Editar Atividade'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Data',
                  border: OutlineInputBorder(),
                  hintText: 'Ex: 25 de Outubro',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _pontosController,
                decoration: const InputDecoration(
                  labelText: 'Pontos',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Digite um número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedIcon,
                decoration: const InputDecoration(
                  labelText: 'Ícone',
                  border: OutlineInputBorder(),
                ),
                items: _availableIcons.map((iconData) {
                  return DropdownMenuItem<String>(
                    value: iconData['name'] as String,
                    child: Row(
                      children: [
                        Icon(iconData['icon'] as IconData),
                        const SizedBox(width: 8),
                        Text(iconData['name'] as String),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedIcon = value!;
                  });
                },
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _pickColor,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _selectedColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text('Escolher cor'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final activity = ActivityModel(
                id: widget.activity?.id ?? '',
                title: _titleController.text,
                description: _descriptionController.text,
                date: _dateController.text,
                iconName: _selectedIcon,
                colorHex: '#${_selectedColor.value.toRadixString(16).substring(2)}',
                pontos: int.parse(_pontosController.text),
                createdAt: widget.activity?.createdAt ?? DateTime.now(),
              );
              widget.onSave(activity);
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF059A00),
            foregroundColor: Colors.white,
          ),
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}