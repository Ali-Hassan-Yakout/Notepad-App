import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notepad/models/note.dart';
import 'package:notepad/ui/add_note/manager/add_note_screen_state.dart';

class AddNoteScreenCubit extends Cubit<AddNoteScreenState> {
  AddNoteScreenCubit() : super(AddNoteScreenInitial());
  final firestore = FirebaseFirestore.instance;
  final fireAuth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool checkedValue = false;
  String imageLink = "";
  String noteId = "";
  Note note = Note('', '', '', '', false);

  void addNote() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    if (noteId == '') {
      noteId = DateTime.now().millisecondsSinceEpoch.toString();
    }
    note = Note(
      noteId,
      titleController.text,
      contentController.text,
      imageLink,
      checkedValue,
    );
    firestore.collection('notes').doc(noteId).set(note.toMap());
    emit(AddNoteSuccess());
  }

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    final image = File(file!.path);
    uploadImage(image);
  }

  void uploadImage(File image) {
    String userId = fireAuth.currentUser!.uid;
    noteId = DateTime.now().millisecondsSinceEpoch.toString();
    storage.ref("noteImages/$userId/$noteId").putFile(image).then((value) {
      getImageUrl();
    }).catchError((error) {});
  }

  void getImageUrl() {
    String userId = fireAuth.currentUser!.uid;
    storage.ref("noteImages/$userId/$noteId").getDownloadURL().then((value) {
      imageLink = value;
      emit(ImageUploadSuccess());
    }).catchError((error) {});
  }
}
