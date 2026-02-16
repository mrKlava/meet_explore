import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../events/domain/entities/event.dart';
import '../../../events/presentation/providers/events_provider.dart';
import '../providers/admin_provider.dart';

class AdminEventFormScreen extends ConsumerStatefulWidget {
  final Event? initialEvent;

  const AdminEventFormScreen({
    super.key,
    this.initialEvent,
  });

  bool get isEditMode => initialEvent != null;

  @override
  ConsumerState<AdminEventFormScreen> createState() =>
      _AdminEventFormScreenState();
}

class _AdminEventFormScreenState extends ConsumerState<AdminEventFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  late final TextEditingController _titleController;
  late final TextEditingController _imageUrlController;
  late final TextEditingController _categoryController;
  late final TextEditingController _hostController;
  late final TextEditingController _placesController;
  late final TextEditingController _priceController;
  late final TextEditingController _cityController;
  late final TextEditingController _countryController;
  late final TextEditingController _addressController;
  late final TextEditingController _geoLatController;
  late final TextEditingController _geoLngController;
  late final TextEditingController _locationUrlController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _infoController;
  late final TextEditingController _infoImportantController;
  late final TextEditingController _jsonPasteController;

  late String _status;
  late bool _isPublished;
  late DateTime _dateStart;
  DateTime? _dateEnd;

  static const _eventStatuses = ['scheduled', 'cancelled', 'postponed'];

  @override
  void initState() {
    super.initState();
    final event = widget.initialEvent;

    _titleController = TextEditingController(text: event?.title ?? '');
    _imageUrlController = TextEditingController(text: event?.imageUrl ?? '');
    _categoryController = TextEditingController(text: event?.category ?? '');
    _hostController = TextEditingController(text: event?.host ?? '');
    _placesController = TextEditingController(
      text: event != null ? event.places.toString() : '0',
    );
    _priceController = TextEditingController(
      text: event != null ? event.price.toString() : '0',
    );
    _cityController = TextEditingController(text: event?.city ?? '');
    _countryController = TextEditingController(text: event?.country ?? '');
    _addressController = TextEditingController(text: event?.address ?? '');
    _geoLatController = TextEditingController(
      text: event?.geoLat?.toString() ?? '',
    );
    _geoLngController = TextEditingController(
      text: event?.geoLng?.toString() ?? '',
    );
    _locationUrlController = TextEditingController(text: event?.locationUrl ?? '');
    _descriptionController = TextEditingController(
      text: (event?.description ?? const []).join('\n'),
    );
    _infoController = TextEditingController(
      text: (event?.info ?? const []).join('\n'),
    );
    _infoImportantController = TextEditingController(
      text: (event?.infoImportant ?? const []).join('\n'),
    );
    _jsonPasteController = TextEditingController();

    _status = event?.status ?? 'scheduled';
    _isPublished = event?.isPublished ?? false;
    _dateStart = event?.dateStart ?? DateTime.now();
    _dateEnd = event?.dateEnd;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _imageUrlController.dispose();
    _categoryController.dispose();
    _hostController.dispose();
    _placesController.dispose();
    _priceController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _addressController.dispose();
    _geoLatController.dispose();
    _geoLngController.dispose();
    _locationUrlController.dispose();
    _descriptionController.dispose();
    _infoController.dispose();
    _infoImportantController.dispose();
    _jsonPasteController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime({
    required DateTime initial,
    required ValueChanged<DateTime> onSelected,
  }) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null) return;

    onSelected(DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    ));
  }

  List<String> _paragraphsFrom(TextEditingController controller) {
    return controller.text
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
  }

  bool _hasAnyInput() {
    return _titleController.text.trim().isNotEmpty ||
        _imageUrlController.text.trim().isNotEmpty ||
        _categoryController.text.trim().isNotEmpty ||
        _hostController.text.trim().isNotEmpty ||
        _cityController.text.trim().isNotEmpty ||
        _countryController.text.trim().isNotEmpty ||
        _addressController.text.trim().isNotEmpty ||
        _locationUrlController.text.trim().isNotEmpty ||
        _descriptionController.text.trim().isNotEmpty ||
        _infoController.text.trim().isNotEmpty ||
        _infoImportantController.text.trim().isNotEmpty;
  }

  Future<bool> _confirmOverwriteIfNeeded() async {
    if (!_hasAnyInput()) return true;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Replace form values?'),
          content: const Text(
            'Import will overwrite current values in this form.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text(AppStrings.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Replace'),
            ),
          ],
        );
      },
    );

    return confirmed == true;
  }

  Future<void> _showImportOptions() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.paste),
                title: const Text('Paste JSON'),
                onTap: () => Navigator.pop(sheetContext, 'paste'),
              ),
              ListTile(
                leading: const Icon(Icons.upload_file),
                title: const Text('Upload JSON file'),
                onTap: () => Navigator.pop(sheetContext, 'upload'),
              ),
            ],
          ),
        );
      },
    );

    if (!mounted || choice == null) return;
    final canOverwrite = await _confirmOverwriteIfNeeded();
    if (!canOverwrite || !mounted) return;

    if (choice == 'paste') {
      await _importFromPastedJson();
      return;
    }

    if (choice == 'upload') {
      await _importFromFile();
    }
  }

  Future<void> _importFromPastedJson() async {
    _jsonPasteController.clear();
    final rawJson = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Paste JSON'),
          content: SizedBox(
            width: 560,
            child: TextField(
              controller: _jsonPasteController,
              maxLines: 12,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '{ ... }',
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(AppStrings.cancel),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, _jsonPasteController.text.trim()),
              child: const Text('Import'),
            ),
          ],
        );
      },
    );

    if (rawJson == null || rawJson.isEmpty || !mounted) return;
    _importFromJsonText(rawJson);
  }

  Future<void> _importFromFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['json'],
      withData: true,
    );

    if (!mounted || result == null || result.files.isEmpty) return;

    final bytes = result.files.first.bytes;
    if (bytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not read selected file.')),
      );
      return;
    }

    _importFromJsonText(utf8.decode(bytes, allowMalformed: true));
  }

  void _importFromJsonText(String rawJson) {
    try {
      final decoded = jsonDecode(rawJson);
      if (decoded is! Map<String, dynamic>) {
        throw Exception('JSON root must be an object.');
      }

      final data = decoded['event'] is Map<String, dynamic>
          ? decoded['event'] as Map<String, dynamic>
          : decoded;

      final title = (data['title'] ?? '').toString();
      final imageUrl = (data['imageUrl'] ?? '').toString();
      if (title.isEmpty || imageUrl.isEmpty) {
        throw Exception('JSON must include at least title and imageUrl.');
      }

      final status = (data['status'] ?? 'scheduled').toString();
      final isPublished = data['isPublished'] == true;
      final dateStart = _parseDate(data['dateStart']) ?? DateTime.now();
      final dateEnd = _parseDate(data['dateEnd']);

      final geo = data['geo'];
      final geoLat = _toDouble(
        geo is Map
            ? geo['lat'] ?? geo['latitude']
            : null,
      );
      final geoLng = _toDouble(
        geo is Map
            ? geo['lng'] ?? geo['longitude']
            : null,
      );

      setState(() {
        _titleController.text = title;
        _imageUrlController.text = imageUrl;
        _categoryController.text = (data['category'] ?? '').toString();
        _hostController.text = (data['host'] ?? '').toString();
        _placesController.text =
            ((_toInt(data['places']) ?? 0).clamp(0, 1000000)).toString();
        _priceController.text = (_toDouble(data['price']) ?? 0).toString();
        _cityController.text = (data['city'] ?? '').toString();
        _countryController.text = (data['country'] ?? '').toString();
        _addressController.text = (data['address'] ?? '').toString();
        _geoLatController.text = geoLat?.toString() ?? '';
        _geoLngController.text = geoLng?.toString() ?? '';
        _locationUrlController.text = (data['locationUrl'] ?? '').toString();
        _descriptionController.text = _toStringList(data['description']).join('\n');
        _infoController.text = _toStringList(data['info']).join('\n');
        _infoImportantController.text =
            _toStringList(data['infoImportant']).join('\n');
        _status = _eventStatuses.contains(status) ? status : 'scheduled';
        _isPublished = isPublished;
        _dateStart = dateStart;
        _dateEnd = dateEnd;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('JSON imported. Review and save event.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Import failed: $e')),
      );
    }
  }

  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is String && value.trim().isNotEmpty) {
      return DateTime.tryParse(value.trim());
    }
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    if (value is num) {
      return DateTime.fromMillisecondsSinceEpoch(value.toInt());
    }
    return null;
  }

  int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value.trim());
    return null;
  }

  double? _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value.trim());
    return null;
  }

  List<String> _toStringList(dynamic value) {
    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }
    if (value is String && value.trim().isNotEmpty) {
      return value
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .toList();
    }
    return const [];
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final places = int.tryParse(_placesController.text.trim()) ?? 0;
    final price = double.tryParse(_priceController.text.trim()) ?? 0;
    final geoLat = double.tryParse(_geoLatController.text.trim());
    final geoLng = double.tryParse(_geoLngController.text.trim());

    final existing = widget.initialEvent;
    final now = DateTime.now();
    final event = Event(
      id: existing?.id ?? '',
      title: _titleController.text.trim(),
      imageUrl: _imageUrlController.text.trim(),
      category: _categoryController.text.trim(),
      host: _hostController.text.trim(),
      status: _status,
      isPublished: _isPublished,
      places: places < 0 ? 0 : places,
      participantsCount: existing?.participantsCount ?? 0,
      price: price < 0 ? 0 : price,
      dateStart: _dateStart,
      dateEnd: _dateEnd,
      city: _cityController.text.trim(),
      country: _countryController.text.trim(),
      address: _addressController.text.trim(),
      geoLat: geoLat,
      geoLng: geoLng,
      locationUrl: _locationUrlController.text.trim(),
      description: _paragraphsFrom(_descriptionController),
      info: _paragraphsFrom(_infoController),
      infoImportant: _paragraphsFrom(_infoImportantController),
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );

    setState(() {
      _isSaving = true;
    });

    try {
      final repository = ref.read(eventRepositoryProvider);
      if (widget.isEditMode) {
        await repository.updateEvent(event);
      } else {
        await repository.createEvent(event);
      }

      ref.invalidate(adminEventsProvider);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppStrings.errorPrefix}: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  String _dateTimeLabel(DateTime date) {
    final hh = date.hour.toString().padLeft(2, '0');
    final mm = date.minute.toString().padLeft(2, '0');
    final dd = date.day.toString().padLeft(2, '0');
    final mo = date.month.toString().padLeft(2, '0');
    return '$dd.$mo.${date.year} $hh:$mm';
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: widget.isEditMode ? 'Edit Event' : 'Create Event',
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppDimens.space16),
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                onPressed: _showImportOptions,
                icon: const Icon(Icons.file_upload_outlined),
                label: const Text('Import JSON'),
              ),
            ),
            const SizedBox(height: AppDimens.space8),
            _Field(
              label: 'Title',
              controller: _titleController,
              requiredField: true,
            ),
            _Field(
              label: 'Image URL',
              controller: _imageUrlController,
              requiredField: true,
            ),
            _Field(
              label: 'Category',
              controller: _categoryController,
            ),
            _Field(
              label: 'Host',
              controller: _hostController,
            ),
            Row(
              children: [
                Expanded(
                  child: _Field(
                    label: 'Places (0 = unlimited)',
                    controller: _placesController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: AppDimens.space12),
                Expanded(
                  child: _Field(
                    label: 'Price',
                    controller: _priceController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.space8),
            DropdownButtonFormField<String>(
              initialValue: _status,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: _eventStatuses
                  .map(
                    (status) => DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() => _status = value);
              },
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Published'),
              value: _isPublished,
              onChanged: (value) => setState(() => _isPublished = value),
            ),
            const SizedBox(height: AppDimens.space8),
            _DateTile(
              label: 'Start Date',
              value: _dateTimeLabel(_dateStart),
              onTap: () => _pickDateTime(
                initial: _dateStart,
                onSelected: (value) => setState(() => _dateStart = value),
              ),
            ),
            _DateTile(
              label: 'End Date',
              value: _dateEnd == null ? 'Not set' : _dateTimeLabel(_dateEnd!),
              onTap: () => _pickDateTime(
                initial: _dateEnd ?? _dateStart,
                onSelected: (value) => setState(() => _dateEnd = value),
              ),
              onClear: _dateEnd == null ? null : () => setState(() => _dateEnd = null),
            ),
            const SizedBox(height: AppDimens.space8),
            _Field(label: 'City', controller: _cityController),
            _Field(label: 'Country', controller: _countryController),
            _Field(label: 'Address', controller: _addressController),
            Row(
              children: [
                Expanded(
                  child: _Field(
                    label: 'Geo lat (optional)',
                    controller: _geoLatController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                  ),
                ),
                const SizedBox(width: AppDimens.space12),
                Expanded(
                  child: _Field(
                    label: 'Geo lng (optional)',
                    controller: _geoLngController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                  ),
                ),
              ],
            ),
            _Field(label: 'Location URL', controller: _locationUrlController),
            _Field(
              label: 'Description paragraphs (1 per line)',
              controller: _descriptionController,
              maxLines: 5,
            ),
            _Field(
              label: 'Info paragraphs (1 per line)',
              controller: _infoController,
              maxLines: 4,
            ),
            _Field(
              label: 'Important info paragraphs (1 per line)',
              controller: _infoImportantController,
              maxLines: 4,
            ),
            const SizedBox(height: AppDimens.space16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isSaving
                        ? null
                        : () {
                            Navigator.of(context).pop(false);
                          },
                    child: const Text(AppStrings.cancel),
                  ),
                ),
                const SizedBox(width: AppDimens.space12),
                Expanded(
                  child: FilledButton(
                    onPressed: _isSaving ? null : _save,
                    child: Text(_isSaving ? 'Saving...' : 'Save Event'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.space24),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool requiredField;
  final int maxLines;
  final TextInputType? keyboardType;

  const _Field({
    required this.label,
    required this.controller,
    this.requiredField = false,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.space12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: (value) {
          if (!requiredField) return null;
          if ((value ?? '').trim().isEmpty) return AppStrings.required;
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

class _DateTile extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const _DateTile({
    required this.label,
    required this.value,
    required this.onTap,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimens.space12),
      child: ListTile(
        title: Text(label),
        subtitle: Text(value),
        onTap: onTap,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onClear != null)
              IconButton(
                tooltip: 'Clear',
                icon: const Icon(Icons.clear),
                onPressed: onClear,
              ),
            const Icon(Icons.calendar_today_outlined),
          ],
        ),
      ),
    );
  }
}
