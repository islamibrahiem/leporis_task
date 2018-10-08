import 'package:leporis_task/Models/movieDetails.dart';

class DataBody {
  final int totalResults;
  final int totalPages;
  final List<Results> results;

  DataBody({this.totalResults, this.totalPages, this.results});

  factory DataBody.fromJson(Map<String, dynamic> json) {
    var list = json['results'] as List;
    List<Results> resultsList = list.map((i) => Results.fromJson(i)).toList();

    return DataBody(
      totalResults: json['total_results'],
      totalPages: json['total_pages'],
      results: resultsList,
    );
  }
}
