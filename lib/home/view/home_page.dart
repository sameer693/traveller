import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelapp/app/app.dart';
import 'package:travelapp/edit_todo/view/edit_todo_page.dart';
import 'package:travelapp/home/widgets/avatar.dart';
import 'package:travelapp/make_trip/make_trip.dart';
import 'package:travelapp/make_trip/view/view_trip_page.dart';
import 'package:travelapp/stats/view/stats_page.dart';
import 'package:travelapp/themes/bloc/theme_bloc.dart';
import 'package:travelapp/todos_overview/view/todos_overview_page.dart'; // Import the HomeCubit

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  static Page<void> page() => MaterialPage<void>(child: HomePage());

  // Define a list of image URLs
  final List<String> imageUrls = [
    'assets/hathi.jpg',
    'assets/barf.jpg',
    'assets/pahad.jpg',
    'assets/nadi.jpg',
    'assets/jharna.jpg',
    // Add more image URLs
  ];

  late PageController _pageController;
  late Timer _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: _currentIndex);
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_currentIndex < imageUrls.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      _pageController.animateToPage(
        _currentIndex,
        duration: Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 600;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text('Bhalu BKL', style: TextStyle(color: Colors.black))),
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
                        child: mainscreen(context, screenWidth),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : mainscreen(context, screenWidth),
    );
  }

  Widget mainscreen(BuildContext context, double screenWidth) {
    final textTheme = Theme.of(context).textTheme;
    final user = context.select((AppBloc bloc) => bloc.state.user);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SearchBar(
                hintText: 'Search for a trip',
                onChanged: (value) {
                  // Handle search input
                }),
            Avatar(photo: user.photo),
            const SizedBox(height: 4),
            Text(user.email ?? '', style: textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(user.name ?? '', style: textTheme.headlineSmall),
            iconsTray(context),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      imageUrls[index],
                      width: screenWidth / 2, // Adjust the value as needed
                      height: screenHeight / 8, // Adjust the value as needed
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }

  Widget iconsTray(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        InkWell(
          onTap: () => Navigator.of(context).push(MakeTripPage.route()),
          child: Column(
            children: <Widget>[
              Icon(Icons.playlist_add),
              Text('Make a Trip'),
            ],
          ),
        ),
        InkWell(
          onTap: () => Navigator.of(context).push(ViewTripPage.route()),
          child: Column(
            children: <Widget>[
              Icon(Icons.list),
              Text('View Trips'),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            // TODO: Implement functionality to search popular top list
          },
          child: Column(
            children: <Widget>[
              Icon(Icons.search),
              Text('Search Trips'),
            ],
          ),
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
              color: Theme.of(context).colorScheme.background,
            ),
            child: Text(
              'Options',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Avatar(photo: user.photo),
                const SizedBox(height: 4),
                Text(
                  user.email ?? '',
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.name ?? '',
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                ),
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

  @override
  bool get wantKeepAlive => true;
}
