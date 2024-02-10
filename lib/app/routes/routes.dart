import 'package:flutter/widgets.dart';
import 'package:travelapp/app/app.dart';
import 'package:travelapp/home/home.dart';
import 'package:travelapp/login/login.dart';

List<Page<dynamic>> onGenerateAppViewPages(
  AppStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case AppStatus.authenticated:
      return [HomePage.page()];
    case AppStatus.unauthenticated:
      return [LoginPage.page()];
  }
}
