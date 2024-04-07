class EditorDataEntity {
  final List<String> recordDatas;
  final String currentData;
  final bool onEdit;
  final int activeRecordIdx;
  final bool onPreview;

  EditorDataEntity({
    required this.recordDatas,
    required this.currentData,
    required this.activeRecordIdx,
    required this.onEdit,
    required this.onPreview,
  });

  EditorDataEntity copyWith({
    List<String>? recordDatas,
    String? currentData,
    bool? onEdit,
    bool? onPreview,
    int? activeRecordIdx,
  }) =>
      EditorDataEntity(
        recordDatas: recordDatas ?? this.recordDatas,
        currentData: currentData ?? this.currentData,
        activeRecordIdx: activeRecordIdx ?? this.activeRecordIdx,
        onEdit: onEdit ?? this.onEdit,
        onPreview: onPreview ?? this.onPreview,
      );
}
