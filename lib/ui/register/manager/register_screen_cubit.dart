import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notepad/ui/register/manager/register_screen_state.dart';
import 'package:notepad/utils/app_toast.dart';

class RegisterScreenCubit extends Cubit<RegisterScreenState> {
  RegisterScreenCubit() : super(RegisterScreenInitial());
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firestore = FirebaseFirestore.instance;
  final fireAuth = FirebaseAuth.instance;
  bool obscure = true;

  void signUp() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    String email = emailController.text;
    String password = passwordController.text;
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        displayToast('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        displayToast('The account already exists for that email.');
      }
    } catch (e) {
      displayToast(e.toString());
    }
  }

  void saveUserData() {
    String userId = fireAuth.currentUser!.uid;
    firestore.collection("users").doc(userId).set({
      'userId': userId,
      'imageLink': "",
      'name': nameController.text,
      'phone': phoneController.text,
      'email': emailController.text,
    });
  }
}
