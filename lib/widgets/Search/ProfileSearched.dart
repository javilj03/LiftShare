import 'package:flutter/material.dart';
import '../../constants.dart';
import 'package:provider/provider.dart';
import '../Profile/ProfileRoutine.dart';
import '../../modules/User.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../providers/UserProvider.dart';
import '../Profile/ProfilePosts.dart';

class ProfileSearched extends StatefulWidget {
  final String id;
  const ProfileSearched({required this.id});

  @override
  State<ProfileSearched> createState() => _ProfileSearchedState();
}

class _ProfileSearchedState extends State<ProfileSearched>
    with SingleTickerProviderStateMixin {
  int index = 0;
  bool isFriend = false;
  late TabController tabController;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, initialIndex: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Mostrar un indicador de carga mientras se espera la respuesta de getUser()
        } else if (snapshot.hasError) {
          return Text(
              'Error: ${snapshot.error}'); // Manejar errores de obtener la información del usuario
        } else {
          final user = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: const Text('User profile'),
              backgroundColor: Color(ORANGE),
              elevation: 0,
            ),
            body: SingleChildScrollView(
              controller: scrollController,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Container(
                        height: 50,
                        width: double.infinity,
                        color: Colors.orange[300],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Estado de amigo: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return returnDialog(user!);
                                    },
                                  );
                                },
                                child: Text(
                                  isFriend == true ? 'Siguiendo' : 'Seguir',
                                  style: TextStyle(color: Color(ORANGE)),
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white),
                              ),
                            )
                          ],
                        )),
                    Container(
                      color: Color(ORANGE),
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CircleAvatar(
                                  radius: 45,
                                  backgroundImage: NetworkImage(
                                      "https://images.unsplash.com/photo-1564564295391-7f24f26f568b"),
                                ),
                                const SizedBox(height: 10),
                                Text(user!.username),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 208, 134, 14),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(
                                            BLACK), // Utilizamos Colors.black para el color negro
                                        offset: Offset(0, 2),
                                        blurRadius: 2,
                                        spreadRadius: -1,
                                      ),
                                    ],
                                  ),
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      Text(user.posts != null
                                          ? user.posts!.length.toString()
                                          : '0'),
                                      const SizedBox(height: 5),
                                      Text(
                                        "Posts",
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 208, 134, 14),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(BLACK),
                                        offset: Offset(0, 2),
                                        blurRadius: 2,
                                        spreadRadius: -1,
                                      ),
                                    ],
                                  ),
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      Text(user.friends != null
                                          ? user.friends!.length.toString()
                                          : '0'),
                                      const SizedBox(height: 5),
                                      Text("Friends"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Color(ORANGE),
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 9,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(user.email),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Color(ORANGE),
                      child: TabBar(
                        indicatorColor: Colors.white,
                        indicatorWeight: 0.8,
                        indicatorPadding: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        controller: tabController,
                        tabs: const [
                          Tab(icon: Icon(Icons.camera_alt)),
                          Tab(icon: Icon(Icons.calendar_month)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          _postsDisplay(scrollController),
                          _routineDisplay(scrollController),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Future<User?> getUserData() async {
    var res = await http.get(Uri.parse('$URL_HEAD/api/getUser/${widget.id}'));
    var userData = json.decode(res.body);
    User? user;

    if (res.statusCode == 200) {
      var postAmount = userData['posts'].length;
      user = User(
          id: userData['_id'],
          name: userData['name'],
          lastName: userData['lastName'],
          email: userData['email'],
          username: userData['username'],
          password: userData['password'],
          weight: double.parse(userData['weight'].toString()),
          height: double.parse(userData['height'].toString()),
          visibility: true,
          routines: userData['routines'],
          posts: userData['posts'],
          friends: userData['friends'],
          friendRequests: userData['friend_request']);
    }
    if (user!.friends != null) {
      if (user.friends!.isNotEmpty) {
        final id =
            Provider.of<UserProvider>(context, listen: false).getUserProvider;

        if (user.friends!.contains(id)) {
          print('es pana');
          isFriend = true;
        }
      }
    }
    return user;
  }

  Widget _routineDisplay(ScrollController routineScrollController) {
    return ProfileRoutine(
      scrollController: routineScrollController,
      userId: widget.id,
    );
  }

  Widget _postsDisplay(ScrollController postsScrollController) {
    return ProfilePosts(
      scrollController: postsScrollController,
      userId: widget.id);
  }

  Future<void> handleSubmit(String modo, String friendId) async {
    final id =
        Provider.of<UserProvider>(context, listen: false).getUserProvider;
    if (modo == 'eliminar') {
      final res = await http.put(Uri.parse('$URL_HEAD/api/removeFriend/$id'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(
            {
              'friendId': friendId,
            },
          ));
          print(json.decode(res.body));
    }else if (modo == 'agregar'){
      final res = await http.put(Uri.parse('$URL_HEAD/api/sendFriendRequest/$id'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(
            {
              'friendId': friendId,
            },
          ));
          print(res.body);
    }
  }

  Widget returnDialog(User user) {
    if (isFriend == true) {
      return AlertDialog(
        title: Text('¿Estas seguro?'),
        content: Text('${user.username} será eliminado de amigos'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              handleSubmit('eliminar', user.id!);
              Navigator.of(context).pop();
            },
            child: Text('Eliminar'),
          ),
        ],
      );
    } else {
      return AlertDialog(
        title: Text('Se mandará una solicitud a ${user.username}'),
        content: Text('¿Estás seguro?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              handleSubmit('agregar', user.id!);
              Navigator.of(context).pop();
            },
            child: Text('Enviar'),
          ),
        ],
      );
    }
  }
}
