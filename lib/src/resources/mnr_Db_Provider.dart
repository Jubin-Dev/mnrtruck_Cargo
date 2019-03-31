import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
//import 'dart:async';
//import 'package:m_n_r/src/models/usermodel.dart';

class MnrDbProvider {
  Database db;

  init() async {
    
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "mnr.db");
    db = await openDatabase(path,
    version: 1,
    onCreate: (Database newDb, int version) {
      newDb.execute("""
        CREATE TABLE BRANCHES(
          branchID INTEGER PRIMARY KEY,
          branchCode TEXT,
          branchName TEXT,
          companyCode TEXT
        )
      """);

      newDb.execute("""
        CREATE TABLE YARDS(
        yardCode TEXT,
        description TEXT,    
        branchID INTEGER,
        branchCode TEXT
        )
      """);
    });
  }

  fetchBranches() async {
    final branches  = await db.query("BRANCHES", 
    columns: null );

    if (branches.length > 0)
    {

    }
  }

  fetchYards(int brId) async {
    final yards = await db.query("YARDS",
    columns:["yardCode", "description"],
    where: "branchID = ?",
    whereArgs: [brId],
    );

    if (yards.length > 0) {
      
    }
  }

}