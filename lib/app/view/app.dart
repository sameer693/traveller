import 'package:authentication_repository/authentication_repository.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_storage_todos_api/src/local_storage_todos_api.dart';
import 'package:todos_repository/todos_repository.dart';
import 'package:travelapp/app/app.dart';
import 'package:travelapp/l10n/l10n.dart';
import 'package:travelapp/themes/bloc/theme_bloc.dart';

class App extends StatelessWidget {
  const App({
    required AuthenticationRepository authenticationRepository,
    super.key,
    required LocalStorageTodosApi todosApi,
  }) : _authenticationRepository = authenticationRepository,
        _todosApi = todosApi;


  final LocalStorageTodosApi _todosApi;
  final AuthenticationRepository _authenticationRepository;

  @override
  Widget build(BuildContext context) {
    final todosRepository = TodosRepository(todosApi: _todosApi);
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _authenticationRepository),
        RepositoryProvider.value(value: todosRepository),
      ],
      child: BlocProvider(
        create: (_) => AppBloc(
          authenticationRepository: _authenticationRepository,
        ),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeBloc()..add(InitialThemeSetEvent()),
      child: Builder(
        builder: (context) {
          return BlocBuilder<ThemeBloc, ThemeData>(
            builder: (context, state) {
              return MaterialApp(
                theme: state,
                debugShowCheckedModeBanner: false,
                home: FlowBuilder<AppStatus>(
                  state: context.select((AppBloc bloc) => bloc.state.status),
                  onGeneratePages: onGenerateAppViewPages,
                ),
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
              );
            },
          );
        },
      ),
    );
  }
}
