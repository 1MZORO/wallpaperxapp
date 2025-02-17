import 'dart:developer';
import 'package:dio/dio.dart';
import '../Models/ImageModel.dart';

class ApiCall{
  final Dio dio = Dio();
  String url = "https://pixabay.com/api/?key=48876447-768da478662460195df17d214";

  Future<List<ImageModel>> fetchImages() async {
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        log('Success');
        List<dynamic> hits = response.data['hits'];
        return hits.map((json) => ImageModel.fromJson(json)).toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      log("DioException: ${e.toString()}");
      return [];
    }
  }

}