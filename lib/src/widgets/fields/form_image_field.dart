/// An image upload field for [FormFlow], backed by `image_picker`.
library;

import 'dart:io';
import 'dart:ui' show PathMetric;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/form_schema.dart';
import '../../theme/form_theme.dart';

/// Renders an image picker that lets the user capture a photo with the camera
/// or select one from the gallery.
///
/// When no image is selected a dashed upload prompt is shown; once an image is
/// chosen it is previewed in a rounded square with a remove button.
class FormImageField extends StatefulWidget {
  /// The schema describing this field.
  final FormFieldSchema field;

  /// The initial image file path, if any.
  final String? imagePath;

  /// Called with the selected image's file path, or `null` when removed.
  final ValueChanged<String?> onChanged;

  /// The current error message, or `null` when valid.
  final String? errorText;

  /// The active form theme used for styling.
  final FormTheme theme;

  /// The resolved locale code.
  final String locale;

  /// Optional message overrides forwarded from [FormFlow].
  final Map<String, String>? customMessages;

  /// Creates an image field widget.
  const FormImageField({
    super.key,
    required this.field,
    required this.onChanged,
    required this.theme,
    required this.locale,
    this.imagePath,
    this.errorText,
    this.customMessages,
  });

  @override
  State<FormImageField> createState() => _FormImageFieldState();
}

class _FormImageFieldState extends State<FormImageField> {
  final ImagePicker _picker = ImagePicker();
  String? _path;

  @override
  void initState() {
    super.initState();
    _path = widget.imagePath;
  }

  Future<void> _pick(ImageSource source) async {
    final XFile? file = await _picker.pickImage(
      source: source,
      imageQuality: 85,
    );
    if (file != null) {
      setState(() => _path = file.path);
      widget.onChanged(file.path);
    }
  }

  void _remove() {
    setState(() => _path = null);
    widget.onChanged(null);
  }

  Future<void> _showSourceSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext sheetContext) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _pick(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _pick(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final FormFieldTheme? fieldTheme = widget.theme.fieldTheme;
    final Color primary =
        widget.theme.primaryColor ?? Theme.of(context).primaryColor;
    final bool hasImage = _path != null && _path!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            widget.field.label,
            style: fieldTheme?.labelStyle ??
                Theme.of(context).textTheme.titleSmall,
          ),
        ),
        if (hasImage)
          _buildPreview(primary)
        else
          _buildUploadPrompt(context, primary),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 4.0),
            child: Text(
              widget.errorText!,
              style: fieldTheme?.errorStyle ??
                  TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12.0,
                  ),
            ),
          ),
      ],
    );
  }

  Widget _buildPreview(Color primary) {
    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(widget.theme.borderRadius),
          child: Image.file(
            File(_path!),
            width: 120,
            height: 120,
            fit: BoxFit.cover,
            errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) =>
                Container(
              width: 120,
              height: 120,
              color: Colors.grey.shade200,
              child: const Icon(Icons.broken_image, color: Colors.grey),
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: _remove,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(4),
              child: const Icon(
                Icons.close,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadPrompt(BuildContext context, Color primary) {
    return GestureDetector(
      onTap: _showSourceSheet,
      child: _DashedBorder(
        radius: widget.theme.borderRadius,
        color: primary,
        child: Container(
          width: double.infinity,
          height: 120,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.cloud_upload_outlined, size: 32, color: primary),
              const SizedBox(height: 8),
              Text(
                widget.field.placeholder ?? widget.field.label,
                style: TextStyle(color: primary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A simple dashed-border container used by the image upload prompt.
class _DashedBorder extends StatelessWidget {
  final Widget child;
  final double radius;
  final Color color;

  const _DashedBorder({
    required this.child,
    required this.radius,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(radius: radius, color: color),
      child: child,
    );
  }
}

/// Paints a rounded dashed rectangle border.
class _DashedBorderPainter extends CustomPainter {
  final double radius;
  final Color color;

  _DashedBorderPainter({required this.radius, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );

    final Path path = Path()..addRRect(rrect);
    const double dashWidth = 6.0;
    const double dashSpace = 4.0;

    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final double next = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}
