import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notepad/ui/profile/manager/profile_screen_state.dart';
import 'package:notepad/utils/app_toast.dart';

class ProfileScreenCubit extends Cubit<ProfileScreenState> {
  ProfileScreenCubit() : super(ProfileScreenInitial());
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final firestore = FirebaseFirestore.instance;
  final fireAuth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  String imageLink = '';
  bool loading = false;

  void saveUserData() {
    String userId = fireAuth.currentUser!.uid;
    firestore.collection("users").doc(userId).update({
      'name': nameController.text,
      'phone': phoneController.text,
    }).then((value) {
      displayToast("Update successful");
    }).catchError((error) {
      displayToast(error);
    });
  }

  void getUserData() {
    String userId = fireAuth.currentUser!.uid;
    firestore.collection('users').doc(userId).get().then((value) {
      updateUi(value.data()!);
    }).catchError((error) {
      displayToast(error);
    });
  }

  void updateUi(Map<String, dynamic> data) {
    nameController.text = data['name'];
    phoneController.text = data['phone'];
    emailController.text = data['email'];
    imageLink = data['imageLink'];
    emit(UpdateUi());
  }

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    final image = File(file!.path);
    uploadImage(image);
  }

  void uploadImage(File image) {
    loading = true;
    emit(LoadingChange());
    String userId = fireAuth.currentUser!.uid;
    storage.ref('profileImages/$userId').putFile(image).then(
      (value) {
        getImageUrl();
      },
    ).catchError(
      (error) {
        loading = false;
        emit(LoadingChange());
      },
    );
  }

  void getImageUrl() {
    String userId = fireAuth.currentUser!.uid;
    storage.ref('profileImages/$userId').getDownloadURL().then(
      (value) {
        imageLink = value;
        loading = false;
        emit(LoadingChange());
        saveUserImage();
      },
    ).catchError(
      (error) {},
    );
  }

  void saveUserImage() {
    String userId = fireAuth.currentUser!.uid;
    firestore.collection('users').doc(userId).update({
      'imageLink': imageLink,
    });
  }

  Future<void> deleteUserData() async {
    String userId = fireAuth.currentUser!.uid;
    await firestore.collection('users').doc(userId).delete();
    await firestore
        .collection('notes')
        .where('userId', isEqualTo: userId)
        .get()
        .then(
      (value) {
        for (var doc in value.docs) {
          doc.reference.delete();
        }
        displayToast("Delete Successful");
        emit(DeleteUserData());
      },
    ).catchError((error) {
      displayToast(error);
    });
    await storage.ref("noteImages/$userId").listAll().then((value) {
      for (var element in value.items) {
        storage.ref(element.fullPath).delete();
      }
    });
    await storage.ref("profileImages/$userId").delete().catchError((error) {});
    await fireAuth.currentUser!.delete();
  }
}
