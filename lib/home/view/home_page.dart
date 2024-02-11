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
          title: const Center(
              child: Text('Home', style: TextStyle(color: Colors.white))),
        ),
        // add a navigation drawer to the app bar shows todos and stats
        bottomNavigationBar: BottomNavigationBar(items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.list), label: 'Todos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.show_chart), label: 'Stats'),
        ])
        ,
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
                      child: mainscreen(context),
                    ),
                  ],
                )
              : //this is the mobile view
              mainscreen(context),
        ));
  }

  Widget mainscreen(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Avatar(photo: user.photo),
        const SizedBox(height: 4),
        Text(user.email ?? '', style: textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(user.name ?? '', style: textTheme.headlineSmall),
        iconsTray(context)
      ],
    );
  }

  Widget iconsTray(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.playlist_add),
          onPressed: () {
            // TODO: Implement functionality to make a todo list for a trip
          },
        ),
        IconButton(
          icon: Icon(Icons.list),
          onPressed: () {
            // TODO: Implement functionality to view a trip list
          },
        ),
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            // TODO: Implement functionality to search popular top list
          },
        ),
      ],
    );
  }

  Widget MobileMenu(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
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
          Container(
            child: Column(
              children: <Widget>[
                Avatar(photo: user.photo),
                const SizedBox(height: 4),
                Text(user.email ?? ''),
                const SizedBox(height: 4),
                Text(user.name ?? ''),
              ],
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
