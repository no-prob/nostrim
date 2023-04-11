import 'dart:io';
import 'dart:async';
import 'dart:core';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


class Todos extends Table {
    IntColumn get id => integer().autoIncrement()();
    TextColumn get title => text().withLength(min: 0, max: 64)();
    TextColumn get content => text().named('body')();
    IntColumn get category => integer().nullable()();
}

@DataClassName('Category')
class Categories extends Table {
    IntColumn get id => integer().autoIncrement()();
    TextColumn get description => text()();
}

