import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaperxapp/ApiCalls/ApiCalls.dart';
import 'package:wallpaperxapp/Models/ImageModel.dart';
import 'package:wallpaperxapp/Screens/DetailScreen.dart';

import '../Providers/ConnectionProvider.dart';
import '../Utils/ConnectionFailed.dart';
import '../Utils/ConnectivityService.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final apiCall = ApiCall();

  @override
  void initState() {
    final connectivityService = ConnectivityService();
    connectivityService.startListening();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isConnected = Provider.of<ConnectivityProvider>(context).isConnected;
    return Scaffold(
      // backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text(
          'H O M E',
          style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        elevation: 0,
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
      ),
        body: Stack(
          children: [
           Container(
            margin: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
            child: Column(
              children: [
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
            ),
          ),
            if (!isConnected) ConnectionFailed()
    ]
        ));
  }

}
