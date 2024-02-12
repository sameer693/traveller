import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelapp/app/app.dart';
import 'package:travelapp/edit_todo/view/edit_todo_page.dart';
import 'package:travelapp/home/widgets/avatar.dart';
import 'package:travelapp/make_trip/make_trip.dart';
import 'package:travelapp/stats/view/stats_page.dart';
import 'package:travelapp/themes/bloc/theme_bloc.dart';
import 'package:travelapp/todos_overview/view/todos_overview_page.dart'; // Import the HomeCubit

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static Page<void> page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text('Home', style: TextStyle(color: Colors.white))),
          actions: <Widget>[
          IconButton(
            key: const Key('homePage_logout_iconButton'),
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              context.read<AppBloc>().add(const AppLogoutRequested());
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        key: const Key('homeView_addTodo_floatingActionButton'),
        onPressed: () => Navigator.of(context).push(EditTodoPage.route()),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Todos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Stats',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            // Navigate to the todos page TodosOverviewPage
            Navigator.of(context).push(TodosOverviewPage.route());
          } else if (index == 1) {
            // Navigate to the stats page
            Navigator.of(context).push(StatsPage.route());
          }
        },
      ),
      drawer: isLargeScreen ? null : mobileMenu(context),
      body: isLargeScreen
            ? Row(
                children: <Widget>[
                  mobileMenu(context),
                  // vetical flex and fit the child
                    Expanded(
                      child: Flex(
                        direction: Axis.vertical,
                        children: <Widget>[
                          Flexible(
                            fit: FlexFit.tight,
                            child: mainscreen(context),
                          ),
                        ],
                      ),
                    ),
                  ],
              )
            : mainscreen(context),
      
    );
  }

  Widget mainscreen(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final user = context.select((AppBloc bloc) => bloc.state.user);

    return Container(
        padding: const EdgeInsets.all(16),
      child: Column(
      mainAxisSize: MainAxisSize.min,     
      
      children: <Widget>[
        SearchBar(
          
          hintText: 'Search for a trip', onChanged: (value) {

        }),
        Avatar(photo: user.photo),
        const SizedBox(height: 4),
        Text(user.email ?? '', style: textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(user.name ?? '', style: textTheme.headlineSmall),
        iconsTray(context),
      ],
    ));
  }

  Widget iconsTray(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.playlist_add),
          onPressed: () => Navigator.of(context).push(MakeTripPage.route()),
          // onPressed: () {
          //   // TODO: Implement functionality to make a todo list for a trip
          //   //go to the todos overview page
          // },
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

  Widget mobileMenu(BuildContext context) {
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
              // Call the theme bloc to toggle the theme
              context.read<ThemeBloc>().add(ThemeSwitchEvent());
            },
          ),
        ],
      ),
    );
  }
}
