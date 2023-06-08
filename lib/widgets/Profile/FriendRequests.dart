import 'package:flutter/material.dart';
import '../../modules/User.dart';
import '../../constants.dart';
import '../../providers/UserProvider.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FriendRequests extends StatefulWidget {
  final User user;
  const FriendRequests({required this.user});

  @override
  State<FriendRequests> createState() => _FriendRequestsState();
}

class _FriendRequestsState extends State<FriendRequests> {
  TextEditingController searchController = TextEditingController();
  List<User> users = [];
  List<User> usersSearched = [];
  bool isLoading = false;
  bool isSearched = false;

  @override
  void initState() {
    super.initState();
    getFriendRequestData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitudes de amistad'),
        elevation: 0,
        backgroundColor: Color(ORANGE),
      ),
      body: Container(
        child: Column(
          children: [
            if (isLoading)
              CircularProgressIndicator()
            else
              Expanded(
                  child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 75,
                    width: double.infinity,
                    child: Card(
                      color: Colors.grey[500],
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.account_circle),
                          ),
                          Expanded(
                            child: Text(users[index].username),
                          ),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              removeRequest(users[index].id!);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () {
                              acceptRequest(users[index].id!);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ))
          ],
        ),
      ),
    );
  }

  Future<void> getFriendRequestData() async {
    if (!mounted) return; // Verificar si el widget está montado
    setState(() {
      isLoading = true;
    });

    String id =
        Provider.of<UserProvider>(context, listen: false).getUserProvider;
    final url = '$URL_HEAD/api/getFriendRequest/$id';

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

  Future<void> removeRequest(String idRequest) async {
    try {
      String userId =
          Provider.of<UserProvider>(context, listen: false).getUserProvider;
      var res = http.put(
        Uri.parse('$URL_HEAD/api/removeRequest/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {'friendId': idRequest},
        ),
      );
      print(res);
      users.map((e) => {
            if (e.id == idRequest)
              {
                setState(() {
                  users.remove(e);
                }),
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Se ha eliminado la solicitud de amistad de ${e.username}',
                      textAlign: TextAlign.center,
                    ),
                    duration: Duration(seconds: 4), // Duración del SnackBar
                  ),
                )
              }
          });
    } catch (err) {
      print(err);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Ha ocurrido un error al realizar la operación',
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 4), // Duración del SnackBar
        ),
      );
    }
  }

  Future<void> acceptRequest(String idRequest) async {
    try {
      String userId =
          Provider.of<UserProvider>(context, listen: false).getUserProvider;
      var res = http.put(
        Uri.parse('$URL_HEAD/api/acceptRequest/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {'friendId': idRequest},
        ),
      );
      print(res);
      users.map((e) => {
            if (e.id == idRequest)
              {
                setState(() {
                  users.remove(e);
                }),
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${e.username} ha sido agregado correctamente',
                      textAlign: TextAlign.center,
                    ),
                    duration: Duration(seconds: 4), // Duración del SnackBar
                  ),
                )
              }
          });
    } catch (err) {
      print(err);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Ha ocurrido un error al realizar la operación',
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 4), // Duración del SnackBar
        ),
      );
    }
  }
}
