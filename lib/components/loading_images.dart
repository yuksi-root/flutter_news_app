import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class LoadingImages extends StatelessWidget {
  final imageUrl;
  const LoadingImages({Key? key, required this.imageUrl}) : super(key: key);
// child:Image.network(listViewModel.articles[index].imageUrl)
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: this.imageUrl,
      imageBuilder: (context, imageProvider) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        );
      },
      placeholder: (context, url) => Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
