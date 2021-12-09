import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:lotti/blocs/journal/journal_image_cubit.dart';
import 'package:lotti/blocs/journal/persistence_cubit.dart';
import 'package:lotti/blocs/journal/persistence_state.dart';
import 'package:lotti/theme.dart';
import 'package:lotti/widgets/journal/editor_tools.dart';
import 'package:lotti/widgets/journal/editor_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({Key? key}) : super(key: key);

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  QuillController _controller = makeController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext _context) {
    return BlocBuilder<PersistenceCubit, PersistenceState>(
        builder: (context, PersistenceState state) {
      void _save() async {
        context
            .read<PersistenceCubit>()
            .createTextEntry(entryTextFromController(_controller));

        _controller = makeController();
        FocusScope.of(context).unfocus();
      }

      return Scaffold(
        backgroundColor: AppColors.bodyBgColor,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                    child: EditorWidget(
                      controller: _controller,
                      saveFn: _save,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              child: const Icon(MdiIcons.tapeMeasure, size: 32),
              backgroundColor: AppColors.entryBgColor,
              onPressed: () {
                context.read<JournalImageCubit>().pickImageAssets(context);
              },
            ),
            const SizedBox(
              width: 16,
            ),
            FloatingActionButton(
              child: const Icon(Icons.camera_roll, size: 32),
              backgroundColor: AppColors.entryBgColor,
              onPressed: () {
                context.read<JournalImageCubit>().pickImageAssets(context);
              },
            ),
          ],
        ),
      );
    });
  }
}
