import 'dart:io';
import 'dart:isolate';
import 'package:excel/excel.dart' as exc;
import 'package:path_provider/path_provider.dart';

abstract class ExcelHelper {
  /// Generates a premium platform-agnostic Excel sheet from a set of data items,
  /// maps them, saves to the local app documents directory, and launches the native OS viewer.
  /// Returns the absolute file path if saved successfully.
  static Future<String> exportToExcel<T>({
    required List<String> headers,
    required List<T> items,
    required List<String> Function(T item) rowMapper,
    required String fileName,
    List<List<String>>? footers,
    List<List<String>>? metadata,
  }) async {
    final excel = exc.Excel.createExcel();
    final sheet = excel['Sheet1'];

    // Write Metadata Rows if any
    if (metadata != null) {
      for (final row in metadata) {
        sheet.appendRow(row.map((e) => exc.TextCellValue(e)).toList());
      }
      sheet.appendRow([]); // empty row separator
    }

    // Write Headers Row
    final List<exc.CellValue> headerValues = headers
        .map((h) => exc.TextCellValue(h))
        .toList();
    sheet.appendRow(headerValues);

    // Write Data Rows
    for (final item in items) {
      final List<exc.CellValue> rowCells = rowMapper(
        item,
      ).map((val) => exc.TextCellValue(val)).toList();
      sheet.appendRow(rowCells);
    }

    if (footers != null) {
      for (final footerRow in footers) {
        final List<exc.CellValue> rowCells = footerRow
            .map((val) => exc.TextCellValue(val))
            .toList();
        sheet.appendRow(rowCells);
      }
    }

    final bytes = excel.save();
    if (bytes == null) {
      throw Exception('Failed to generate Excel bytes.');
    }

    Directory? directory;
    try {
      if (Platform.isAndroid) {
        final dir = Directory('/storage/emulated/0/Download');
        if (await dir.exists()) {
          directory = dir;
        }
      }
      directory ??= await getDownloadsDirectory();
    } catch (_) {
      // Ignore directory retrieval errors to allow fallback
    }
    directory ??= await getApplicationDocumentsDirectory();

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final filePath = '${directory.path}/${fileName}_$timestamp.xlsx';

    final file = File(filePath);
    await file.writeAsBytes(bytes);

    return filePath;
  }

  /// Exports data to Excel using an Isolate for heavy processing.
  static Future<String> exportToExcelInIsolate({
    required List<String> headers,
    required List<List<String>> stringRows,
    required String filePath,
    List<List<String>>? footers,
    List<List<String>>? metadata,
  }) async {
    return await Isolate.run(() {
      final excel = exc.Excel.createExcel();
      final sheet = excel['Sheet1'];

      // Write Metadata Rows if any
      if (metadata != null) {
        for (final row in metadata) {
          sheet.appendRow(row.map((e) => exc.TextCellValue(e)).toList());
        }
        sheet.appendRow([]); // empty row separator
      }

      // Write Headers Row
      final List<exc.CellValue> headerValues = headers
          .map((h) => exc.TextCellValue(h))
          .toList();
      sheet.appendRow(headerValues);

      // Write Data Rows
      for (final row in stringRows) {
        final List<exc.CellValue> rowCells = row
            .map((val) => exc.TextCellValue(val))
            .toList();
        sheet.appendRow(rowCells);
      }

      if (footers != null) {
        for (final footerRow in footers) {
          final List<exc.CellValue> rowCells = footerRow
              .map((val) => exc.TextCellValue(val))
              .toList();
          sheet.appendRow(rowCells);
        }
      }

      final bytes = excel.save();
      if (bytes == null) {
        throw Exception('Failed to generate Excel bytes.');
      }

      final file = File(filePath);
      file.writeAsBytesSync(bytes);

      return filePath;
    });
  }
}
