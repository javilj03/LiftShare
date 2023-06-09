import 'package:flutter/material.dart';
import 'package:liftShare/constants.dart';
import 'package:liftShare/providers/UserProvider.dart';
import '../../modules/Post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key});

  @override
  Widget build(BuildContext context) {
    Future<List<Post>> _getPosts() async {
      List<Post> postsList = [];
      var id =
          Provider.of<UserProvider>(context, listen: false).getUserProvider;

      try {
        var res =
            await http.get(Uri.parse('$URL_HEAD/api/getPostFromFriends/$id'));
        if (res.statusCode == 200) {
          var postsDecoded = jsonDecode(res.body);
          for (var p in postsDecoded) {
            Post post = Post(
                title: p['title'],
                id: p['_id'],
                image: p['image'],
                owner: p['owner']);

            postsList.add(post);
          }
        } else {
          print('Error in request: ${res.body}');
        }
      } catch (err) {
        print(err);
      }

      return postsList;
    }

    return FutureBuilder<List<Post>>(
      future: _getPosts(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else {
          final posts = snapshot.data!;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              print(posts);
              return Container(
                padding: EdgeInsets.all(8),
                child: Card(
                  color: Colors.blueGrey[100],
                  elevation: 8,
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(posts[index].owner['username']),
                        subtitle: Text(posts[index].title),
                      ),
                      Container(
                        width: double.infinity,
                        child: Image.network(
                          posts[index].image,
                          fit: BoxFit
                              .cover, // Ajusta el tamaño de la imagen para cubrir el espacio disponible
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
