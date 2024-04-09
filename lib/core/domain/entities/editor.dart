class EditorDataEntity {
  final List<String> recordDatas;
  final String currentData;
  final bool onEdit;
  final int activeRecordIdx;
  final bool onPreview;
  final bool onSplitMode;
  final bool undoAble;
  final bool redoAble;

  EditorDataEntity({
    required this.recordDatas,
    required this.currentData,
    required this.activeRecordIdx,
    required this.onEdit,
    required this.onPreview,
    required this.onSplitMode,
    required this.undoAble,
    required this.redoAble,
  });

  EditorDataEntity copyWith({
    List<String>? recordDatas,
    String? currentData,
    bool? onEdit,
    bool? onPreview,
    bool? onSplitMode,
    bool? undoAble,
    bool? redoAble,
    int? activeRecordIdx,
  }) =>
      EditorDataEntity(
        recordDatas: recordDatas ?? this.recordDatas,
        currentData: currentData ?? this.currentData,
        activeRecordIdx: activeRecordIdx ?? this.activeRecordIdx,
        onEdit: onEdit ?? this.onEdit,
        onPreview: onPreview ?? this.onPreview,
        onSplitMode: onSplitMode ?? this.onSplitMode,
        undoAble: undoAble ?? this.undoAble,
        redoAble: redoAble ?? this.redoAble,
      );
}
