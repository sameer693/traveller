import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_storage_todos_api/local_storage_todos_api.dart';
import 'package:travelapp/app/bloc_observer.dart';
import 'package:travelapp/app/view/app.dart';
import 'package:travelapp/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();
  //get defualt options for the firebase app
  await Firebase.initializeApp(options:  DefaultFirebaseOptions.currentPlatform );


  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.user.first;
  
  final todosApi = LocalStorageTodosApi(
    plugin: await SharedPreferences.getInstance(),
  );

  runApp(App(authenticationRepository: authenticationRepository, todosApi: todosApi));
}
