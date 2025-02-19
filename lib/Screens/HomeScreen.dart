import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallpaperxapp/ApiCalls/ApiCalls.dart';
import 'package:wallpaperxapp/Models/ImageModel.dart';
import 'package:wallpaperxapp/Screens/DetailScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final apiCall = ApiCall();

  //
  // @override
  // void initState() {
  //   apiCall.fetchImages();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [

            SearchBar(),
            Expanded(
              child: FutureBuilder<List<ImageModel>>(
                    future: apiCall.fetchImages(),
                    builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator()); // Show loading indicator
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text("No images found");
              } else {
                List<ImageModel> images = snapshot.data!;
              
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: (){
                        // log("Index :: ${images[index].webformatURL} & $index");
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>DetailScreen(url: images[index].largeImageURL)));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: images[index].webformatURL,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => const Center(
                            child: Icon(Icons.broken_image, size: 50),
                          ),
                        )
                      ),
                    );
                  },
                );
              }
                    },
                  ),
            ),
          ],
        ));
  }
}
