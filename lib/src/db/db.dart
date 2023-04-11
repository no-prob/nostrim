import 'dart:io';
import 'dart:async';
import 'dart:core';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

part 'db.g.dart';


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

@DriftDatabase(tables: [Todos, Categories])
class MyDatabase extends _$MyDatabase {
    MyDatabase() : super(_openConnection());

    @override
    int get schemaVersion => 1;

    Future<List<Todo>> getTodoById(int id) => (select(todos)..where((t) => t.id.equals(id))).get();
    Future<List<Todo>> getzAllTodos() => select(todos).get();
    Stream<List<Todo>> watchAllTodos() => select(todos).watch();
    Future insertTodo(TodosCompanion entry) => into(todos).insert(entry);
    Future updateTodo(TodosCompanion entry) => update(todos).replace(entry);
    Future deleteTodo(todo) => delete(todos).delete(todo);
}   

LazyDatabase _openConnection() {
    return LazyDatabase(() async {
        final dbFolder = await getApplicationDocumentsDirectory();
        final file = File(join(dbFolder.path, 'db.sqlite'));
        return NativeDatabase(file);
    });
}

