import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileHelper {
  static Future<File> writeFile(String path, String content) async {
    final file = File(path);
    print("saved file at: $path");
    return file.writeAsString(content);
  }

  static Future<String> getContentStrFromFile(String filename) async {
    final path = await getFilePath(filename);
    return await readFile(path);
  }

  static Future<String> readFile(String path) async {
    try {
      final file = File(path);
      return await file.readAsString();
    } catch (e) {
      rethrow;
    }
  }

  static Future<String> getFilePath(String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    final prefix = directory.path;
    final absolutePath = "$prefix/$filename.md";
    return absolutePath;
  }

  static Future<File> createNewFile(String title, String content) async {
    final filePath = await getFilePath(title);
    print('.😀 $filePath');
    return await writeFile(filePath, content);
  }

  static Future<List<FileSystemEntity>> getFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    final dir = Directory(directory.path);
    final files =
        dir.listSync().where((file) => file.path.contains(".md")).toList();
    return files;
  }

  static Future<bool> checkFileExist(String path) async {
    try {
      final result = await File(path).exists();
      return result;
    } catch (e) {
      rethrow;
    }
  }

  static Future<FileSystemEntity> deleteFile(String path) async =>
      await File(path).delete();
}
