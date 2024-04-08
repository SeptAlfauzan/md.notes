import 'package:file_io_simple/core/domain/common/data_state.dart';
import 'package:file_io_simple/core/utils/helper/file_helper.dart';
import 'package:flutter/foundation.dart';

class NotesProvider extends ChangeNotifier {
  DataState<List<String>> _dataState = const DataEmpty();
  DataState<List<String>> get dataState => _dataState;

  NotesProvider() {
    getAllSavedNotes();
  }

  Future<void> getAllSavedNotes() async {
    _dataState = const DataLoading();
    notifyListeners();
    try {
      final result = await FileHelper.getFiles();
      final paths = result.map((file) => file.path).toList();

      print("get notes $paths");

      if (paths.isEmpty) {
        _dataState = const DataEmpty();
      } else {
        _dataState = DataSuccess(data: paths);
      }
    } catch (e) {
      _dataState = DataFailed(errMessage: e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteNote(String path) async {
    try {
      await FileHelper.deleteFile(path);
    } catch (e) {
      print(e.toString());
    } finally {
      getAllSavedNotes();
    }
  }
}
