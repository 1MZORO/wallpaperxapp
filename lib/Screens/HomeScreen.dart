import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaperxapp/ApiCalls/ApiCalls.dart';
import 'package:wallpaperxapp/Models/ImageModel.dart';
import 'package:wallpaperxapp/Screens/DetailScreen.dart';
import '../Providers/ConnectionProvider.dart';
import '../Utils/ConnectionFailed.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List images = [
  //   'assets/img/c1.jpg',
  //   'assets/img/c2.jpg',
  //   'assets/img/c4.jpg',
  //   'assets/img/c5.jpg',
  //   'assets/img/c6.jpg',
  //   'assets/img/c7.jpg',
  //   'assets/img/c8.jpg',
  // ];
  final apiCall = ApiCall();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool isConnected = Provider.of<ConnectivityProvider>(context).isConnected;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
          // backgroundColor: Colors.grey,
          appBar: AppBar(
            title: Text(
              'H o m e',
              style:
                  TextStyle(color: Theme.of(context).scaffoldBackgroundColor,fontFamily: 'MyFont',fontWeight: FontWeight.bold),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            centerTitle: true,
            elevation: 0,
            iconTheme: Theme.of(context).appBarTheme.iconTheme,
          ),
          body: Stack(children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(
                        text: "Home",
                      ),
                      Tab(
                        text: "Anime",
                      ),
                      Tab(
                        text: "Nature",
                      ),
                      Tab(
                        text: "Astrology",
                      ),
                    ],
                  ),
                  // 'https://picsum.photos/700?random=$index'
                  SizedBox(
                    height: 240,
                    child: CarouselView(
                        itemExtent: size.width - 32,
                        children: List.generate(6, (int index) {
                          // return Image.asset(images[index],fit: BoxFit.cover,) ;
                          String? url =
                              'https://picsum.photos/700?random=$index';
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => DetailScreen(url: url)));
                            },
                            child: CachedNetworkImage(
                              imageUrl: url,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Center(
                                child: Icon(Icons.broken_image, size: 50),
                              ),
                            ),
                          );
                        })),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildImageGrid(apiCall.fetchImages()),
                        _buildImageGrid(apiCall.searchImages('Anime')),
                        _buildImageGrid(apiCall.searchImages('Nature')),
                        _buildImageGrid(apiCall.searchImages('Astrology')),
                      ],
                    ),
                  ),

                ],
              ),
            ),
            if (!isConnected) ConnectionFailed()
          ])),
    );
  }
  Widget _buildImageGrid(Future<List<ImageModel>> ApiCall){
    return FutureBuilder<List<ImageModel>>(
      future: ApiCall,
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return Center(
              child:
              CircularProgressIndicator()); // Show loading indicator
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (!snapshot.hasData ||
            snapshot.data!.isEmpty) {
          return Text("No images found");
        } else {
          List<ImageModel> images = snapshot.data!;

          return GridView.builder(
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.7,
            ),
            itemCount: images.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // log("Index :: ${images[index].webformatURL} & $index");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => DetailScreen(
                              url: images[index]
                                  .largeImageURL)));
                },
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: images[index].webformatURL,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) =>
                      const Center(
                        child:
                        Icon(Icons.broken_image, size: 50),
                      ),
                    )),
              );
            },
          );
        }
      },
    );
  }
}
