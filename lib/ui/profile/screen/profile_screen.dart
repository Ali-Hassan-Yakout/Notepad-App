import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notepad/ui/login/screen/login_screen.dart';
import 'package:notepad/ui/profile/manager/profile_screen_cubit.dart';
import 'package:notepad/ui/profile/manager/profile_screen_state.dart';
import 'package:notepad/utils/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final cubit = ProfileScreenCubit();

  @override
  void initState() {
    super.initState();
    cubit.getUserData();
  }

  @override
  void dispose() {
    super.dispose();
    cubit.nameController.dispose();
    cubit.phoneController.dispose();
    cubit.emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocListener<ProfileScreenCubit, ProfileScreenState>(
        listener: (context, state) {
          if (state is DeleteUserData) {
            navToLoginScreen();
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: mainColor,
          body: BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
            buildWhen: (previous, current) => current is UpdateUi,
            builder: (context, state) {
              return SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          if (cubit.imageLink.isEmpty)
                            InkWell(
                              borderRadius: BorderRadius.circular(30),
                              onTap: () => cubit.pickImage(),
                              child: const CircleAvatar(
                                radius: 30,
                                backgroundColor: secondColor,
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          else
                            BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
                              buildWhen: (previous, current) =>
                                  current is LoadingChange,
                              builder: (context, state) {
                                return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    InkWell(
                                      borderRadius: BorderRadius.circular(30),
                                      onTap: () => cubit.pickImage(),
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundColor: secondColor,
                                        backgroundImage:
                                            NetworkImage(cubit.imageLink),
                                      ),
                                    ),
                                    Visibility(
                                      visible: cubit.loading,
                                      child: const CircularProgressIndicator(
                                        color: secondColor,
                                      ),
                                    )
                                  ],
                                );
                              },
                            ),
                          const SizedBox(height: 10),
                          const Text(
                            "Profile",
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
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
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
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
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
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
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
                                    enabled: false,
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
                                      disabledBorder: OutlineInputBorder(
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
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  height: 45,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      cubit.saveUserData();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black),
                                    child: const Text(
                                      "Update",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: double.infinity,
                                  height: 45,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => alertDialog(),
                                        barrierDismissible: true,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    child: const Text(
                                      "Delete Account",
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
              );
            },
          ),
        ),
      ),
    );
  }

  Widget alertDialog() {
    return AlertDialog(
      title: const Text('Delete Account?'),
      content: const Text('This will permanently delete your account.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'CANCEL',
            style: TextStyle(color: Colors.black),
          ),
        ),
        TextButton(
          onPressed: () async {
            await cubit.deleteUserData();
            navToLoginScreen();
          },
          child: const Text(
            'ACCEPT',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
      backgroundColor: mainColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  void navToLoginScreen() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (route) => false,
    );
  }
}
