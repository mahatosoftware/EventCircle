import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import '../../data/models/venue_ticketing_model.dart';
import '../../data/models/event_model.dart';
import 'package:intl/intl.dart';

class TicketService {
  static Future<File> generateTicketPdf(
    EventModel event,
    TicketModel ticketType,
    IssuedTicketModel issuedTicket,
    TicketDesignModel design,
  ) async {
    final pdf = pw.Document();

    // Load fonts or images if needed
    // final profileImage = pw.MemoryImage((await rootBundle.load('assets/logo.png')).buffer.asUint8List());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5,
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(20),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey, width: 2),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(event.title, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                    pw.Text(ticketType.title.toUpperCase(), style: pw.TextStyle(fontSize: 16, color: PdfColors.blue)),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Divider(),
                pw.SizedBox(height: 20),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          _buildPdfField('Attendee', issuedTicket.attendeeName.contains('Guest') ? 'ANONYMOUS ATTENDEE' : issuedTicket.attendeeName),
                          _buildPdfField('Date', event.startDate != null ? DateFormat('MMM dd, yyyy').format(event.startDate!) : 'TBD'),
                          _buildPdfField('Location', event.location ?? 'Remote'),
                          _buildPdfField('Ticket ID', issuedTicket.id.split('-').first.toUpperCase()),
                        ],
                      ),
                    ),
                    pw.Container(
                      width: 100,
                      height: 100,
                      child: pw.BarcodeWidget(
                        barcode: pw.Barcode.qrCode(),
                        data: issuedTicket.qrData,
                      ),
                    ),
                  ],
                ),
                pw.Spacer(),
                pw.Center(
                  child: pw.Text(design.customMessage ?? 'Show this QR code at the entry.', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
                ),
              ],
            ),
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/ticket_${issuedTicket.id.split('-').first}.pdf");
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static pw.Widget _buildPdfField(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(label.toUpperCase(), style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
          pw.Text(value, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }

  static Future<void> printTicket(File file) async {
    final bytes = await file.readAsBytes();
    await Printing.layoutPdf(onLayout: (format) => bytes);
  }
}
