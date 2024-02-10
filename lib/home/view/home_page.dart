import 'package:authentication_repository/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelapp/app/app.dart';
import 'package:travelapp/home/widgets/avatar.dart';
import 'package:travelapp/themes/bloc/theme_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static Page<void> page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final user = context.select((AppBloc bloc) => bloc.state.user);
    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Center(child:Text('Home', style: TextStyle(color: Colors.white))),
      ),
      drawer: isLargeScreen ? null : MobileMenu(context),
      body: Align(
          alignment: const Alignment(0, -1 / 3),
          child: isLargeScreen
            ? 
            //this is the desktop view
            Row(
      children: <Widget>[
        MobileMenu(context),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Avatar(photo: user.photo),
              const SizedBox(height: 4),
              Text(user.email ?? '', style: textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(user.name ?? '', style: textTheme.headlineSmall),
            ],
          ),
        ),
        
      ],
    )
            ://this is the mobile view
            Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Avatar(photo: user.photo),
        const SizedBox(height: 4),
        Text(user.email ?? '', style: textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(user.name ?? '', style: textTheme.headlineSmall),
      ],
    ),
    ));
  }

  Widget MobileMenu(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Text(
              'Options',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('My Account'),
            onTap: () {
              Navigator.pushNamed(context, '/my_account');
            },
          ),
          ListTile(
            leading: const Icon(Icons.lightbulb),
            title: const Text('Toggle Dark Mode / Light Mode'),
            onTap: () {
              //call the theme bloc to toggle the theme
              context.read<ThemeBloc>().add(ThemeSwitchEvent());
            },
          ),
        ],
      ),
    );
  }
}

