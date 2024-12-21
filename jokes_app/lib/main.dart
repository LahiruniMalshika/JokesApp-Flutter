// import 'package:flutter/material.dart';
// import 'joke_service.dart';
//
// void main() {
//   runApp(MyJokesApp());
// }
// class MyJokesApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Jokes App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       debugShowCheckedModeBanner: false,
//       home: JokeListPage(),
//     );
//   }
// }
// class JokeListPage extends StatefulWidget {
//   const JokeListPage({Key? key}) : super(key: key);
//
//   @override
//   State<JokeListPage> createState() => _JokeListPageState();
// }
//
// class _JokeListPageState extends State<JokeListPage> {
//   final JokeService _jokeService = JokeService();
//   List<Map<String, dynamic>> _jokes = [];
//   Set<Map<String, dynamic>> _favoriteJokes = {};
//   int _currentIndex = 0;
//   bool _isLoading = false;
//   int _selectedIndex = 0;
//
//   Future<void> _fetchJokes() async {
//     setState(() => _isLoading = true);
//     try {
//       _jokes =
//           (await _jokeService.fetchJokes()).cast<Map<String, dynamic>>();
//       _currentIndex = 0;
//     } catch (e) {
//       print('Error fetching jokes: $e');
//
//       if (_jokes.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//               content:
//               Text("Unable to fetch jokes and no cached jokes available!")),
//         );
//       }
//     }
//     setState(() => _isLoading = false);
//   }
//   @override
//   void initState() {
//     super.initState();
//     _loadCachedJokes();
//   }
//
//   Future<void> _loadCachedJokes() async {
//     final cachedJokes = await _jokeService.loadCachedJokes();
//     if (cachedJokes.isNotEmpty) {
//       setState(() {
//         _jokes = cachedJokes.cast<Map<String, dynamic>>();
//         _currentIndex = 0;
//       });
//     }
//   }
//
//   void _nextJoke() {
//     if (_currentIndex < _jokes.length - 1) {
//       setState(() => _currentIndex++);
//     }
//   }
//
//   void _previousJoke() {
//     if (_currentIndex > 0) {
//       setState(() => _currentIndex--);
//     }
//   }
//   void _toggleFavorite(Map<String, dynamic> joke) {
//     setState(() {
//       if (_favoriteJokes.contains(joke)) {
//         _favoriteJokes.remove(joke);
//       } else {
//         _favoriteJokes.add(joke);
//       }
//     });
//   }
//
//   void _onTabTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Jokes App'),
//         backgroundColor: Colors.deepPurpleAccent,
//         actions: [
//           Container(
//             margin: const EdgeInsets.only(right: 16, top: 8),
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             decoration: BoxDecoration(
//               color: Colors.deepPurpleAccent,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: const Center(
//               child: Text(
//                 'Beta',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 12,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Colors.deepPurpleAccent,
//               Colors.white,
//             ],
//           ),
//         ),
//         child: _selectedIndex == 0
//             ? _buildJokesTab()
//             : _buildFavoritesTab(),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onTabTapped,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Jokes',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.favorite),
//             label: 'Favorites',
//           ),
//         ],
//         selectedItemColor: Colors.deepPurpleAccent,
//       ),
//     );
//   }
//
//   Widget _buildJokesTab() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         const Text(
//           'Welcome to the Jokes App!',
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//             height: 2,
//           ),
//         ),
//         const SizedBox(height: 8),
//         const Text(
//           'Click the button to fetch random jokes!',
//           style: TextStyle(
//             fontSize: 18,
//             color: Colors.black,
//           ),
//         ),
//         const SizedBox(height: 16),
//         ElevatedButton(
//           onPressed: _isLoading ? null : _fetchJokes,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.black,
//             padding: const EdgeInsets.symmetric(
//               horizontal: 32,
//               vertical: 12,
//             ),
//           ),
//           child: _isLoading
//               ? const SizedBox(
//             width: 16,
//             height: 16,
//             child: CircularProgressIndicator(
//               color: Colors.white,
//               strokeWidth: 2,
//             ),
//           )
//               : const Text(
//             'Fetch Jokes',
//             style: TextStyle(fontSize: 16),
//           ),
//         ),
//         const SizedBox(height: 32),
//         Expanded(
//           child: _jokes.isEmpty
//               ? const Center(
//             child: Text(
//               'No jokes fetched yet.',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.black45,
//               ),
//             ),
//           )
//               : ListView.builder(
//             itemCount: _jokes.length,
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             itemBuilder: (context, index) {
//               final joke = _jokes[index];
//               final isFavorite = _favoriteJokes.contains(joke);
//               return Card(
//                 margin: const EdgeInsets.symmetric(vertical: 8),
//                 child: ListTile(
//                   contentPadding: const EdgeInsets.all(12),
//                   title: Text(
//                     joke['type'] == 'single'
//                         ? joke['joke']
//                         : '${joke['setup']}\n\n${joke['delivery']}',
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   trailing: IconButton(
//                     icon: Icon(
//                       isFavorite
//                           ? Icons.favorite
//                           : Icons.favorite_border,
//                       color: isFavorite ? Colors.red : Colors.grey,
//                     ),
//                     onPressed: () => _toggleFavorite(joke),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildFavoritesTab() {
//     return _favoriteJokes.isEmpty
//         ? const Center(
//       child: Text(
//         'No favorite jokes yet.',
//         style: TextStyle(
//           fontSize: 16,
//           color: Colors.black45,
//         ),
//       ),
//     )
//         : ListView.builder(
//       itemCount: _favoriteJokes.length,
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       itemBuilder: (context, index) {
//         final joke = _favoriteJokes.toList()[index];
//         return Card(
//           margin: const EdgeInsets.symmetric(vertical: 8),
//           child: ListTile(
//             contentPadding: const EdgeInsets.all(12),
//             title: Text(
//               joke['type'] == 'single'
//                   ? joke['joke']
//                   : '${joke['setup']}\n\n${joke['delivery']}',
//               style: const TextStyle(fontSize: 16),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }


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
      home: JokeListPage(),
    );
  }
}

class JokeListPage extends StatefulWidget {
  const JokeListPage({Key? key}) : super(key: key);

  @override
  State<JokeListPage> createState() => _JokeListPageState();
}

class _JokeListPageState extends State<JokeListPage> {
  final JokeService _jokeService = JokeService();
  List<Map<String, dynamic>> _jokes = [];
  Set<Map<String, dynamic>> _favoriteJokes = {};
  int _currentIndex = 0;
  bool _isLoading = false;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadCachedJokes();
    _loadFavoriteJokes();
  }

  Future<void> _loadCachedJokes() async {
    final cachedJokes = await _jokeService.loadCachedJokes();
    if (cachedJokes.isNotEmpty) {
      setState(() {
        _jokes = cachedJokes.cast<Map<String, dynamic>>();
        _currentIndex = 0;
      });
    }
  }

  Future<void> _loadFavoriteJokes() async {
    final favoriteJokes = await _jokeService.loadFavoriteJokes();
    setState(() {
      _favoriteJokes = favoriteJokes;
    });
  }

  Future<void> _fetchJokes() async {
    setState(() => _isLoading = true);
    try {
      _jokes = (await _jokeService.fetchJokes()).cast<Map<String, dynamic>>();
      _currentIndex = 0;
    } catch (e) {
      print('Error fetching jokes: $e');
      if (_jokes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Unable to fetch jokes and no cached jokes available!"),
          ),
        );
      }
    }
    setState(() => _isLoading = false);
  }

  void _toggleFavorite(Map<String, dynamic> joke) async {
    setState(() {
      if (_favoriteJokes.any((favJoke) => favJoke['id'] == joke['id'])) {
        _favoriteJokes.removeWhere((favJoke) => favJoke['id'] == joke['id']);
      } else {
        _favoriteJokes.add(joke);
      }
    });
    await _jokeService.saveFavoriteJokes(_favoriteJokes);
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
        child: _selectedIndex == 0 ? _buildJokesTab() : _buildFavoritesTab(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
        selectedItemColor: Colors.deepPurpleAccent,
      ),
    );
  }

  Widget _buildJokesTab() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Welcome to the Jokes App!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 2,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Click the button to get random jokes!',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _isLoading ? null : _fetchJokes,
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
            'Get Jokes',
            style: TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(height: 32),
        Expanded(
          child: _jokes.isEmpty
              ? const Center(
            child: Text(
              'No jokes received yet.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black45,
              ),
            ),
          )
              : ListView.builder(
            itemCount: _jokes.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              final joke = _jokes[index];
              final isFavorite = _favoriteJokes.any((favJoke) => favJoke['id'] == joke['id']);
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
                      isFavorite ? Icons.favorite : Icons.favorite_border,
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
    );
  }

  Widget _buildFavoritesTab() {
    return _favoriteJokes.isEmpty
        ? const Center(
      child: Text(
        'No favorite jokes yet.',
        style: TextStyle(
          fontSize: 16,
          color: Colors.black45,
        ),
      ),
    )
        : ListView.builder(
        itemCount: _favoriteJokes.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final joke = _favoriteJokes.toList()[index];
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
                icon: const Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                onPressed: () => _toggleFavorite(joke),
              ),
            ),
          );
          },
        );
    }
}