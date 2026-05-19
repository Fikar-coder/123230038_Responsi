import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/game_model.dart';
import '../services/api_service.dart';
import '../hive/game_hive_model.dart';

class DetailPage extends StatefulWidget {
  final int gameId;
  const DetailPage({super.key, required this.gameId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<GameDetail> _detailFuture;
  late Box<GameHiveModel> _libraryBox;
  bool _isInLibrary = false;

  @override
  void initState() {
    super.initState();
    _detailFuture = ApiService.fetchGameDetail(widget.gameId);
    _libraryBox = Hive.box<GameHiveModel>('library');
    _checkLibrary();
  }

  void _checkLibrary() {
    setState(() {
      _isInLibrary = _libraryBox.values.any((g) => g.id == widget.gameId);
    });
  }

  void _toggleLibrary(GameDetail game) {
    if (_isInLibrary) {
      // Hapus dari library
      final key = _libraryBox.keys.firstWhere(
        (k) => _libraryBox.get(k)?.id == game.id,
        orElse: () => null,
      );
      if (key != null) _libraryBox.delete(key);
    } else {
      // Tambah ke library
      final model = GameHiveModel()
        ..id = game.id
        ..title = game.title
        ..thumbnail = game.thumbnail
        ..genre = game.genre
        ..platform = game.platform;
      _libraryBox.add(model);
    }
    _checkLibrary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<GameDetail>(
        future: _detailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final game = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Thumbnail
                Image.network(
                  game.thumbnail,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const SizedBox(height: 200, child: Icon(Icons.image)),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Genre & Platform chips
                      Row(
                        children: [
                          _chip(game.genre, Colors.blue),
                          const SizedBox(width: 8),
                          _chip(game.platform, Colors.grey),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Nama Game
                      Text(
                        game.title,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      // Release Date, Publisher, Developer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _infoColumn('Release Date', game.releaseDate),
                          _infoColumn('Publisher', game.publisher),
                          _infoColumn('Developer', game.developer),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Tombol Get / In Library
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _toggleLibrary(game),
                          icon: Icon(
                              _isInLibrary ? Icons.check : Icons.add),
                          label: Text(
                              _isInLibrary ? 'In Library' : '+ Get'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _isInLibrary ? Colors.grey[700] : Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Screenshots
                      if (game.screenshots.isNotEmpty) ...[
                        const Text('Screenshots',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 120,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: game.screenshots.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 8),
                            itemBuilder: (context, i) => ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                game.screenshots[i],
                                width: 180,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.image),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                      // Deskripsi
                      const Text('Overview',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(game.description,
                          style: const TextStyle(height: 1.5)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 12, color: color, fontWeight: FontWeight.w600)),
    );
  }

  Widget _infoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 11, color: Colors.grey)),
        Text(value,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }
}