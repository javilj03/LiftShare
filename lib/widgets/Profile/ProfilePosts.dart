import 'package:flutter/material.dart';
import 'package:liftShare/providers/UserProvider.dart';
import '../../constants.dart';
import '../../modules/Post.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ProfilePosts extends StatelessWidget {
  final ScrollController scrollController;
  final String? userId;
  ProfilePosts({required this.scrollController, this.userId});

  @override
  Widget build(BuildContext context) {
    Future<List<Post>> getPostsData() async {
      List<Post> posts = [];
      try {
        if (userId != null) {
          var res = await http.get(Uri.parse('$URL_HEAD/api/getPosts/$userId'));

          if (res.statusCode == 200) {
            List<dynamic> data = jsonDecode(res.body);

            // Recorre cada objeto obtenido y crea un objeto Routine
            for (var item in data) {
              Post post = Post(
                id: item['_id'],
                image: item['image'],
                title: item['title'],
                owner: item['owner'],
              );
              posts.add(post);
            }
            return posts;
          } else {
            print('Error de peticion: ${res.body}');
          }
        } else {
          var id =
              Provider.of<UserProvider>(context, listen: false).getUserProvider;
          var res = await http.get(Uri.parse('$URL_HEAD/api/getPosts/$id'));
          if (res.statusCode == 200) {
            List<dynamic> data = jsonDecode(res.body);
            // Recorre cada objeto obtenido y crea un objeto Routine
            var postsDecoded = jsonDecode(res.body);
            for (var p in postsDecoded) {
              Post post = Post(
                  title: p['title'],
                  id: p['_id'],
                  image: p['image'],
                  owner: p['owner']);

              posts.add(post);
            }
            return posts;
          } else {
            print('Error de peticion: ${res.body}');
          }
        }
      } catch (err) {
        print(err);
      }
      return [];
    }

    return FutureBuilder<List<Post>>(
      future: getPostsData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Mostrar un indicador de carga mientras se espera la respuesta de getUser()
        } else if (snapshot.hasError) {
          return Text(
              'Error: ${snapshot.error}'); // Manejar errores de obtener la información del usuario
        } else {
          List<Post> postsList = snapshot.data as List<Post>;
          return ListView.builder(
            controller: scrollController,
            itemCount: postsList.length,
            itemBuilder: (context, index) {
              Post post = postsList[index];
              return Column(
                children: [
                  _PostCardProfile(post, context),
                ],
              );
            },
          );
        }
      },
    );
  }

  Widget _PostCardProfile(Post post, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Card(
        color: Colors.blueGrey,
        elevation: 8,
        child: Column(
          children: [
            ListTile(
                leading: Icon(Icons.account_circle),
                title: Text(post.owner['username']),
                subtitle: Text(post.title),
                onTap: () => AlertDialog(
                      title: Text('¿Deseas eliminar esta publicación?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            _deletePost(post);
                            Navigator.of(context).pop();
                          },
                          child: Text('Eliminar'),
                        ),
                      ],
                    )),
            Container(
              width: double.infinity,
              child: Image.network(
                post.image,
                fit: BoxFit
                    .cover, // Ajusta el tamaño de la imagen para cubrir el espacio disponible
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _deletePost(Post post) async{
    
  }
}
