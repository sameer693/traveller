part of 'theme_bloc.dart';


//toggle between light and dark theme

@immutable
abstract class ThemeEvent {}

class InitialThemeSetEvent extends ThemeEvent {}

class ThemeSwitchEvent extends ThemeEvent {}

