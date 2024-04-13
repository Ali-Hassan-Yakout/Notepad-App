import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notepad/ui/password_reset/manager/password_reset_screen_state.dart';
import 'package:notepad/utils/app_toast.dart';

class PasswordResetScreenCubit extends Cubit<PasswordResetScreenState> {
  PasswordResetScreenCubit() : super(PasswordResetScreenInitial());
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  void resetPassword() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    String email = emailController.text;
    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: email,
    );
    displayToast("Password reset email sent to your account");
    emit(PasswordResetSuccess());
  }
}
