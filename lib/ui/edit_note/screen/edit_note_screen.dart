import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notepad/models/note.dart';
import 'package:notepad/ui/app_manager/app_manager_cubit.dart';
import 'package:notepad/ui/app_manager/app_manager_state.dart';
import 'package:notepad/ui/edit_note/manager/edit_note_screen_cubit.dart';
import 'package:notepad/ui/edit_note/manager/edit_note_screen_state.dart';
import 'package:notepad/utils/colors.dart';

class EditNoteScreen extends StatefulWidget {
  final Note note;

  const EditNoteScreen({super.key, required this.note});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final cubit = EditNoteScreenCubit();

  @override
  void initState() {
    super.initState();
    cubit.titleController.text = widget.note.title;
    cubit.contentController.text = widget.note.content;
    cubit.imageLink = widget.note.link;
    cubit.checkedValue = widget.note.important;
    cubit.homeNote = widget.note;
  }

  @override
  void dispose() {
    super.dispose();
    cubit.titleController.dispose();
    cubit.contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocListener<EditNoteScreenCubit, EditNoteScreenState>(
        listener: (context, state) {
          if (state is EditNoteSuccess) {
            onEditNoteSuccess();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Colors.white,
            title: const Text(
              "Edit Note",
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: cubit.formKey,
              child: ListView(
                children: [
                  Visibility(
                    visible: cubit.imageLink == '' ? false : true,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      height: MediaQuery.of(context).size.height * 1 / 3,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: mainColor,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child:
                          BlocBuilder<EditNoteScreenCubit, EditNoteScreenState>(
                        buildWhen: (previous, current) =>
                            current is ImageUploadSuccess,
                        builder: (context, state) {
                          return Image.network(
                            cubit.imageLink,
                            fit: BoxFit.contain,
                          );
                        },
                      ),
                    ),
                  ),
                  TextFormField(
                    cursorColor: secondColor,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Title required!";
                      }
                      if (value.length < 3) {
                        return "Too short Title";
                      }
                      return null;
                    },
                    controller: cubit.titleController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: secondColor),
                      ),
                      label: Text(
                        "Title",
                        style: TextStyle(color: secondColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    cursorColor: secondColor,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Content required!";
                      }
                      if (value.length < 3) {
                        return "Too short content";
                      }
                      return null;
                    },
                    controller: cubit.contentController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: secondColor),
                      ),
                      label: Text(
                        "Content",
                        style: TextStyle(color: secondColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    decoration: const BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: BlocBuilder<AppManagerCubit, AppManagerState>(
                      builder: (context, state) {
                        return CheckboxListTile(
                          title: const Text(
                            "Important",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          activeColor: secondColor,
                          value: cubit.checkedValue,
                          onChanged: (newValue) {
                            cubit.checkedValue = newValue!;
                            BlocProvider.of<AppManagerCubit>(context)
                                .onToggleChange();
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              cubit.pickImage();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: secondColor,
                            ),
                            label: const Text(
                              "Add Image",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            icon: const Icon(Icons.image),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              cubit.editNote();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: secondColor,
                            ),
                            child: const Text(
                              "Update",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  onEditNoteSuccess() {
    Navigator.pop(context, cubit.note);
  }
}
