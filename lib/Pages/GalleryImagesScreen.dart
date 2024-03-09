//
// // Not Working Code // Api issue int value
//
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

 class GalleryImageScreen extends StatefulWidget {
  final String device;
  final String title;
  final int postId;
  const GalleryImageScreen({
    super.key,
    required this.device,
    required this.postId,
    required this.title,
  });
  @override
  State<GalleryImageScreen> createState() => _GalleryImageScreenState();
}

class _GalleryImageScreenState extends State<GalleryImageScreen> {
  bool isLoading = false;
  List<Map<String, dynamic>> galleryImages = [];
  @override
  void initState() {
    super.initState();
    getGallery1();
  }

  Future<void> getGallery1() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usertoken = prefs.getString('token');
    if (usertoken != null) {
      final Uri uri = Uri.parse("https://madadguru.webkype.net/api/getGallery");
      try {
        final response = await http.post(uri, headers: {
          'Authorization': 'Bearer $usertoken',
        }, body: {
          "category_id": widget.postId.toString(),
        });
        if (response.statusCode == 200) {
          var responseData = json.decode(response.body);
          print("gallerdata $responseData");
          List<dynamic> data = responseData['data'] ?? [];
          setState(() {
            galleryImages = List<Map<String, dynamic>>.from(data);
          });
          print('galleryImagesList: $galleryImages');
          print('Data fetched successfully');
          print(response.body);
        } else {
          print('Failed to fetch data. Status code: ${response.statusCode}');
        }
      } catch (error) {
        print('Error fetching data: $error');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded),
            onSelected: (value) {
              switch (value) {
                case 'Change album cover':
                  break;
                case 'Hide dates':
                  break;
                case 'Sort':
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'Change album cover',
                child: Text('Change album cover'),
              ),
              PopupMenuItem<String>(
                value: 'Hide dates',
                child: Text('Hide dates'),
              ),
              PopupMenuItem<String>(
                value: 'Sort',
                child: Text('Sort'),
              ),
            ],
          ),
         ],
        ),
        body: buildListView(),
       );
       }

      Widget buildListView() {
      return galleryImages.isEmpty
        ? Padding(
          padding: const EdgeInsets.only(top: 250),
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.indigo[400],
              ),
             ),
            )
            : galleryImages.length == 0
            ? Padding(
               padding: const EdgeInsets.only(top: 100),
                  child: Center(
                    child: Text(
                      'No Post Available',
                      style: TextStyle(fontSize: 25),
                  ),
                ),
              )
            : GridView.builder(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: galleryImages.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 0.0,
                  mainAxisSpacing: 0.0,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => photoView(
                          index: index,
                          id: galleryImages[index]["id"],
                          image: galleryImages,
                        ),
                      ),
                    ),
                    child: Card(
                      // margin: EdgeInsets.all(10),
                      elevation: 2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          // decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                          child:


                              Image.network(
                            (galleryImages[index]["image"] != null)
                                ? galleryImages[index]["image"]
                                : 'Name not available',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                });
  }
}

class photoView extends StatefulWidget {
  final int index;
  final List image;
  final int id;
  const photoView({
    Key? key,
    required this.index,
    required this.image,
    required this.id,
  }) : super(key: key);
  @override
  State<photoView> createState() => _photoViewState();
}

class _photoViewState extends State<photoView> {
  PageController _pageController = PageController();
  late double scaleCopy;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.index);

  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void listener(PhotoViewControllerValue index, id) {
    setState(() {
      scaleCopy = id.scale!;
    });
  }

  double _rotationAngle = 0.0;
  void _rotateImage() {
    setState(
      () {
        _rotationAngle += 90.0;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.rotate_right),
            onPressed: _rotateImage,
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share('Check out this amazing image!');
            },
          ),
        ],
        backgroundColor: Colors.grey.shade200,
        elevation: 0,
      ),
      body: Container(
        child: PageView.builder(
          controller: _pageController,
          itemCount: widget.image.length,
          itemBuilder: (BuildContext context, int index) {
            return Transform.rotate(
              angle: _rotationAngle * (3.1415926535 / 180),
              child: PhotoView(
                imageProvider: NetworkImage(widget.image[index]["image"]),
                initialScale: PhotoViewComputedScale.contained * 1.0,
              ),
            );
          },
        ),

      ),
    );
  }
}
