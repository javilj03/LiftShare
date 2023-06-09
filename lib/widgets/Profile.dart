import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:provider/provider.dart';
import './Profile/ProfileRoutine.dart';
import '../modules/User.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../providers/UserProvider.dart';
import 'Profile/FriendsList.dart';
import 'Profile/ProfilePosts.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  int index = 0;

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
          return SingleChildScrollView(
            controller: scrollController,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height -
                  kToolbarHeight -
                  kBottomNavigationBarHeight,
              child: Column(
                children: [
                  Container(
                    color: Color(ORANGE),
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  Text(user!.username,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                                  GestureDetector(
                                    onTap: () => {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (ctx) => FriendList(
                                                    user: user,
                                                  )))
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 208, 134, 14),
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
                                          Text(user.friends != null
                                              ? user.friends!.length.toString()
                                              : '0'),
                                          const SizedBox(height: 5),
                                          Text("Friends"),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          color: Color(ORANGE),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(user.email, textAlign: TextAlign.left,),
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
          );
        }
      },
    );
  }

  Future<User?> getUserData() async {
    final id =
        Provider.of<UserProvider>(context, listen: false).getUserProvider;
    var res = await http.get(Uri.parse('$URL_HEAD/api/getUser/$id'));
    var userData = json.decode(res.body);

    User? user;

    if (res.statusCode == 200) {
      var postAmount = userData['posts'].length;
      user = User(
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
    return user;
  }

  Widget _routineDisplay(ScrollController routineScrollController) {
    return ProfileRoutine(
      scrollController: routineScrollController,
    );
  }

  Widget _postsDisplay(ScrollController postScrollController) {
    return ProfilePosts(
      scrollController: postScrollController,
    );
  }
}
