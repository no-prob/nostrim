import 'dart:io';
import 'dart:async';
import 'dart:core';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get pubkey => text().withLength(min: 0, max: 64)();
  TextColumn get name => text().withLength(min: 0, max: 64)();
}

class Events extends Table {
  IntColumn get columnId => integer().autoIncrement()();
  TextColumn get id => text().withLength(min: 0, max: 64)();
  TextColumn get pubkey => text().withLength(min: 64, max: 64)();
  DateTimeColumn get createdAt => dateTime()
        .check(createdAt.isBiggerThan(Constant(DateTime(1950))))
              .withDefault(currentDateAndTime)();
  IntColumn get kind => integer()();
  TextColumn get sig => text().withLength(min: 0, max: 128)();
}
