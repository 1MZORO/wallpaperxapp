import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Models/ImageModel.dart';

class ApiCall {
  final Dio dio = Dio();
  String url =
      "https://pixabay.com/api/?key=48876447-768da478662460195df17d214";

  Future<List<ImageModel>> fetchImages() async {
    try {
      final response =
          await dio.get(url, queryParameters: {"page": 1, "per_page": 100});
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

  Future<void> downloadAndSaveImage(BuildContext context, String url) async {
    try {
      if (Platform.isAndroid) {
        PermissionStatus status = await Permission.storage.request();
        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Permission is denied $status")));
        }

        var response = await dio.get(url,
            options: Options(responseType: ResponseType.bytes));

        final result = await ImageGallerySaverPlus.saveImage(
            Uint8List.fromList(response.data),
            quality: 60,
            name: "HelloTest");
        final st = result['isSuccess'];
        if (st) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Image is saved in gallery")));
        }
      }
    } catch (e) {
      log("Error ${e.toString()}");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Unable To download Image")));
    }
  }

  Future<void> requestStoragePermission(BuildContext context, String imageUrl) async {
    if (Platform.isAndroid) {
      PermissionStatus permission =
          await Permission.manageExternalStorage.request();
      log("Permission :: $permission");
      if (permission.isGranted) {
        log("Permission Granted !!");
        await downloadAndSaveImage(context, imageUrl);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Permission is denied $permission")));
      }
    } else {
      if (Platform.isIOS && Platform.isWindows) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Currently feature is not available")));
        // downloadAndSaveImage(imageUrl);
      }
    }
  }
}
