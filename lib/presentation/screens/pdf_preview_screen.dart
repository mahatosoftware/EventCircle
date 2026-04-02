import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../data/models/event_model.dart';
import '../../data/models/timeline_model.dart';
import '../../data/services/pdf_export_service.dart';

class PdfPreviewScreen extends StatelessWidget {
  final EventModel event;
  final List<TimelineItemModel> items;

  const PdfPreviewScreen({
    super.key,
    required this.event,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Preview'),
      ),
      body: PdfPreview(
        canDebug: false,
        build: (format) => _buildPdf(format),
        initialPageFormat: PdfPageFormat.a4,
        actionBarTheme: PdfActionBarTheme(
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Future<Uint8List> _buildPdf(PdfPageFormat format) async {
    final doc = await PdfExportService.generateTimelineDocument(event, items);
    return doc.save();
  }
}
