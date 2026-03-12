import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class AdminService {
  final _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getAllAttendance() async {
    final response = await _supabase
        .from('attendance')
        .select('*, profiles(full_name, email)')
        .order('check_in', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> generateAttendanceReport() async {
    final data = await getAllAttendance();
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Attendance Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['Employee', 'Check-In', 'Status', 'Verified'],
                data: data.map((item) {
                  return [
                    item['profiles']['full_name'] ?? 'Unknown',
                    item['check_in'].toString(),
                    item['status'],
                    item['verified_via_face'] ? 'Face+GPS' : 'Manual',
                  ];
                }).toList(),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
