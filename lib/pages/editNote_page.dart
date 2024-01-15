import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/cubits/notes_cubit/notes_cubit.dart';
import 'package:note_app/models/note_model.dart';
import '../component/custom_textField.dart';
import '../component/edit_color_listview.dart';

class EditNotePage extends StatefulWidget {
  const EditNotePage({super.key, required this.note});

  final NoteModel note;

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  String? title;
  String? content;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Edit Note",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                widget.note.title = title ?? widget.note.title;
                widget.note.subTitle = content ?? widget.note.subTitle;
                widget.note.save();
                BlocProvider.of<NotesCubit>(context).fetchAllNotes();
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.check,
                size: 30,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 26),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomTextField(
                  onChanged: (val) {
                    title = val;
                  },
                  hint: widget.note.title,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  onChanged: (val) {
                    content = val;
                  },
                  hint: widget.note.subTitle,
                  maxLine: 5,
                ),
                const SizedBox(
                  height: 20,
                ),
                EditColorListView(
                  noteModel: widget.note,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
