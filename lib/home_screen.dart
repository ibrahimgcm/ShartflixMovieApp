import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profile_screen.dart';
import 'core/tmdb_api_service.dart';
import 'core/profile_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // 0: Anasayfa, 1: Profil
  List<dynamic> _movies = [];
  bool _isLoadingMovies = false;
  String? _movieError;

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  Future<void> _fetchMovies() async {
    setState(() {
      _isLoadingMovies = true;
      _movieError = null;
    });
    try {
      final movies = await TMDbApiService().fetchPopularMovies();
      setState(() {
        _movies = movies;
        _isLoadingMovies = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingMovies = false;
        _movieError = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Arka plan
          Positioned.fill(
            child: Container(color: Colors.black),
          ),
          // Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color.fromRGBO(9, 9, 9, 0.4),
                    const Color.fromRGBO(9, 9, 9, 0.0),
                    const Color.fromRGBO(9, 9, 9, 0.0),
                    const Color.fromRGBO(9, 9, 9, 0.9),
                  ],
                  stops: const [0.0, 0.1538, 0.7404, 0.8942],
                ),
              ),
            ),
          ),
          // Film listesi
          if (_selectedIndex == 0)
            Positioned.fill(
              child: _isLoadingMovies
                  ? Center(child: CircularProgressIndicator())
                  : _movieError != null
                      ? Center(child: Text(_movieError!, style: TextStyle(color: Colors.white)))
                      : ListView.builder(
                          padding: EdgeInsets.only(top: 120, bottom: 120),
                          itemCount: _movies.length,
                          itemBuilder: (context, index) {
                            final movie = _movies[index];
                            final posterUrl = movie['poster_path'] != null
                                ? 'https://image.tmdb.org/t/p/w500${movie['poster_path']}'
                                : null;
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.03),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Poster
                                  Container(
                                    width: 100,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.grey[900],
                                    ),
                                    child: posterUrl != null
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: Image.network(
                                              posterUrl,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) => Container(
                                                color: Colors.grey[800],
                                                child: Icon(Icons.broken_image, color: Colors.white),
                                              ),
                                            ),
                                          )
                                        : Center(child: Icon(Icons.broken_image, color: Colors.white)),
                                  ),
                                  SizedBox(width: 16),
                                  // Bilgiler ve beğenme butonu
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          movie['title'] ?? '',
                                          style: TextStyle(
                                            fontFamily: 'Instrument Sans',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          movie['overview'] ?? '',
                                          style: TextStyle(
                                            fontFamily: 'Instrument Sans',
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            color: Colors.white.withOpacity(0.8),
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 12),
                                        Consumer<ProfileProvider>(
                                          builder: (context, provider, child) {
                                            final isLiked = provider.likedMovies.any((m) => m['id'] == movie['id']);
                                            return GestureDetector(
                                              onTap: () {
                                                if (isLiked) {
                                                  provider.removeLikedMovie(movie['id']);
                                                } else {
                                                  provider.addLikedMovie(movie);
                                                }
                                              },
                                              child: Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  color: isLiked ? Color(0xFFE50914) : Colors.white.withOpacity(0.05),
                                                  borderRadius: BorderRadius.circular(20),
                                                  border: Border.all(color: isLiked ? Colors.white : Colors.white.withOpacity(0.2)),
                                                ),
                                                child: Icon(
                                                  isLiked ? Icons.favorite : Icons.favorite_border,
                                                  color: isLiked ? Colors.white : Color(0xFFE50914),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
          // Profil ekranı
          if (_selectedIndex == 1)
            ProfileScreen(),
          // Navbar
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              width: 402,
              height: 100,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color.fromRGBO(9,9,9,0), Color(0xFF090909)],
                  stops: [0, 0.2],
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 36),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 0;
                      });
                    },
                    child: Container(
                      width: 169,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(42),
                        border: Border.all(color: Color.fromRGBO(255,255,255,0.2), width: 1),
                        gradient: _selectedIndex == 0
                            ? const RadialGradient(
                                center: Alignment.topCenter,
                                radius: 0.83,
                                colors: [Color(0xFFE50914), Color(0xFF7F050B)],
                              )
                            : null,
                        color: _selectedIndex == 0 ? null : Colors.transparent,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.home_outlined, color: Colors.white, size: 24),
                          const SizedBox(width: 10),
                          Text(
                            'Anasayfa',
                            style: TextStyle(
                              fontFamily: 'Instrument Sans',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 1;
                      });
                    },
                    child: Container(
                      width: 169,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(42),
                        border: Border.all(color: Color.fromRGBO(255,255,255,0.2), width: 1),
                        gradient: _selectedIndex == 1
                            ? const RadialGradient(
                                center: Alignment.topCenter,
                                radius: 0.83,
                                colors: [Color(0xFFE50914), Color(0xFF7F050B)],
                              )
                            : null,
                        color: _selectedIndex == 1 ? null : Colors.transparent,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person, color: Colors.white, size: 24),
                          const SizedBox(width: 10),
                          Text(
                            'Profil',
                            style: TextStyle(
                              fontFamily: 'Instrument Sans',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
