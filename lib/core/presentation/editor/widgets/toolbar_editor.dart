import 'package:file_io_simple/core/domain/entities/editor_tools.dart';
import 'package:file_io_simple/core/presentation/editor/providers/editor_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final dataFromProvider = Provider.of<EditorProvider>(context).editorData;
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
              IconButton(
                  onPressed: () => widget.editorTools.togglePreview(),
                  icon: Icon(dataFromProvider?.onPreview ?? true
                      ? Icons.remove_red_eye
                      : Icons.remove_red_eye_outlined),
                  color: dataFromProvider?.onPreview ?? true
                      ? Colors.blueAccent
                      : null),
              IconButton(
                  onPressed: () => widget.editorTools.toggleSplitView(),
                  icon: Icon(
                    Icons.splitscreen,
                    color: dataFromProvider?.onSplitMode ?? true
                        ? Colors.blueAccent
                        : null,
                  )),
            ],
          ),
          Container(
            color: Theme.of(context).colorScheme.secondaryContainer,
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
            disabledColor: Colors.grey.withOpacity(0.4),
            onPressed: widget.editorTools.canUndo
                ? () => widget.editorTools.undo()
                : null,
            icon: const Icon(Icons.undo)),
        IconButton(
            disabledColor: Colors.grey.withOpacity(0.4),
            onPressed: widget.editorTools.canRedo
                ? () => widget.editorTools.redo()
                : null,
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
