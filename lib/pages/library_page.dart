import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../hive/game_hive_model.dart';
import 'detail_page.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library Anda'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<GameHiveModel>('library').listenable(),
        builder: (context, Box<GameHiveModel> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text('Library kosong. Tambahkan game dari Home!'),
            );
          }
          final games = box.values.toList();
          return ListView.builder(
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];
              return ListTile(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailPage(gameId: game.id),
                  ),
                ),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    game.thumbnail,
                    width: 70,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.image_not_supported),
                  ),
                ),
                title: Text(game.title,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(game.genre,
                          style: const TextStyle(fontSize: 11)),
                    ),
                    Text(game.platform,
                        style: const TextStyle(fontSize: 12)),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    final key = box.keys.elementAt(index);
                    box.delete(key);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}