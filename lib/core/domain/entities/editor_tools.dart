class EditorTools {
  final Function() undo;
  final Function() redo;
  final Function() importImg;
  final Function() listDots;
  final Function() listNumber;
  final Function() checkBox;
  final Function() togglePreview;
  final Function() toggleSplitView;

  EditorTools({
    required this.undo,
    required this.redo,
    required this.importImg,
    required this.listDots,
    required this.listNumber,
    required this.checkBox,
    required this.togglePreview,
    required this.toggleSplitView,
  });
}
