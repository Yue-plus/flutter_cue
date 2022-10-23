import 'package:flutter/material.dart';

import 'src/home.dart';

const title = '点名！';

void main() => runApp(MaterialApp(
  title: title,
  themeMode: ThemeMode.system,
  initialRoute: '/',
  routes: <String, WidgetBuilder> {
    '/': (BuildContext context) => const Home(),
  },
  debugShowCheckedModeBanner: false,
));