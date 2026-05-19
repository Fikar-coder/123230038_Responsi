class Game {
  final int id;
  final String title;
  final String thumbnail;
  final String genre;
  final String platform;

  Game({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.genre,
    required this.platform,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      title: json['title'],
      thumbnail: json['thumbnail'],
      genre: json['genre'],
      platform: json['platform'],
    );
  }
}

class GameDetail {
  final int id;
  final String title;
  final String thumbnail;
  final String genre;
  final String platform;
  final String releaseDate;
  final String publisher;
  final String developer;
  final String description;
  final List<String> screenshots;

  GameDetail({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.genre,
    required this.platform,
    required this.releaseDate,
    required this.publisher,
    required this.developer,
    required this.description,
    required this.screenshots,
  });

  factory GameDetail.fromJson(Map<String, dynamic> json) {
    List<String> shots = [];
    if (json['screenshots'] != null) {
      shots = (json['screenshots'] as List)
          .map((s) => s['image'] as String)
          .toList();
    }
    return GameDetail(
      id: json['id'],
      title: json['title'],
      thumbnail: json['thumbnail'],
      genre: json['genre'],
      platform: json['platform'],
      releaseDate: json['release_date'] ?? '',
      publisher: json['publisher'] ?? '',
      developer: json['developer'] ?? '',
      description: json['description'] ?? '',
      screenshots: shots,
    );
  }
}