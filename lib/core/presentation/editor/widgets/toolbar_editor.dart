import 'package:file_io_simple/core/domain/entities/editor_tools.dart';
import 'package:flutter/material.dart';

class ToolbarEditor extends StatefulWidget {
  static const _padding = EdgeInsets.only(left: 24, right: 24, top: 24);
  final EditorTools editorTools;
  final Function() onPressedSave;
  const ToolbarEditor({
    super.key,
    required this.onPressedSave,
    required this.editorTools,
  });

  @override
  State<ToolbarEditor> createState() => _ToolbarEditorState();
}

class _ToolbarEditorState extends State<ToolbarEditor> {
  bool _openMoreButtons = false;

  void toggleMoreButtons() {
    setState(() {
      _openMoreButtons = !_openMoreButtons;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ToolbarEditor._padding,
      child: Column(
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () => widget.onPressedSave(),
                child: const Row(
                  children: [
                    Text("Save"),
                    SizedBox(width: 8.0),
                    Icon(
                      Icons.save,
                    )
                  ],
                ),
              ),
              const Spacer(flex: 1),
              IconButton(onPressed: () {}, icon: const Icon(Icons.preview)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.splitscreen)),
            ],
          ),
          Container(
            color: Colors.blueGrey[50],
            child: Row(
              children: [
                if (!_openMoreButtons) ...mainButtons() else ..._moreButtons(),
                const Spacer(flex: 1),
                IconButton(
                    onPressed: toggleMoreButtons,
                    icon: Icon(_openMoreButtons
                        ? Icons.chevron_left
                        : Icons.chevron_right)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> mainButtons() => [
        IconButton(
            onPressed: () => widget.editorTools.undo(),
            icon: const Icon(Icons.undo)),
        IconButton(
            onPressed: () => widget.editorTools.redo(),
            icon: const Icon(Icons.redo)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.format_bold)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.format_italic)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.code)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.image)),
      ];

  List<Widget> _moreButtons() => [
        IconButton(onPressed: () {}, icon: const Icon(Icons.list)),
        IconButton(
            onPressed: () {},
            icon: const Icon(Icons.format_list_numbered_outlined)),
        IconButton(
            onPressed: () {}, icon: const Icon(Icons.check_box_outlined)),
      ];
}
