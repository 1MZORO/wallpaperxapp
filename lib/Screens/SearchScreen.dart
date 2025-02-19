import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaperxapp/ApiCalls/ApiCalls.dart';
import 'package:wallpaperxapp/Models/ImageModel.dart';
import 'package:wallpaperxapp/Providers/SearchProvider.dart';
import 'DetailScreen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchClt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            SearchBar(
              hintText: 'Search',
              elevation: WidgetStatePropertyAll(0),
              controller: _searchClt,
              trailing: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: ()async{
                    searchProvider.changeLoading(true);
                    final apiCall = ApiCall();
                    List<ImageModel> newImages = await apiCall.searchImages(_searchClt.text);
                    searchProvider.changeImages(newImages);
                    searchProvider.changeLoading(false);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            if (searchProvider.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (searchProvider.images.isEmpty)
              const Center(child: Text("Currently no images found"))
            else
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: searchProvider.images.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                DetailScreen(url: searchProvider.images[index].largeImageURL),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: searchProvider.images[index].webformatURL,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => const Center(
                            child: Icon(Icons.broken_image, size: 50),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
