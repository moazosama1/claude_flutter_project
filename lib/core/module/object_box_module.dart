import 'package:injectable/injectable.dart';
import 'package:objectbox/objectbox.dart';

import '../../local/object_box.dart';

/// Registers the ObjectBox [Store] so any data source can inject it directly.
///
/// - [provideObjectBoxDatabase] runs the async `openStore` once at startup
///   thanks to `@preResolve` — `configureDependencies()` awaits it.
/// - [provideStore] exposes the inner [Store] so callers don't need to know
///   about the wrapper.
@module
abstract class ObjectBoxModule {
  @preResolve
  @lazySingleton
  Future<ObjectBoxDatabase> provideObjectBoxDatabase() =>
      ObjectBoxDatabase.create();

  @lazySingleton
  Store provideStore(ObjectBoxDatabase db) => db.store;
}
