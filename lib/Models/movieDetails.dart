class Results {
  final String posterPath;

  final String title;

  final String overview;

  final String releaseDate;

  Results({this.posterPath, this.title, this.overview, this.releaseDate});

  factory Results.fromJson(Map<String, dynamic> json) {
    return Results(
        posterPath: json['poster_path'],
        title: json['title'],
        overview: json['overview'],
        releaseDate: json['release_date']);
  }
}
