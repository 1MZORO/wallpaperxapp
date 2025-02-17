import 'package:flutter/material.dart';
import 'package:wallpaperxapp/ApiCalls/ApiCalls.dart';
import 'package:wallpaperxapp/Models/ImageModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final apiCall = ApiCall();
  final data = ImageModel;

  void loadImages() async {
    List<ImageModel> images = await apiCall.fetchImages();
    for (var image in images) {
      print(image.previewURL);  // Assuming ImageModel has a field named `url`
    }
  }

  @override
  void initState() {
    apiCall.fetchImages();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<ImageModel>>(
        future: apiCall.fetchImages(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Show loading indicator
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text("No images found");
          } else {
            List<ImageModel> images = snapshot.data!;
            return ListView.builder(
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Image.network(images[index].previewURL); // Assuming ImageModel has `url`
              },
            );
          }
        },
      )

    );
  }
}
