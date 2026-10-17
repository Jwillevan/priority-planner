import 'dart:convert';

import 'package:flutter_quill/flutter_quill.dart';

// Keep the stored Delta and searchable text consistent, without rendering HTML.
String journalPlainText(String delta) {
  final document = Document.fromJson(jsonDecode(delta) as List);
  return document.toPlainText();
}

List<String> normalizeTags(Iterable<String> values) =>
    values
        .map((v) => v.trim().toLowerCase())
        .where((v) => v.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
