import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sm_delivery/components/basic_text.dart';
import 'package:sm_delivery/constants.dart/constants.dart';
import 'package:sm_delivery/core/theme/base_color.dart';
import 'package:sm_delivery/models/login_details/user_detail.dart';

class Document {
  final String title;
  final String imageUrl;

  Document({required this.title, required this.imageUrl});
}

class document_screen extends StatefulWidget {
  document_screen({super.key, this.userDetail});
  final userResponse? userDetail;

  @override
  State<document_screen> createState() => _document_screenState();
}

class _document_screenState extends State<document_screen> {
  List<Document> documents = [];
  @override
  void initState() {
    userStatus userstatus = widget.userDetail!.messages.status;
    documents = [
      Document(
          title: 'Addhar Front',
          imageUrl: '$base_url/uploads/${userstatus.storeFont}'),
      Document(
          title: 'Addhar',
          imageUrl: '$base_url/uploads/${userstatus.adharBack}'),
      Document(
          title: 'Store Image',
          imageUrl: '$base_url/uploads/${userstatus.storeImage}'),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: kToolbarHeight,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back, size: 30, color: Colors.white)),
        title: basic_text(
          title: 'Documents',
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.primarycolor2,
      ),
      body: ListView.builder(
        itemCount: documents.length,
        itemBuilder: (context, index) {
          final document = documents[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      ListTile(
                        title: basic_text(
                            title: document.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500)),
                      ),
                      CachedNetworkImage(
                        imageUrl: document.imageUrl,
                        height: MediaQuery.of(context).size.height * 0.2,
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class document_viewer_screen extends StatelessWidget {
  final Document document;

  document_viewer_screen({required this.document});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(document.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              document.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Center(
                child: Image.network(document.imageUrl),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
