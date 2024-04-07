import 'package:file_io_simple/core/domain/entities/editor_tools.dart';
import 'package:file_io_simple/core/domain/entities/notes.dart';
import 'package:file_io_simple/core/presentation/editor/providers/editor_provider.dart';
import 'package:file_io_simple/core/presentation/editor/widgets/edit_topbar.dart';
import 'package:file_io_simple/core/presentation/editor/widgets/editor_field.dart';
import 'package:file_io_simple/core/presentation/editor/widgets/preview_field.dart';
import 'package:file_io_simple/core/presentation/editor/widgets/toolbar_editor.dart';
import 'package:file_io_simple/core/presentation/editor/widgets/vertical_devider_split_mode.dart';
import 'package:file_io_simple/core/presentation/widgets/alert_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class EditorView extends StatefulWidget {
  static const String route = "editor_route";
  final bool isCreateNewFile;
  static const _padding = EdgeInsets.only(left: 24, right: 24, top: 24);

  const EditorView({super.key, required this.isCreateNewFile});

  @override
  State<EditorView> createState() => _EditorViewState();
}

class _EditorViewState extends State<EditorView> {
  final TextEditingController textEditingController = TextEditingController();
  final focusNode = FocusNode();

  double posY = 0.0;

  Future<String> readMarkdownFile() async {
    try {
      String contents = await rootBundle.loadString('assets/md/test.md');

      return contents;
    } catch (e) {
      // If encountering an error, return 0.
      print(e);
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      textEditingController.value = TextEditingValue(
        text: widget.isCreateNewFile ? "" : await readMarkdownFile(),
      );
      Provider.of<EditorProvider>(context, listen: false)
          .initializeEditor(Notes(
        id: const Uuid().toString(),
        data: widget.isCreateNewFile ? "" : await readMarkdownFile(),
        created: DateTime.now(),
      ));
      if (widget.isCreateNewFile) {
        Provider.of<EditorProvider>(context, listen: false).startEditing();
        focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fullHeight = MediaQuery.of(context).size.height;

    return PopScope(
      canPop: Provider.of<EditorProvider>(context).editorData?.onEdit == true
          ? false
          : true,
      onPopInvoked: (bool didPop) async {
        if (!didPop) {
          triggerAlert(
              title: "You're still in edit mode!",
              text: "Please save your work first.",
              context: context);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Consumer<EditorProvider>(
          builder: (context, EditorProvider provider, _) => Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              provider.editorData?.onEdit ?? false
                  ? ToolbarEditor(
                      editorTools: EditorTools(
                        undo: () {
                          provider.undo();
                          textEditingController.value = TextEditingValue(
                              text: provider.editorData?.currentData ?? "-");
                        },
                        redo: () {
                          provider.redo();
                          textEditingController.value = TextEditingValue(
                              text: provider.editorData?.currentData ?? "-");
                        },
                        importImg: () {},
                        listDots: () {},
                        listNumber: () {},
                        checkBox: () {},
                        togglePreview: () => provider.togglePreview(),
                        toggleSplitView: () => provider.toggleSplitMode(),
                      ),
                      onPressedSave: () => provider.saveFile())
                  : EditTopBar(onPressed: () => provider.startEditing()),
              Expanded(
                flex: (provider.editorData?.onSplitMode == true) ? 0 : 1,
                child: Container(
                  height: (provider.editorData?.onSplitMode == true)
                      ? fullHeight / 2 + (32 + posY)
                      : null,
                  padding: EditorView._padding,
                  child: (provider.editorData?.onPreview == false) &&
                          (provider.editorData?.onEdit == true)
                      ? EditorField(
                          focusNode: focusNode,
                          onUpdate: (value) => provider.updateMarkdown(value),
                          textEditingController: textEditingController,
                        )
                      : PreviewField(
                          data: provider.editorData?.currentData ?? "-",
                        ),
                ),
              ),
              if (provider.editorData?.onSplitMode == true)
                VerticalDividerSplitMode(
                  updateVerticalPosition: (value) {
                    setState(() {
                      posY += value;
                    });
                  },
                  fullHeightScreen: fullHeight,
                ),
              if (provider.editorData?.onSplitMode == true)
                Expanded(
                  child: Container(
                    padding: EditorView._padding,
                    child: PreviewField(
                      data: provider.editorData?.currentData ?? "-",
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

const String _markdownData = """
# Minimal Markdown Test
---
😀
This is a simple Markdown test. Provide a text string with Markdown tags
to the Markdown widget and it will display the formatted output in a
scrollable widget.
## Section 1
Maecenas eget **arcu egestas**, mollis ex vitae, posuere magna. Nunc eget
aliquam tortor. Vestibulum porta sodales efficitur. Mauris interdum turpis
eget est condimentum, vitae porttitor diam ornare.
### Subsection A
Sed et massa finibus, blandit massa vel, vulputate velit. Vestibulum vitae
venenatis libero. **__Curabitur sem lectus, feugiat eu justo in, eleifend
accumsan ante.__** Sed a fermentum elit. Curabitur sodales metus id mi
ornare, in ullamcorper magna congue.
""";
