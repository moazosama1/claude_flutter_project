import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:initialize_project/core/constants/app_theme.dart';
import 'package:initialize_project/core/constants/const_keys.dart';
import 'package:initialize_project/core/di/di.dart';
import 'package:initialize_project/core/manager/secure_storage_manager.dart';
import 'package:initialize_project/core/responsive/app_responsive.dart';
import 'package:initialize_project/core/router/app_router.dart';
import 'package:initialize_project/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:initialize_project/my_bloc_observer.dart';

import 'core/core_cubit/core_cubit.dart';
import 'core/core_cubit/core_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  final prefs = getIt<SharedPreferences>();
  final isFirstRun = prefs.getBool(ConstKeys.kIsFirstRun) ?? true;
  if (isFirstRun) {
    try {
      await getIt<SecureStorageManager>().clear();
    } catch (_) {}
    await prefs.setBool(ConstKeys.kIsFirstRun, false);
  }

  // Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CoreCubit>(),
      child: BlocBuilder<CoreCubit, CoreState>(
        builder: (context, state) {
          return AppResponsive(
            width: 480,
            child: MaterialApp.router(
              title: AppLocalizations().appName,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: state.themeMode,
              routerConfig: AppRouter.router,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.delegate.supportedLocales,
              locale: const Locale("ar"),
            ),
          );
        },
      ),
    );
  }
}
