// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TodoStore on _TodoStore, Store {
  late final _$todosAtom = Atom(name: '_TodoStore.todos', context: context);

  @override
  ObservableList<Todo> get todos {
    _$todosAtom.reportRead();
    return super.todos;
  }

  @override
  set todos(ObservableList<Todo> value) {
    _$todosAtom.reportWrite(value, super.todos, () {
      super.todos = value;
    });
  }

  late final _$isSortAscendingAtom =
      Atom(name: '_TodoStore.isSortAscending', context: context);

  @override
  bool get isSortAscending {
    _$isSortAscendingAtom.reportRead();
    return super.isSortAscending;
  }

  @override
  set isSortAscending(bool value) {
    _$isSortAscendingAtom.reportWrite(value, super.isSortAscending, () {
      super.isSortAscending = value;
    });
  }

  late final _$showCompletedTasksAtom =
      Atom(name: '_TodoStore.showCompletedTasks', context: context);

  @override
  bool get showCompletedTasks {
    _$showCompletedTasksAtom.reportRead();
    return super.showCompletedTasks;
  }

  @override
  set showCompletedTasks(bool value) {
    _$showCompletedTasksAtom.reportWrite(value, super.showCompletedTasks, () {
      super.showCompletedTasks = value;
    });
  }

  late final _$searchTermAtom =
      Atom(name: '_TodoStore.searchTerm', context: context);

  @override
  String get searchTerm {
    _$searchTermAtom.reportRead();
    return super.searchTerm;
  }

  @override
  set searchTerm(String value) {
    _$searchTermAtom.reportWrite(value, super.searchTerm, () {
      super.searchTerm = value;
    });
  }

  late final _$searchResultsAtom =
      Atom(name: '_TodoStore.searchResults', context: context);

  @override
  ObservableList<Todo> get searchResults {
    _$searchResultsAtom.reportRead();
    return super.searchResults;
  }

  @override
  set searchResults(ObservableList<Todo> value) {
    _$searchResultsAtom.reportWrite(value, super.searchResults, () {
      super.searchResults = value;
    });
  }

  late final _$fetchTodosAsyncAction =
      AsyncAction('_TodoStore.fetchTodos', context: context);

  @override
  Future<void> fetchTodos() {
    return _$fetchTodosAsyncAction.run(() => super.fetchTodos());
  }

  late final _$_TodoStoreActionController =
      ActionController(name: '_TodoStore', context: context);

  @override
  void addTodo(Todo todo) {
    final _$actionInfo =
        _$_TodoStoreActionController.startAction(name: '_TodoStore.addTodo');
    try {
      return super.addTodo(todo);
    } finally {
      _$_TodoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void deleteTodo(int id) {
    final _$actionInfo =
        _$_TodoStoreActionController.startAction(name: '_TodoStore.deleteTodo');
    try {
      return super.deleteTodo(id);
    } finally {
      _$_TodoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void editTodo(int index, Todo editedTodo) {
    final _$actionInfo =
        _$_TodoStoreActionController.startAction(name: '_TodoStore.editTodo');
    try {
      return super.editTodo(index, editedTodo);
    } finally {
      _$_TodoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleCompleted(int index) {
    final _$actionInfo = _$_TodoStoreActionController.startAction(
        name: '_TodoStore.toggleCompleted');
    try {
      return super.toggleCompleted(index);
    } finally {
      _$_TodoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void sortTasksByCompletion() {
    final _$actionInfo = _$_TodoStoreActionController.startAction(
        name: '_TodoStore.sortTasksByCompletion');
    try {
      return super.sortTasksByCompletion();
    } finally {
      _$_TodoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSearchTerm(String term) {
    final _$actionInfo = _$_TodoStoreActionController.startAction(
        name: '_TodoStore.setSearchTerm');
    try {
      return super.setSearchTerm(term);
    } finally {
      _$_TodoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggle(bool value) {
    final _$actionInfo =
        _$_TodoStoreActionController.startAction(name: '_TodoStore.toggle');
    try {
      return super.toggle(value);
    } finally {
      _$_TodoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
todos: ${todos},
isSortAscending: ${isSortAscending},
showCompletedTasks: ${showCompletedTasks},
searchTerm: ${searchTerm},
searchResults: ${searchResults}
    ''';
  }
}
