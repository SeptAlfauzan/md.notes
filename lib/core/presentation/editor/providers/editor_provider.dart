import 'package:file_io_simple/core/domain/entities/editor.dart';
import 'package:file_io_simple/core/domain/entities/notes.dart';
import 'package:file_io_simple/core/utils/helper/database_helper.dart';
import 'package:file_io_simple/core/utils/helper/debouncer_helper.dart';
import 'package:file_io_simple/core/utils/helper/file_helper.dart';
import 'package:flutter/foundation.dart';

class EditorProvider extends ChangeNotifier {
  late DatabaseHelper _databaseHelper;
  EditorDataEntity? _editorData;
  EditorDataEntity? get editorData => _editorData;
  late Debouncer _debouncer;
  late Note _notes;

  EditorProvider() {
    _databaseHelper = DatabaseHelper();
    _debouncer = Debouncer(milliseconds: 400);
  }

  Future<String> readNoteContentStr(String filename) async =>
      await FileHelper.getContentStrFromFile(filename);

  void initializeEditor(Note noteData) {
    _notes = noteData;
    final newData = EditorDataEntity(
      recordDatas: [noteData.data],
      currentData: noteData.data,
      activeRecordIdx: 0,
      onEdit: false,
      onPreview: false,
      onSplitMode: false,
      undoAble: false,
      redoAble: false,
    );
    _editorData = newData;
    notifyListeners();
  }

  void togglePreview() {
    _editorData = _editorData?.copyWith(
        onSplitMode: false, onPreview: !(_editorData?.onPreview ?? false));
    notifyListeners();
  }

  void toggleSplitMode() {
    _editorData = _editorData?.copyWith(
        onPreview: false, onSplitMode: !(_editorData?.onSplitMode ?? false));
    notifyListeners();
  }

  void startEditing() {
    print("start editing");
    _editorData = _editorData?.copyWith(onEdit: true);
    notifyListeners();
  }

  Future<void> saveFile() async {
    print("close editing");
    try {
      final filePath = await FileHelper.getFilePath(_notes.id);
      final isFileExist = await FileHelper.checkFileExist(filePath);
      final content = _editorData?.currentData ?? "-";
      print("notes id adalah ${_notes.id}");
      if (isFileExist) {
        await FileHelper.writeFile(filePath, content);
      } else {
        await FileHelper.createNewFile(_notes.id, content);
      }
      _editorData = _editorData?.copyWith(onEdit: false, onSplitMode: false);
      print(_notes.toMap());
      await _databaseHelper.insertNote(_notes);

      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  void updateMarkdown(String arg) {
    _editorData = _editorData?.copyWith(
      currentData: arg,
    );
    _notes = _notes.copyWith(data: arg);
    print(_notes.data);
    notifyListeners();
    _debouncer.run(() => _updateRecordEditor(arg));
  }

  void undo() {
    final currentActiveIndex = _editorData?.activeRecordIdx ?? 0;
    final updatedActiveIndex =
        currentActiveIndex == 0 ? 0 : currentActiveIndex - 1;

    final undoAble = currentActiveIndex == 0 ? false : true;

    _editorData = _editorData?.copyWith(
      currentData: _editorData?.recordDatas[updatedActiveIndex],
      activeRecordIdx: updatedActiveIndex,
      undoAble: undoAble,
      redoAble: true,
    );

    _notes = _notes.copyWith(data: _editorData?.currentData);
    notifyListeners();
  }

  void redo() {
    final currentActiveIndex =
        _editorData?.activeRecordIdx ?? _editorData!.recordDatas.length - 1;
    final updatedActiveIndex =
        currentActiveIndex == _editorData!.recordDatas.length - 1
            ? _editorData!.recordDatas.length - 1
            : currentActiveIndex + 1;

    final redoAble = currentActiveIndex == _editorData!.recordDatas.length - 1
        ? false
        : true;

    _editorData = _editorData?.copyWith(
      currentData: _editorData?.recordDatas[updatedActiveIndex],
      activeRecordIdx: updatedActiveIndex,
      redoAble: redoAble,
      undoAble: true,
    );

    _notes = _notes.copyWith(data: _editorData?.currentData);
    notifyListeners();
  }

  void _updateRecordEditor(String arg) {
    print("update record of editing");
    final currentRecord = _editorData!.recordDatas;
    final currentActiveIndex = _editorData!.activeRecordIdx;
    final lastActiveRecord = _editorData!.recordDatas.length - 1;
    if (currentActiveIndex < lastActiveRecord) {
      //remove next index until last index of editing records if user already presss unde and start editing again
      currentRecord.removeRange(currentActiveIndex + 1, lastActiveRecord + 1);
    }

    currentRecord.add(arg);

    _editorData = _editorData?.copyWith(
      recordDatas: currentRecord,
      activeRecordIdx: currentRecord.length - 1,
      redoAble: false,
      undoAble: true,
    );
    notifyListeners();
  }
}
