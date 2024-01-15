import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:note_app/component/add_color_listview.dart';
import 'package:note_app/component/custom_textField.dart';
import 'package:note_app/constants.dart';
import 'package:note_app/cubits/add_note_cubit/add_note_cubit.dart';
import 'package:note_app/cubits/notes_cubit/notes_cubit.dart';
import 'package:note_app/models/note_model.dart';

class AddNoteBottomSheet extends StatefulWidget {
  const AddNoteBottomSheet({super.key});

  @override
  State<AddNoteBottomSheet> createState() => _AddNoteBottomSheetState();
}

class _AddNoteBottomSheetState extends State<AddNoteBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String? title;
  String? subTitle;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddNoteCubit(),
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 26,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 26),
        child: SingleChildScrollView(
          child: BlocConsumer<AddNoteCubit, AddNoteState>(
            listener: (context, state) {
              if (state is AddNoteSuccess) {
                BlocProvider.of<NotesCubit>(context).fetchAllNotes();
                Navigator.pop(context);
              }
              if (state is AddNoteFailure) {
                print('Failed ${state.errMessage}');
              }
            },
            builder: (context, state) {
              return AbsorbPointer(
                absorbing: state is AddNoteLoading ? true : false,
                child: Form(
                  key: formKey,
                  autovalidateMode: autovalidateMode,
                  child: Column(
                    children: [
                      CustomTextField(
                        hint: "Title",
                        onSaved: (val) {
                          title = val;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextField(
                        hint: "Content",
                        maxLine: 5,
                        onSaved: (val) {
                          subTitle = val;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const AddColorListView(),
                      const SizedBox(
                        height: 32,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: BlocBuilder<AddNoteCubit, AddNoteState>(
                          builder: (context, state) {
                            return MaterialButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();
                                  BlocProvider.of<AddNoteCubit>(context)
                                      .addNote(
                                    NoteModel(
                                      title: title!,
                                      subTitle: subTitle!,
                                      date: DateFormat('dd-MM-yyyy')
                                          .format(DateTime.now()),
                                      //     date: DateTime.now().toString(),
                                      color: Colors.orange.value,
                                    ),
                                  );
                                } else {
                                  autovalidateMode = AutovalidateMode.always;
                                }
                              },
                              child: state is AddNoteLoading == true
                                  ? const CircularProgressIndicator(
                                      color: Colors.black,
                                    )
                                  : const Text(
                                      "Add",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
