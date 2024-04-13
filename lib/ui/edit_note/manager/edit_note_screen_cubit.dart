import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notepad/models/note.dart';
import 'package:notepad/ui/edit_note/manager/edit_note_screen_state.dart';

class EditNoteScreenCubit extends Cubit<EditNoteScreenState> {
  EditNoteScreenCubit() : super(EditNoteScreenInitial());
  final firestore = FirebaseFirestore.instance;
  final fireAuth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String imageLink = '';
  bool checkedValue = false;
  Note homeNote = Note('', '', '', '', false);
  Note note = Note('', '', '', '', false);

  void editNote() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    note = Note(
      homeNote.id,
      titleController.text,
      contentController.text,
      imageLink,
      checkedValue,
    );
    firestore.collection('notes').doc(homeNote.id).update(note.toMap());
    emit(EditNoteSuccess());
  }

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    final image = File(file!.path);
    uploadImage(image);
  }

  void uploadImage(File image) {
    String userId = fireAuth.currentUser!.uid;
    storage
        .ref("noteImages/$userId/${homeNote.id}")
        .putFile(image)
        .then((value) {
      getImageUrl();
    }).catchError((error) {});
  }

  void getImageUrl() {
    String userId = fireAuth.currentUser!.uid;
    storage
        .ref("noteImages/$userId/${homeNote.id}")
        .getDownloadURL()
        .then((value) {
      imageLink = value;
      emit(ImageUploadSuccess());
    }).catchError((error) {});
  }
}
