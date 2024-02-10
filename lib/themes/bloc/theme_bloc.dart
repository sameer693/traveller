import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travelapp/themes/theme.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeData> {
  ThemeBloc() : super(ThemeState.lightTheme.themeData) {
    //when app is started
    on<InitialThemeSetEvent>((event, emit) async {
      final bool hasDarkTheme = await isDark();
      if (hasDarkTheme) {
        emit(ThemeState.darkTheme.themeData);
      } else {
        emit(ThemeState.lightTheme.themeData);
      }
    });

    //while switch is clicked
    on<ThemeSwitchEvent>((event, emit) {
      final isDark = state == ThemeState.darkTheme.themeData;
      emit(isDark ? ThemeState.lightTheme.themeData : ThemeState.darkTheme.themeData);
      setTheme(isDark);
    });
  }
  
}
