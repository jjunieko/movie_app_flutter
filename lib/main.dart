import 'package:flutter/material.dart';
import 'package:myapp/presentation/providers/movie_provider.dart';
import 'package:myapp/presentation/screens/favorites_screen.dart';
import 'package:myapp/presentation/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MovieProvider()),
      ],
      child: MaterialApp(
        title: 'Movies App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
        routes: {
          '/favorites': (context) => FavoritesScreen(),
        },
      ),
    );
  }
}
