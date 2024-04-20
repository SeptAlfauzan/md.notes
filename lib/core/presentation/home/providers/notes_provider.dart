import 'package:file_io_simple/core/domain/common/data_state.dart';
import 'package:file_io_simple/core/domain/entities/notes.dart';
import 'package:file_io_simple/core/utils/helper/database_helper.dart';
import 'package:file_io_simple/core/utils/helper/file_helper.dart';
import 'package:flutter/foundation.dart';

class NotesProvider extends ChangeNotifier {
  late DatabaseHelper _databaseHelper;
  DataState<List<Note>> _dataState = const DataEmpty();
  DataState<List<Note>> get dataState => _dataState;

  NotesProvider() {
    _databaseHelper = DatabaseHelper();
    getAllSavedNotes();
  }

  Future<void> getAllSavedNotes() async {
    _dataState = const DataLoading();
    notifyListeners();
    try {
      final resultFiles = await FileHelper.getFiles();
      final filePaths = resultFiles.map((file) => file.path).toList();

      print(filePaths);

      final result = await _databaseHelper.getNotes();

      if (result.isEmpty) {
        _dataState = const DataEmpty();
      } else {
        _dataState = DataSuccess(data: result);
      }
    } catch (e) {
      _dataState = DataFailed(errMessage: e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteNote(String filename) async {
    try {
      final path = await FileHelper.getFilePath(filename);
      await _databaseHelper.deleteNote(filename);
      await FileHelper.deleteFile(path);
    } catch (e) {
      print(e.toString());
    } finally {
      getAllSavedNotes();
    }
  }
}
