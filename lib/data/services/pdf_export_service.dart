import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/timeline_model.dart';
import '../models/event_model.dart';
import 'package:intl/intl.dart';

class PdfExportService {
  static Future<pw.Document> generateTimelineDocument(EventModel event, List<TimelineItemModel> items) async {
    final pdf = pw.Document();
    
    // Load font for better character support (especially Rupees symbol)
    final font = await PdfGoogleFonts.notoSansRegular();
    final boldFont = await PdfGoogleFonts.notoSansBold();
    
    final theme = pw.ThemeData.withFont(
      base: font,
      bold: boldFont,
    );

    final preEventItems = items.where((i) => i.phase == TimelinePhase.preEvent).toList();
    final postEventItems = items.where((i) => i.phase == TimelinePhase.postEvent).toList();
    final eventDayItems = items.where((i) => i.phase == TimelinePhase.eventDay).toList();
    
    eventDayItems.sort((a, b) => a.dayNumber.compareTo(b.dayNumber));

    final totalDays = (event.startDate != null && event.endDate != null)
        ? event.endDate!.difference(event.startDate!).inDays + 1
        : 1;

    pdf.addPage(
      pw.MultiPage(
        theme: theme,
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (pw.Context context) => pw.Header(
          level: 0,
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(event.title.toUpperCase(), style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.deepPurple)),
                  pw.SizedBox(height: 4),
                  pw.Text('Event Schedule & Timeline', style: pw.TextStyle(color: PdfColors.grey700)),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  if (event.startDate != null)
                    pw.Text(DateFormat('MMM dd, yyyy').format(event.startDate!)),
                  pw.Text(event.location ?? 'Remote', style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                ],
              ),
            ],
          ),
        ),
        footer: (pw.Context context) => pw.Column(
          children: [
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Generated via EventCircle', style: pw.TextStyle(fontSize: 8, color: PdfColors.grey)),
                pw.Text('Page ${context.pageNumber} of ${context.pagesCount}', style: pw.TextStyle(fontSize: 8, color: PdfColors.grey)),
              ],
            ),
          ],
        ),
        build: (pw.Context context) {
          return [
            pw.SizedBox(height: 10),
            // Pre-event Section
            if (preEventItems.isNotEmpty) ...[
              _buildSectionHeader('PRE-EVENT PREPARATION'),
              ...preEventItems.map((item) => _buildTimelineTile(item)),
              pw.SizedBox(height: 20),
            ],

            // Event Days
            for (int d = 1; d <= totalDays; d++) ...[
              if (eventDayItems.any((i) => i.dayNumber == d)) ...[
                _buildSectionHeader(totalDays > 1 ? 'DAY $d SCHEDULE' : 'EVENT DAY SCHEDULE'),
                ...eventDayItems.where((i) => i.dayNumber == d).map((item) => _buildTimelineTile(item)),
                pw.SizedBox(height: 20),
              ],
            ],

            // Post-event Section
            if (postEventItems.isNotEmpty) ...[
              _buildSectionHeader('POST-EVENT WRAP-UP'),
              ...postEventItems.map((item) => _buildTimelineTile(item)),
            ],
          ];
        },
      ),
    );
    return pdf;
  }

  static Future<void> exportTimeline(EventModel event, List<TimelineItemModel> items) async {
    final pdf = await generateTimelineDocument(event, items);

    try {
      final sanitizedTitle = event.title.replaceAll(RegExp(r'[^\w\s-]'), '').replaceAll(' ', '_');
      final bytes = await pdf.save();
      
      await Printing.sharePdf(
        bytes: bytes,
        filename: '${sanitizedTitle}_Schedule.pdf',
      );
    } catch (e) {
      debugPrint('Error exporting PDF: $e');
      rethrow;
    }
  }

  static pw.Widget _buildSectionHeader(String title) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      margin: const pw.EdgeInsets.only(bottom: 12, top: 8),
      decoration: const pw.BoxDecoration(color: PdfColors.grey200),
      child: pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12, letterSpacing: 1.2)),
    );
  }

  static pw.Widget _buildTimelineTile(TimelineItemModel item) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8, left: 8),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: 80,
            child: pw.Text(item.timeOrOffset, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.deepPurple900, fontSize: 10)),
          ),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(item.title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                if (item.description != null)
                  pw.Text(item.description!, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey800)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
