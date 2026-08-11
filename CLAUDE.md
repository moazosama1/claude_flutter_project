# Project: initialize_project (Flutter)

Local-first personal finance tracker. Core mirrored from `F:\Project\Sales system` (Supabase and screenutil intentionally excluded).

## Governing Rules

Every change in this repo MUST follow `.agents/rules/rule.md` — the Clean Architecture + MVI (Cubit) rulebook. Read it before writing any feature code. The sections below are project-specific facts that layer on top of that rulebook; they do not override it.

## Tech Stack

| Concern | Package | Notes |
|---|---|---|
| State (MVI+Cubit) | `flutter_bloc` | ViewModel extends `Cubit<State>`, one public method `doIntent(Event)` |
| DI | `get_it` + `injectable` | `configureDependencies()` in `lib/core/di/di.dart`, modules in `lib/core/module/` |
| Networking | `dio` + `retrofit` + `pretty_dio_logger` | `AuthInterceptor` present but unwired for real auth (Supabase excluded) |
| Local DB | `objectbox` + `objectbox_flutter_libs` | Primary storage for finance data |
| Secure storage | `flutter_secure_storage` (via `SecureStorageManager`) | Tokens, first-run flag |
| Prefs | `shared_preferences` (via `SharedPrefsManager`) | Locale, non-sensitive flags |
| Router | `go_router` | `lib/core/router/app_router.dart` + `GoRouterRefreshStream`; every path in `RouteNames` |
| Responsive | `AppResponsive` + `AppMeasurements` (`lib/core/responsive/`) | Wrap `MaterialApp.router` in `AppResponsive` — do NOT use `flutter_screenutil` (removed) |
| Charts | `fl_chart` `0.70.2` (pinned) | Do not upgrade without asking |
| Toasts | `toastification` (via `CustomToastification`) | Success/error UX |
| i18n | `intl_utils` -> `lib/generated/l10n.dart` | `context.l10n.<key>` only; add missing keys to `lib/l10n/intl_*.arb` |
| Formatters/Export | `intl`, `pdf`, `printing`, `excel`, `share_plus`, `file_picker` | Helpers in `lib/core/utils/` |

**Removed / not used:** `flutter_screenutil`, `supabase_flutter`, `cached_network_image`, `flutter_svg`. Do NOT reintroduce.

## Folder Layout (LAYER-FIRST, not feature-first)

Top-level folders under `lib/` are LAYERS. New work goes into the matching flat layer folder, alongside every other feature's files — do NOT create per-feature top-level folders. The only feature grouping is inside `presentation/`.

```
lib/
├── main.dart                          MaterialApp.router + AppResponsive
│
├── api/                               (Layer 0 - remote + local impls, DTOs, client)
│   ├── client/                        ApiClient (retrofit), any raw HTTP helpers
│   ├── data_source/                   *_remote_data_source_impl.dart, *_local_data_source_impl.dart (flat)
│   └── models/                        *_model.dart / *_dto.dart with @JsonSerializable (flat, one per model)
│
├── domain/                            (Layer 1 - pure Dart, no Flutter imports)
│   ├── entities/                      *_entity.dart (flat, one per entity)
│   ├── repo/                          Abstract repository interfaces (flat)
│   └── use_cases/                     Grouped by verb - add/, get/, update/, delete/, auth/, core/, ...
│                                      Each use case is a callable @injectable class
│
├── data/                              (Layer 2 - depends on Domain)
│   ├── data_source/                   Abstract data source interfaces (flat)
│   └── repo/                          *_repo_impl.dart / *_repository_impl.dart (flat, @Injectable(as: ...))
│
├── presentation/                      (Layer 3 - only place feature grouping lives)
│   └── <feature>/                     e.g. expenses, transactions, dashboard, settings
│       ├── view/
│       │   ├── <feature>_screen.dart  Wrapped in CustomScreenWrapper, provides ViewModel via BlocProvider
│       │   └── widgets/               <feature>_view_body.dart + *_section.dart / *_table.dart / *_dialog.dart
│       └── view_model/
│           ├── <feature>_view_model.dart    Cubit, @injectable, single public doIntent(Event)
│           ├── <feature>_state.dart         extends BaseState, Equatable, copyWith
│           └── <feature>_events.dart        sealed class + {Action}<Feature>Event subclasses
│
├── core/                              (cross-cutting - reuse before adding new)
│   ├── api_result/                    ApiResult<T>, safeApiCall, dio_error_handler
│   ├── constants/                     app_theme, app_colors, const_keys, end_points, app_icons/images
│   ├── core_cubit/                    CoreCubit + CoreState + CoreEvents (app-wide, locale)
│   ├── custom_widget/                 Reusable widgets - see list below
│   ├── di/                            configureDependencies() + di.config.dart (generated)
│   ├── enums/                         Shared enums
│   ├── extensions/                    l10n_extension, theme_extension, date_time_extension
│   ├── interceptors/                  auth_interceptor (currently unwired)
│   ├── manager/                       SecureStorageManager, SharedPrefsManager
│   ├── module/                        @module classes (Dio, ApiClient, Connectivity)
│   ├── responsive/                    AppResponsive + AppMeasurements
│   ├── router/                        app_router (go_router), go_router_refresh_stream, route_names
│   └── utils/                         BaseState<T>, DataResult, ErrorHandler, formatters, safeApiCall/safeDataCall
│
├── local/                             ObjectBox setup + local-only models (@Entity)
├── l10n/                              ARB translation sources (intl_en.arb, intl_ar.arb)
├── generated/                         intl_utils output (do NOT edit)
└── objectbox-model.json               ObjectBox schema snapshot (generated; do NOT edit)
```

