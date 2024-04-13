import 'package:firebase_auth/firebase_auth.dart';

class Note {
  String _id = "";
  String _userId = "";
  String _title = "";
  String _content = "";
  String _link = "";
  bool _important = false;

  Note(this._id, this._title, this._content, this._link, this._important){
   userId = FirebaseAuth.instance.currentUser!.uid;
  }


  Note.fromMap(Map<dynamic, dynamic> data) {
    _id = data['id'];
    _userId = data['userId'];
    _title = data['title'];
    _content = data['content'];
    _link = data['link'];
    _important = data['important'];
  }
  Note.fromDatabaseMap(Map<dynamic, dynamic> data) {
    _id = data['id'];
    _userId = data['userId'];
    _title = data['title'];
    _content = data['content'];
    _link = data['link'];
    _important = data['important']==0?false:true;
  }

  String get content => _content;

  set content(String value) {
    _content = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get link => _link;

  set link(String value) {
    _link = value;
  }

  bool get important => _important;

  set important(bool value) {
    _important = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get userId => _userId;

  set userId(String value) {
    _userId = value;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'content': content,
      'link': link,
      'important': important,
    };
  }
}
