import 'package:authentication_repository/authentication_repository.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelapp/app/app.dart';
import 'package:travelapp/themes/bloc/theme_bloc.dart';

class App extends StatelessWidget {
  const App({
    required AuthenticationRepository authenticationRepository,
    super.key,
  }) : _authenticationRepository = authenticationRepository;

  final AuthenticationRepository _authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
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
              );
            },
          );
        },
      ),
    );  

    
  }
}

