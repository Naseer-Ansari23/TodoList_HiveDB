


import 'package:hive/hive.dart';

import '../Models/NotesModel.dart';

class Boxes{

  static Box<NotesModel> getData() => Hive.box<NotesModel>('notes');

}