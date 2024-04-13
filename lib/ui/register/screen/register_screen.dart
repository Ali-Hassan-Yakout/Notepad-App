import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notepad/ui/app_manager/app_manager_cubit.dart';
import 'package:notepad/ui/app_manager/app_manager_state.dart';
import 'package:notepad/ui/register/manager/register_screen_cubit.dart';
import 'package:notepad/ui/register/manager/register_screen_state.dart';
import 'package:notepad/utils/app_toast.dart';
import 'package:notepad/utils/colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final cubit = RegisterScreenCubit();

  @override
  void dispose() {
    super.dispose();
    cubit.nameController.dispose();
    cubit.phoneController.dispose();
    cubit.emailController.dispose();
    cubit.passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocListener<RegisterScreenCubit, RegisterScreenState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            onRegisterSuccess();
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: mainColor,
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        "Welcome",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 40,
                    ),
                    decoration: const BoxDecoration(
                      color: secondColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30),
                      ),
                    ),
                    child: Form(
                      key: cubit.formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Name",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: mainColor,
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                              ),
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Name required!";
                                  }
                                  return null;
                                },
                                textInputAction: TextInputAction.next,
                                controller: cubit.nameController,
                                cursorColor: secondColor,
                                style: const TextStyle(color: Colors.black),
                                decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: secondColor)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: secondColor)),
                                  errorBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.red)),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.red)),
                                ),
                              ),
                            ),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Phone",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: mainColor,
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                              ),
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Phone required!";
                                  }
                                  return null;
                                },
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.phone,
                                maxLength: 11,
                                controller: cubit.phoneController,
                                cursorColor: secondColor,
                                style: const TextStyle(color: Colors.black),
                                decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: secondColor)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: secondColor)),
                                  errorBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.red)),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.red)),
                                ),
                              ),
                            ),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Email",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: mainColor,
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                              ),
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Email required!";
                                  }
                                  return null;
                                },
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                controller: cubit.emailController,
                                cursorColor: secondColor,
                                style: const TextStyle(color: Colors.black),
                                decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: secondColor)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: secondColor)),
                                  errorBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.red)),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.red)),
                                ),
                              ),
                            ),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Password",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: mainColor,
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                              ),
                              child: BlocBuilder<AppManagerCubit, AppManagerState>(
                                buildWhen: (previous, current) => current is ToggleChange,
                                builder: (context, state) {
                                  return TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Password required!";
                                      }
                                      return null;
                                    },
                                    textInputAction: TextInputAction.done,
                                    obscureText: cubit.obscure,
                                    controller: cubit.passwordController,
                                    cursorColor: secondColor,
                                    style: const TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              cubit.obscure = !cubit.obscure;
                                            });
                                          },
                                          icon: Icon(
                                            cubit.obscure
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: secondColor,
                                          )),
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide:
                                          BorderSide(color: secondColor)),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide:
                                          BorderSide(color: secondColor)),
                                      errorBorder: const OutlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Colors.red)),
                                      focusedErrorBorder: const OutlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Colors.red)),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 45,
                              child: ElevatedButton(
                                onPressed: () {
                                  cubit.signUp();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black),
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onRegisterSuccess() {
    cubit.saveUserData();
    displayToast("Account created!");
    Navigator.pop(context);
  }
}
