import 'package:file_io_simple/core/domain/entities/editor_tools.dart';
import 'package:file_io_simple/core/domain/entities/notes.dart';
import 'package:file_io_simple/core/presentation/editor/providers/editor_provider.dart';
import 'package:file_io_simple/core/presentation/editor/widgets/edit_topbar.dart';
import 'package:file_io_simple/core/presentation/editor/widgets/editor_field.dart';
import 'package:file_io_simple/core/presentation/editor/widgets/toolbar_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:provider/provider.dart';

class EditorView extends StatefulWidget {
  static const String route = "editor_route";
  static const _padding = EdgeInsets.only(left: 24, right: 24, top: 24);

  const EditorView({super.key});

  @override
  State<EditorView> createState() => _EditorViewState();
}

class _EditorViewState extends State<EditorView> {
  final TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      textEditingController.value = const TextEditingValue(text: _markdownData);
      Provider.of<EditorProvider>(context, listen: false).initializeEditor(
          Notes(id: "1", data: _markdownData, created: DateTime.now()));
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<EditorProvider>(
        builder: (context, EditorProvider provider, _) => Column(
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
                    ),
                    onPressedSave: () => provider.saveFile())
                : EditTopBar(onPressed: () => provider.startEditing()),
            Expanded(
              flex: 1,
              child: Container(
                padding: EditorView._padding,
                child: !(provider.editorData?.onPreview ?? false) &&
                        (provider.editorData?.onEdit ?? false)
                    ? EditorField(
                        onUpdate: (value) => provider.updateMarkdown(value),
                        textEditingController: textEditingController,
                      )
                    : Markdown(
                        selectable: true,
                        extensionSet: md.ExtensionSet(
                          md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                          <md.InlineSyntax>[
                            md.EmojiSyntax(),
                            ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
                          ],
                        ),
                        data: provider.editorData?.currentData ?? "-",
                      ),
              ),
            ),
          ],
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
