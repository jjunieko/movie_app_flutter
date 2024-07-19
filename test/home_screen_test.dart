// test/screens/home_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:myapp/presentation/providers/movie_provider.dart';
import 'package:myapp/presentation/screens/movie_card.dart';
import 'package:provider/provider.dart';
import 'package:myapp/presentation/screens/home_screen.dart';
import 'package:myapp/models/movie.dart';

// Mock class for MovieProvider
class MockMovieProvider extends Mock implements MovieProvider {}

void main() {
  group('HomeScreen Tests', () {
    late MockMovieProvider mockMovieProvider;

    setUp(() {
      mockMovieProvider = MockMovieProvider();
      // Ensure that all necessary properties are non-null
      when(mockMovieProvider.isLoading).thenReturn(false);
      when(mockMovieProvider.movies).thenReturn([]);
      when(mockMovieProvider.popularMovies).thenReturn([]);
      when(mockMovieProvider.favorites).thenReturn([]);
      when(mockMovieProvider.seasons).thenReturn([]);
      when(mockMovieProvider.selectedMovie).thenReturn(null);
    });

    Widget createHomeScreen() {
      return ChangeNotifierProvider<MovieProvider>(
        create: (_) => mockMovieProvider,
        child: MaterialApp(
          home: HomeScreen(),
        ),
      );
    }

    testWidgets('displays loading indicator when isLoading is true', (WidgetTester tester) async {
      when(mockMovieProvider.isLoading).thenReturn(true);

      await tester.pumpWidget(createHomeScreen());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(MovieCard), findsNothing);
    });

    testWidgets('displays movies when isLoading is false and movies are present', (WidgetTester tester) async {
      when(mockMovieProvider.isLoading).thenReturn(false);
      when(mockMovieProvider.movies).thenReturn([
        Movie(
          id: 1,
          title: 'Test Movie',
          imageUrl: 'https://via.placeholder.com/150',
          overview: 'Overview',
          year: 2020,
          score: 8.5,
          watchSources: [],
          genres: [],
          trailerUrl: '',
          trailerThumbnail: '',
        ),
      ]);
      when(mockMovieProvider.popularMovies).thenReturn([]);

      await tester.pumpWidget(createHomeScreen());

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(MovieCard), findsOneWidget);
      expect(find.text('Test Movie'), findsOneWidget);
    });

    testWidgets('displays popular movies when isLoading is false and movies are empty', (WidgetTester tester) async {
      when(mockMovieProvider.isLoading).thenReturn(false);
      when(mockMovieProvider.movies).thenReturn([]);
      when(mockMovieProvider.popularMovies).thenReturn([
        Movie(
          id: 2,
          title: 'Popular Movie',
          imageUrl: 'https://via.placeholder.com/150',
          overview: 'Overview',
          year: 2021,
          score: 9.0,
          watchSources: [],
          genres: [],
          trailerUrl: '',
          trailerThumbnail: '',
        ),
      ]);

      await tester.pumpWidget(createHomeScreen());

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(MovieCard), findsOneWidget);
      expect(find.text('Popular Movie'), findsOneWidget);
    });

    testWidgets('navigates to favorites screen when favorites icon is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createHomeScreen());

      final iconButton = find.byIcon(Icons.favorite);
      expect(iconButton, findsOneWidget);

      await tester.tap(iconButton);
      await tester.pumpAndSettle();

      // Assuming there's a named route '/favorites', you should verify the navigation.
      // For the purpose of this test, you can either mock the navigation or ensure
      // the favorites screen is being pushed onto the navigator stack.
    });

    testWidgets('searches movies when a query is submitted', (WidgetTester tester) async {
      await tester.pumpWidget(createHomeScreen());

      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      await tester.enterText(textField, 'test query');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      verify(mockMovieProvider.searchMovies('test query')).called(1);
    });
  });
}
