part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  final ThemeData themeData;

  const ThemeState(this.themeData);

  static ThemeState get darkTheme =>
      ThemeState(ThemeData.dark().copyWith(
        // Customize dark theme properties
        textTheme: GoogleFonts.openSansTextTheme(),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 113, 243, 230),
          elevation: 4,
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF0097A7),
          secondary: Color(0xFF009688),
          background: Color(0xFFE0F2F1),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ));

  static ThemeState get lightTheme =>
      ThemeState(ThemeData.light().copyWith(
        // Customize light theme properties
        textTheme: GoogleFonts.openSansTextTheme(),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 113, 243, 230),
          elevation: 4,
        ),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF0097A7),
          secondary: Color(0xFF009688),
          background: Color(0xFFE0F2F1),
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