### File-placement rule of thumb (for a new "transactions" feature)

| What you write | Where it lives |
|---|---|
| `TransactionModel` (@JsonSerializable, toEntity) | `lib/api/models/transaction_model.dart` |
| ObjectBox `@Entity() TransactionObject` | `lib/local/models/transaction_object.dart` |
| `TransactionsRemoteDataSourceImpl` (retrofit) | `lib/api/data_source/transactions_remote_data_source_impl.dart` |
| `TransactionsLocalDataSourceImpl` (ObjectBox) | `lib/api/data_source/transactions_local_data_source_impl.dart` |
| `TransactionEntity` (pure Dart) | `lib/domain/entities/transaction_entity.dart` |
| `abstract class TransactionsRepo` | `lib/domain/repo/transactions_repo.dart` |
| `GetTransactionsUseCase` (@injectable, callable) | `lib/domain/use_cases/get/get_transactions_use_case.dart` |
| `AddTransactionUseCase` | `lib/domain/use_cases/add/add_transaction_use_case.dart` |
| `TransactionsRemoteDataSource` (abstract) | `lib/data/data_source/transactions_remote_data_source.dart` |
| `TransactionsRepoImpl` (@Injectable(as: TransactionsRepo)) | `lib/data/repo/transactions_repo_impl.dart` |
| `TransactionsScreen` | `lib/presentation/transactions/view/transactions_screen.dart` |
| `TransactionsViewBody` + sections | `lib/presentation/transactions/view/widgets/` |
| `TransactionsViewModel` + State + Events | `lib/presentation/transactions/view_model/` |

## Available Custom Widgets (`lib/core/custom_widget/`)

`compact_date_picker_dialog`, `custom_date_filter`, `custom_dialog`, `custom_dropdown_field`, `custom_elevated_button_loading`, `custom_loading_indicator`, `custom_screen_wrapper`, `custom_stat_card`, `custom_tab_bar`, `custom_toastification`, `screen_header`. Reach for these before writing new UI primitives.

## Feature Naming (MUST match rulebook)

For a feature named `transactions`:

| File | Class |
|---|---|
| `<screen>_view_model.dart` | `TransactionsViewModel extends Cubit<TransactionsState>` |
| `<screen>_state.dart` | `TransactionsState extends BaseState` |
| `<screen>_events.dart` | `sealed class TransactionsEvents { ... }` + `LoadTransactionsEvent`, `SubmitTransactionEvent`, `DeleteTransactionEvent`, etc. |
| `transaction_entity.dart` | `TransactionEntity` (domain, pure Dart) |
| `transaction_model.dart` | `TransactionModel` (data, @JsonSerializable, `toEntity()`) |
| `transactions_repository.dart` | `abstract class TransactionsRepository` (domain) |
| `transactions_repository_impl.dart` | `TransactionsRepositoryImpl` (data, `@Injectable(as: TransactionsRepository)`) |
| `transactions_remote_data_source.dart` / `_local_data_source.dart` | abstract + impl (`@Injectable(as: ...)`) |
| `get_transactions_use_case.dart` | Callable `class GetTransactionsUseCase { Future<DataResult<List<TransactionEntity>>> call(params); }` (`@injectable`) |

## Hard Guardrails (from rulebook + project specifics)

- No `setState`. Everything reactive goes through the ViewModel.
- No hardcoded strings — add keys to `lib/l10n/intl_en.arb` (+ `intl_ar.arb`), regenerate via `flutter pub run intl_utils:generate`, use `context.l10n.<key>`.
- No inline colors — `context.primaryColor` etc., fallback `AppColors.*`.
- No inline `TextStyle` — `context.bodyMedium` etc.
- No hardcoded dimensions — `AppMeasurements.*` only.
- No `Theme.of(context)` — use the context extensions.
- Repositories return `DataResult<Entity>`, never Models. Entities in Domain, Models in Data.
- Data sources wrap external calls in `safeDataCall(() => ...)`.
- Navigate via `context.go(...)` / `context.push(...)`; every path in `RouteNames`.
- Screens wrap their body in `CustomScreenWrapper` and provide the ViewModel via `BlocProvider`.
- No `flutter_screenutil`, no `supabase_flutter`. Do not add them back.
- Do not add packages to `pubspec.yaml` without confirming.

## Commands

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs   # after any @injectable / @Entity / @JsonSerializable change
flutter pub run intl_utils:generate                                # after touching lib/l10n/intl_*.arb
flutter run
flutter test
flutter analyze
dart format .
```
