import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:local_database/model/Post_model.dart';

import '../sqlite_database/database_helper.dart';

class PostController extends GetxController {
  var posts = <PostModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    loadOfflinePosts();
    super.onInit();
  }

  /// Fetch Data from API
  Future<void> fetchPosts() async {
    isLoading.value = true;
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        posts.value = data.map((e) => PostModel.fromJson(e)).toList();
        await _saveToLocalDatabase();
      }
    } catch (e) {
      print("Error fetching data: $e");
    }

    isLoading.value = false;
  }

  /// Save Posts to SQLite
  Future<void> _saveToLocalDatabase() async {
    await DatabaseHelper.instance.clearPosts();
    for (var post in posts) {
      await DatabaseHelper.instance.insertPost(post);
    }
  }

  /// Load Posts from SQLite
  Future<void> loadOfflinePosts() async {
    final localData = await DatabaseHelper.instance.getPosts();
    posts.value = localData;
  }
}
