import 'package:file_io_simple/core/domain/entities/editor.dart';
import 'package:file_io_simple/core/domain/entities/notes.dart';
import 'package:flutter/foundation.dart';

class EditorProvider extends ChangeNotifier {
  EditorDataEntity? _editorData;
  EditorDataEntity? get editorData => _editorData;

  Future<void> initializeEditor(Notes noteData) async {
    final newData = EditorDataEntity(
      recordDatas: [noteData.data],
      currentData: noteData.data,
      activeRecordIdx: 0,
      onEdit: false,
      onPreview: false,
    );
    _editorData = newData;
    notifyListeners();
  }

  Future<void> togglePreview() async {
    _editorData =
        _editorData?.copyWith(onPreview: !(_editorData?.onPreview ?? false));
  }

  Future<void> startEditing() async {
    print("start editing");
    _editorData = _editorData?.copyWith(onEdit: true);
    notifyListeners();
  }

  Future<void> saveFile() async {
    print("close editing");
    _editorData = _editorData?.copyWith(onEdit: false);
    notifyListeners();
  }

  Future<void> updateMarkdown(String arg) async {
    final currentRecord = _editorData!.recordDatas;
    currentRecord.add(arg);
    print(currentRecord[1]);
    _editorData = _editorData?.copyWith(
      currentData: arg,
      recordDatas: currentRecord,
      activeRecordIdx: currentRecord.length - 1,
    );
    notifyListeners();
  }

  Future<void> undo() async {
    final currentActiveIndex = _editorData?.activeRecordIdx ?? 0;
    final updatedActiveIndex =
        currentActiveIndex == 0 ? 0 : currentActiveIndex - 1;
    print("undo $currentActiveIndex $updatedActiveIndex");
    _editorData = _editorData?.copyWith(
        currentData: _editorData?.recordDatas[updatedActiveIndex],
        activeRecordIdx: updatedActiveIndex);
    notifyListeners();
  }

  Future<void> redo() async {
    final currentActiveIndex =
        _editorData?.activeRecordIdx ?? _editorData!.recordDatas.length - 1;
    final updatedActiveIndex =
        currentActiveIndex == _editorData!.recordDatas.length - 1
            ? _editorData!.recordDatas.length - 1
            : currentActiveIndex + 1;
    _editorData = _editorData?.copyWith(
        currentData: _editorData?.recordDatas[updatedActiveIndex],
        activeRecordIdx: updatedActiveIndex);
    notifyListeners();
  }

  Future<void> updateRecordEditor() async {
    // final lastRecord = _editorData?.recordDatas;
    // final currentData = _editorData?.currentData;
    // final currentRecordIdx = (_editorData?.recordDatas.length ?? 0) - 1;

    // lastRecord?.removeRange(currentData ?? "-");

    // _editorData = _editorData?.copyWith(recordDatas: lastRecord);
  }
}
