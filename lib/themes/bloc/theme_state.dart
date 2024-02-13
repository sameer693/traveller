part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  final ThemeData themeData;

  const ThemeState(this.themeData);

  static ThemeState get darkTheme => ThemeState(ThemeData.dark().copyWith(
        // Customize dark theme properties
        useMaterial3: true,
        brightness: Brightness.dark,
        textTheme: GoogleFonts.openSansTextTheme(),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 99, 53, 155),
          elevation: 4,
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromARGB(255, 201, 79, 107),
          secondary: Color.fromARGB(255, 180, 14, 108),
          background: Color(0xFFE0F2F1),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ));

  static ThemeState get lightTheme => ThemeState(ThemeData.light().copyWith(
        // Customize light theme properties
        useMaterial3: true,
        textTheme: GoogleFonts.openSansTextTheme().apply(
          bodyColor: Color(0xFF000000), // Replace with your desired text color
          displayColor:
              Color(0xFF000000), // Replace with your desired text color
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFECEC),
          elevation: 4,
        ),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFB65972),
          secondary: Color(0xFFD89CAC),
          background: Color(0xFFFFECEC),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ));

  @override
  List<Object> get props => [themeData];
}
