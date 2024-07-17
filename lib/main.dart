import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/data/models/models.dart';
import 'package:provider/provider.dart';
import 'presentation/providers/favorites_provider.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/movie_screen.dart';
import 'presentation/screens/favorites_screen.dart';
import 'presentation/blocs/movie_bloc.dart';
import 'data/repositories/movie_repository.dart';
import 'package:http/http.dart' as http;
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        BlocProvider(
          create: (context) => MovieBloc(
            movieRepository: MovieRepository(
              client: http.Client(),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Movie App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/movie': (context) => MovieScreen(
              movie: ModalRoute.of(context)!.settings.arguments as MovieModel),
          '/favorites': (context) => FavoritesScreen(),
        },
      ),
    );
  }
}
