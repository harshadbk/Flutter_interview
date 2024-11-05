import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Movie Search')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search Movies',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    final query = _controller.text.trim();
                    if (query.isNotEmpty) {
                      movieProvider.searchMovies(query);
                    } else {
                      movieProvider.fetchPopularMovies();
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: movieProvider.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: movieProvider.movies.length,
                      itemBuilder: (context, index) {
                        final movie = movieProvider.movies[index];
                        return ListTile(
                          title: Text(movie['title'] ?? 'No Title'),
                          subtitle: Text(movie['genre'] ?? 'No Genre'),
                          trailing: Text('${movie['rating']} IMDb'),
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
