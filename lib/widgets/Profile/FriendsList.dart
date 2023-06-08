import 'package:flutter/material.dart';
import 'package:liftShare/widgets/Search/ProfileSearched.dart';
import '../../constants.dart';
import '../../providers/UserProvider.dart';
import '../../modules/User.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'FriendRequests.dart';

class FriendList extends StatefulWidget {
  final User user;
  const FriendList({required this.user});

  @override
  State<FriendList> createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  TextEditingController searchController = TextEditingController();
  List<User> users = [];
  List<User> usersSearched = [];
  bool isLoading = false;
  bool isSearched = false;

  @override
  void initState() {
    super.initState();
    getFriendsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Amigos'),
        elevation: 0,
        backgroundColor: Color(ORANGE),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              print('Opción seleccionada: $value');
              switch (value) {
                case 'Solicitudes':
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (ctx) => FriendRequests(user: widget.user)),
                  );
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'Solicitudes',
                  child: Text('Ver solicitudes de amistad'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey[200],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      _submitSearch();
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Buscar',
                        contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              CircularProgressIndicator()
            else
              Expanded(
                child: isSearched == false
                    ? ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (ctx) => ProfileSearched(
                                          id: users[index].id!,
                                        )),
                              )
                            },
                            child: Container(
                              height: 75,
                              width: double.infinity,
                              child: Card(
                                color: Colors.grey[500],
                                child: Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(Icons.account_circle),
                                    ),
                                    Text(users[index].username),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : ListView.builder(
                        itemCount: usersSearched.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (ctx) => ProfileSearched(
                                          id: usersSearched[index].id!,
                                        )),
                              )
                            },
                            child: Container(
                              height: 75,
                              width: double.infinity,
                              child: Card(
                                color: Colors.grey[500],
                                child: Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(Icons.account_circle),
                                    ),
                                    Text(usersSearched[index].username),
                                  ],
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

  Future<void> getFriendsData() async {
    if (!mounted) return; // Verificar si el widget está montado
    setState(() {
      isLoading = true;
    });

    String id =
        Provider.of<UserProvider>(context, listen: false).getUserProvider;
    final url = '$URL_HEAD/api/getFriends/$id';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> userData = json.decode(response.body);
        List<User> userList = [];
        print(userData);
        for (var item in userData) {
          User user = User(
            id: item['_id'],
            name: item['name'] ?? 'no tiene username',
            lastName: item['lastName'] ?? 'no tiene username',
            email: item['email'] ?? 'no tiene username',
            username: item['username'] ?? 'no tiene username',
            password: item['password'],
            weight: double.tryParse(item['weight']?.toString() ?? '1') ?? 1,
            height: double.tryParse(item['height']?.toString() ?? '1') ?? 1,
            visibility: true,
          );
          userList.add(user);
        }

        if (!mounted) return; // Verificar de nuevo si el widget está montado
        setState(() {
          users = userList;
        });
      } else {
        print('Error de peticion');
        print('Error: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }

    if (!mounted) return; // Verificar nuevamente si el widget está montado
    setState(() {
      isLoading = false;
    });
  }

  void _submitSearch() {
    users.map((e) => {
          if (e.username == searchController.text) {usersSearched.add(e)}
        });
    setState(() {
      isSearched = true;
    });
  }
}
