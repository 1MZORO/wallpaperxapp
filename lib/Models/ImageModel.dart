class ImageModel {
  final int id;
  final String pageURL;
  final String type;
  final String previewURL;
  final String webformatURL;
  final String largeImageURL;

  ImageModel({
    required this.id,
    required this.pageURL,
    required this.type,
    required this.previewURL,
    required this.webformatURL,
    required this.largeImageURL,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'],
      pageURL: json['pageURL'],
      type: json['type'],
      previewURL: json['previewURL'],
      webformatURL: json['webformatURL'],
      largeImageURL: json['largeImageURL'],
    );
  }
}
