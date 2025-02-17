import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/post_controller.dart';

class HomeScreen extends StatelessWidget {
  final PostController postController = Get.put(PostController());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Offline JSON Data (SQLite)")),
      body: Obx(() {
        if (postController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return postController.posts.isEmpty
            ? Center(child: Text("No Data Available"))
            : ListView.builder(
              itemCount: postController.posts.length,
              itemBuilder: (context, index) {
                final post = postController.posts[index];
                return ListTile(
                  title: Text(post.title),
                  subtitle: Text(post.body),
                );
              },
            );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => postController.fetchPosts(),
        child: Icon(Icons.cloud_download),
      ),
    );
  }
}
