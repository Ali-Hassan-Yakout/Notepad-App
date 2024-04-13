import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notepad/models/note.dart';
import 'package:notepad/ui/home/manager/home_screen_state.dart';
import 'package:notepad/utils/app_toast.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  HomeScreenCubit() : super(HomeScreenInitial());
  final firestore = FirebaseFirestore.instance;
  final fireAuth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  List<Note> notes = [];

  void addNote(value) {
    if(value!=null){
      notes.add(value);
      emit(AddNoteSuccess());
    }
  }

  void deleteNote(int index) {
    String userId = fireAuth.currentUser!.uid;
    String noteId = notes[index].id;

    firestore.collection('notes').doc(noteId).delete();
    storage.ref("noteImages/$userId/$noteId").delete().catchError((error) {});
    notes.removeAt(index);
    emit(DeleteNoteSuccess());
  }

  void editNote(int index,value) {
    if(value != null){
      notes[index] = value;
      emit(EditNoteSuccess());
    }
  }

  void getNotes() async {
    notes.clear();
    String userId = FirebaseAuth.instance.currentUser!.uid;
    firestore
        .collection('notes')
        .where('userId', isEqualTo: userId)
        .get()
        .then((value) {
      for (var document in value.docs) {
        final note = Note.fromMap(document.data());
        notes.add(note);
      }
      emit(GetNoteSuccess());
    }).catchError((error) {
      displayToast(error);
    });
  }
}
