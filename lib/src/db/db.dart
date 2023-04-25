import 'dart:io';
import 'dart:async';
import 'dart:core';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'models.dart';
part 'db.g.dart';


class User {
  final Contact contact;
  final List<Npub> npubs;

  User(this.contact, this.npubs);
}


@DriftDatabase(tables: [Contacts, Npubs, Events])
class AppDatabase extends _$AppDatabase {
    AppDatabase() : super(_openConnection());

    @override
    int get schemaVersion => 1;

}   

LazyDatabase _openConnection() {
    return LazyDatabase(() async {
        final dbFolder = await getApplicationDocumentsDirectory();
        final file = File(join(dbFolder.path, 'nostrim.sqlite'));
        return NativeDatabase(file);
    });
}

final AppDatabase database = AppDatabase();
