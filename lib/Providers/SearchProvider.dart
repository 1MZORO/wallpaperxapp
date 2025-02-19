import 'package:flutter/cupertino.dart';
import 'package:wallpaperxapp/Models/ImageModel.dart';

class SearchProvider extends ChangeNotifier{
  bool _isLoading = false;
  List<ImageModel> _images = [];

  List<ImageModel> get images  => _images;
  bool get isLoading => _isLoading;

  void changeImages(List<ImageModel> image){
    _images = image;
    notifyListeners();
  }

  void changeLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}