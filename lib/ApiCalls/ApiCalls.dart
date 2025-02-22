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
  String url = "https://pixabay.com/api/?key=";
  String key = "48876447-768da478662460195df17d214";
  String and = "&q=";

  Future<List<ImageModel>> fetchImages() async {
    try {
      final response =
          await dio.get("$url$key", queryParameters: {"page": 1, "per_page": 100});
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

  Future<List<ImageModel>> searchImages(String text) async {
    try {
      log(text);
      log("$url$key$and$text");
      final response =
      await dio.get("$url$key$and$text", queryParameters: {"page": 1, "per_page": 100});
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
            SnackBar(content: Text("Permission denied: $status")),
          );
          return;
        }

        var response = await dio.get(
          url,
          options: Options(responseType: ResponseType.bytes),
        );

        final result = await ImageGallerySaverPlus.saveImage(
          Uint8List.fromList(response.data),
          quality: 60,
          name: "wallpaper",
        );

        if (result != null && result['isSuccess'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Image saved in gallery!")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to save image.")),
          );
        }
      }
    } on DioException catch (e) {
      log("Dio Error: ${e.message}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Download failed: ${e.message}")),
      );
    } catch (e) {
      log("Error: ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Unable to download image.")),
      );
    }
  }

  Future<void> requestStoragePermission(BuildContext context, String imageUrl) async {
    if (Platform.isAndroid) {
      PermissionStatus permission = await Permission.manageExternalStorage.request();
      log("Permission: $permission");

      if (permission.isGranted) {
        log("Permission Granted!");
        await downloadAndSaveImage(context, imageUrl);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Permission denied: $permission")),
        );
      }
    } else if (Platform.isIOS || Platform.isWindows) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Feature not available on this platform.")),
      );
    }
  }

  /*
  Future<void> setWallpaper(BuildContext context, String imageUrl) async {
    try {
      final response = await Dio().get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes), // Important for binary data
      );
      log("1");
      final directory = await getTemporaryDirectory();
      final filePath = "${directory.path}/wallpaper.jpg";
      File file = File(filePath);
      await file.writeAsBytes(Uint8List.fromList(response.data));
      log("2");

      int location = WallpaperManagerFlutter.HOME_SCREEN;
      await WallpaperManagerFlutter().setwallpaperfromFile(file.path.toString(), location);
      log("1");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Wallpaper Set Successfully!")),
      );

    } catch (e) {
      log(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to Set Wallpaper: $e")),
      );
    }
  }
*/

}