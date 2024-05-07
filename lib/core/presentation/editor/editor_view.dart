import 'package:file_io_simple/core/domain/entities/editor_tools.dart';
import 'package:file_io_simple/core/domain/entities/notes.dart';
import 'package:file_io_simple/core/presentation/editor/providers/editor_provider.dart';
import 'package:file_io_simple/core/presentation/editor/widgets/edit_topbar.dart';
import 'package:file_io_simple/core/presentation/editor/widgets/editor_field.dart';
import 'package:file_io_simple/core/presentation/editor/widgets/preview_field.dart';
import 'package:file_io_simple/core/presentation/editor/widgets/toolbar_editor.dart';
import 'package:file_io_simple/core/presentation/editor/widgets/vertical_devider_split_mode.dart';
import 'package:file_io_simple/core/presentation/widgets/alert_popup.dart';
import 'package:file_io_simple/core/utils/helper/image_picker_helper.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class EditorView extends StatefulWidget {
  static const String route = "editor_route";
  final Note? note;
  static const _padding = EdgeInsets.only(left: 24, right: 24, top: 24);

  const EditorView({super.key, this.note});

  @override
  State<EditorView> createState() => _EditorViewState();
}

class _EditorViewState extends State<EditorView> {
  final TextEditingController textEditingController = TextEditingController();
  final focusNode = FocusNode();

  double posY = 0.0;

  Future<Note> readMarkdownFile() async {
    try {
      final fileId = widget.note?.id.replaceAll(".md", "") ?? "";
      final String contents =
          await Provider.of<EditorProvider>(context, listen: false)
              .readNoteContentStr(fileId);
      String filename = path.basename(fileId);
      return Note(
          id: filename.replaceAll(".md", ""),
          data: contents,
          created: DateTime.now()); //TODO: replace this create datetime
    } catch (e) {
      // If encountering an error, return 0.
      print(e);
      rethrow;
    }
  }

  toggleBold() {
    final baseOffset = textEditingController.selection.baseOffset;
    final extentOffset = textEditingController.selection.extentOffset;
    final selectedText =
        textEditingController.text.substring(baseOffset, extentOffset);
    RegExp regex = RegExp(r'^\*\*(.*?)\*\*$');
    final replaced = textEditingController.text.replaceRange(
        baseOffset,
        extentOffset,
        regex.hasMatch(selectedText)
            ? selectedText.replaceAll("**", "")
            : "**$selectedText**");
    textEditingController.text = replaced;
    Provider.of<EditorProvider>(context, listen: false)
        .updateMarkdown(replaced);
  }

  @override
  void initState() {
    super.initState();
    final bool isCreateNewFile = widget.note == null ? true : false;

    Future.microtask(() async {
      textEditingController.value = TextEditingValue(
        text: isCreateNewFile ? "" : (await readMarkdownFile()).data,
      );
      Provider.of<EditorProvider>(context, listen: false).initializeEditor(Note(
        id: isCreateNewFile ? const Uuid().v4() : (await readMarkdownFile()).id,
        data: isCreateNewFile ? "" : (await readMarkdownFile()).data,
        created: isCreateNewFile
            ? DateTime.now()
            : (await readMarkdownFile()).created,
      ));
      if (isCreateNewFile) {
        Provider.of<EditorProvider>(context, listen: false)
            .startEditing(textEditingController);
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
                        importImg: () async {
                          final imagePickerHelper = ImagePickerHelper();
                          final path = await imagePickerHelper.pickImagePath();
                          print(path);
                          provider.addImage(path);
                        },
                        listDots: () {},
                        listNumber: () {},
                        checkBox: () {},
                        togglePreview: () => provider.togglePreview(),
                        toggleSplitView: () => provider.toggleSplitMode(),
                        toggleBold: toggleBold,
                        canRedo: provider.editorData?.redoAble ?? false,
                        canUndo: provider.editorData?.undoAble ?? false,
                      ),
                      onPressedSave: () {
                        provider.saveFile();
                      })
                  : EditTopBar(
                      onPressed: () =>
                          provider.startEditing(textEditingController)),
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
