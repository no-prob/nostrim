import 'dart:io';
import 'dart:async';
import 'dart:core';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


class Npubs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get pubkey => text().withLength(min: 0, max: 64)();
}

class NpubEntries extends Table {
  IntColumn get contact => integer().references(Contacts, #id)();
  IntColumn get npub => integer().references(Npubs, #id)();
}

class Contacts extends Table {
  /// Can have multiple users, only one active at a time. A user
  /// can have multiple npubs
  /// isLocal:
  ///   When false, then this is in the contacts list and not a local user
  ///   When true, then this is one of the user "accounts"
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 0, max: 64)();
  BoolColumn get isLocal => boolean()();
}

class Events extends Table {
  /// All events table
  IntColumn get columnId => integer().autoIncrement()();
  TextColumn get id => text().withLength(min: 0, max: 64)();
  TextColumn get pubkey => text().withLength(min: 64, max: 64)();
  DateTimeColumn get createdAt => dateTime()
        .check(createdAt.isBiggerThan(Constant(DateTime(1950))))
              .withDefault(currentDateAndTime)();
  IntColumn get kind => integer()();
  TextColumn get sig => text().withLength(min: 0, max: 128)();
  TextColumn get raw => text().withLength(min: 0, max: 2048)();
}
