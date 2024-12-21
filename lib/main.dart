import 'package:flutter/material.dart';
import 'joke_service.dart';

void main() {
  runApp(MyJokesApp());
}

class MyJokesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jokes App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: JokesPage(),
    );
  }
}

class JokesPage extends StatefulWidget {
  @override
  _JokesPageState createState() => _JokesPageState();
}

class _JokesPageState extends State<JokesPage> {
  final JokeService _jokeService = JokeService();
  List<Map<String, dynamic>> _jokes = [];
  Set<Map<String, dynamic>> _favoriteJokes = {}; // Set to track favorite jokes
  bool _isLoading = false;
  bool _hasMoreJokes = true;
  int _currentPage = 1;
  static const int _jokesPerPage = 5;

  Future<void> _fetchJokes() async {
    if (_isLoading) return; // Prevent multiple fetches

    setState(() {
      _isLoading = true;
    });

    try {
      final jokes = await _jokeService.fetchJokes(page: _currentPage, limit: _jokesPerPage);
      setState(() {
        _jokes.addAll(jokes);
        _currentPage++; // Increment the page number for next fetch
        if (jokes.length < _jokesPerPage) {
          _hasMoreJokes = false; // No more jokes to load
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch jokes: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Toggle favorite status
  void _toggleFavorite(Map<String, dynamic> joke) {
    setState(() {
      if (_favoriteJokes.contains(joke)) {
        _favoriteJokes.remove(joke); // Remove from favorites
      } else {
        _favoriteJokes.add(joke); // Add to favorites
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchJokes(); // Fetch jokes when the app starts
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jokes App'),
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'Beta',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurpleAccent,
              Colors.white,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the Jokes App!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 2, // Adds 20px space
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Click the button to fetch random jokes!',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading || !_hasMoreJokes ? null : _fetchJokes,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : const Text(
                'Fetch Jokes',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: _jokes.isEmpty
                  ? const Center(
                child: Text(
                  'No jokes fetched yet.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black45,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: _jokes.length + (_hasMoreJokes ? 1 : 0), // Add an extra item for the "Load More" button
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  if (index == _jokes.length) {
                    // Show "Load More" button at the end of the list
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: ElevatedButton(
                        onPressed: _fetchJokes,
                        style: ElevatedButton.styleFrom(
                          primary: Colors.deepPurpleAccent,
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                            : const Text('Load More'),
                      ),
                    );
                  }
                  final joke = _jokes[index];
                  final isFavorite = _favoriteJokes.contains(joke);
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      title: Text(
                        joke['type'] == 'single'
                            ? joke['joke']
                            : '${joke['setup']}\n\n${joke['delivery']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                        ),
                        onPressed: () => _toggleFavorite(joke),
                      ),
                    ),
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
