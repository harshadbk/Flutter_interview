import 'package:flutter/material.dart';
import 'services/api_service.dart';

void main() {
  runApp(MovieApp());
}

class MovieApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Search',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MovieSearchScreen(),
    );
  }
}

class MovieSearchScreen extends StatefulWidget {
  @override
  _MovieSearchScreenState createState() => _MovieSearchScreenState();
}

class _MovieSearchScreenState extends State<MovieSearchScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _movies = [];
  bool _isLoading = false;

  Future<void> _fetchPopularMovies() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final movies = await _apiService.getPopularMovies();
      setState(() {
        _movies = movies;
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _searchMovies(String query) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final movies = await _apiService.searchMovies(query);
      setState(() {
        _movies = movies;
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchPopularMovies();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search for a movie...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    final query = _controller.text.trim();
                    if (query.isNotEmpty) {
                      _searchMovies(query);
                    } else {
                      _fetchPopularMovies();
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _movies.length,
                      itemBuilder: (context, index) {
                        final movie = _movies[index];
                        return ListTile(
                          title: Text(movie['title'] ?? 'No Title'),
                          subtitle: Text(movie['genre'] ?? 'No Genre'),
                          trailing: Text('${movie['rating'] ?? 'N/A'} IMDb'),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
