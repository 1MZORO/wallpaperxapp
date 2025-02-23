import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaperxapp/ApiCalls/ApiCalls.dart';
import 'package:wallpaperxapp/Utils/ConnectionFailed.dart';
import '../Providers/ConnectionProvider.dart';

class DetailScreen extends StatelessWidget {
  final String url;
  const DetailScreen({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    bool isConnected = Provider.of<ConnectivityProvider>(context).isConnected;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('D o w n l o a d',style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor,fontFamily: 'MyFont',fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_rounded,color: Theme.of(context).scaffoldBackgroundColor,)),
      ),
      body: Stack(
        children:[ SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: size.width *.03),
            child: Column(
              children: [
                Container(
                  height: size.height * .8,
                  width: size.width * .9,
                  margin: EdgeInsets.all(12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                      // placeholder: (context,url)=>Center(child: CircularProgressIndicator(),),
                      errorWidget: (context, url, error) => const Center(
                        child: Icon(Icons.broken_image, size: 80),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: ()async {
                      final apiCall = ApiCall();
                      await apiCall.downloadAndSaveImage(context, url);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Theme.of(context).scaffoldBackgroundColor,
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      minimumSize: Size(size.width*.88, 50),
                      maximumSize: Size(double.infinity, 50),
                    ),
                    child: Text('Save in Gallery',style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor,fontFamily: 'MyFont',fontWeight: FontWeight.bold,fontSize: 18),)),
                SizedBox(
                  height: 10,
                ),
                /*
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: GestureDetector(
                        onTap: (){
                          // final apiCall = ApiCall();
                          // apiCall.setWallpaper(context, url);
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.lightBlue,
                          ),
                          child: Text(
                            'Set Wallpaper',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.lightBlue,
                        ),
                        child: Center(
                          child: IconButton(
                            icon: Icon(
                              Icons.share,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                */
              ],
            ),
          ),
        ),
          if(!isConnected) ConnectionFailed()
    ]
      ),
    );
  }
}
