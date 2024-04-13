import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notepad/ui/add_note/screen/add_note_screen.dart';
import 'package:notepad/ui/edit_note/screen/edit_note_screen.dart';
import 'package:notepad/ui/login/screen/login_screen.dart';
import 'package:notepad/ui/profile/screen/profile_screen.dart';
import 'package:notepad/ui/home/manager/home_screen_cubit.dart';
import 'package:notepad/ui/home/manager/home_screen_state.dart';
import 'package:notepad/utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final cubit = HomeScreenCubit();

  @override
  void initState() {
    super.initState();
    cubit.getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            navToNoteScreen();
          },
          backgroundColor: secondColor,
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Row(
            children: [
              const Text(
                "Notes",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: secondColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: IconButton(
                  onPressed: () {
                    navToProfileScreen();
                  },
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  icon: const Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Container(
                decoration: BoxDecoration(
                  color: secondColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: IconButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: BlocBuilder<HomeScreenCubit, HomeScreenState>(
          builder: (context, state) {
            return ListView.builder(
              itemCount: cubit.notes.length,
              itemBuilder: (context, index) {
                return noteItemBuilder(index);
              },
            );
          },
        ),
      ),
    );
  }

  Widget noteItemBuilder(int index) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: cubit.notes[index].important,
                      child: Text(
                        "Important",
                        style: TextStyle(
                          color: Colors.red[400],
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      cubit.notes[index].title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      cubit.notes[index].content,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: (cubit.notes[index].link) == "" ? false : true,
                child: Expanded(
                  flex: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(cubit.notes[index].link),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    cubit.deleteNote(index);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                  ),
                  icon: const Icon(Icons.delete),
                  label: const Text("Delete"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    navToEditScreen(index);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondColor,
                  ),
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void navToProfileScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfileScreen(),
      ),
    ).then((value) => cubit.getNotes());
  }

  void navToNoteScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddNoteScreen(),
      ),
    ).then((value) => cubit.addNote(value));
  }

  void navToEditScreen(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditNoteScreen(note: cubit.notes[index]),
      ),
    ).then((value) => cubit.editNote(index, value));
  }
}
