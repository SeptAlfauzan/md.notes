class EditorTools {
  final Function() undo;
  final Function() redo;
  final Function() importImg;
  final Function() listDots;
  final Function() listNumber;
  final Function() checkBox;

  EditorTools({
    required this.undo,
    required this.redo,
    required this.importImg,
    required this.listDots,
    required this.listNumber,
    required this.checkBox,
  });
}
