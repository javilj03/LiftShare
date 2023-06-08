import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widgets/Search/ProfileSearched.dart';
import 'dart:convert';
import '../constants.dart';
import 'Profile.dart';

class Search extends StatefulWidget {
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final textController = TextEditingController();
  List<String> userNames = [];
  List<String> userIds = [];

  void makeHttpRequest() async {
    var url = Uri.parse('$URL_HEAD/api/searchUsername/${textController.text}');
    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        print(data);
        if(data.isNotEmpty){
          setState(() {
          // Parsea la respuesta y actualiza la lista de nombres de usuario
          
          userNames = data.map((user) => user['username'] as String).toList();
          userIds = data.map((e) => e['_id'] as String).toList();
        });
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No se han encontrado usuarios', textAlign: TextAlign.center,),
            duration: Duration(seconds: 3), // Duración del SnackBar
          ),
        );
        }
        
      } else {
        print('Ha ocurrido un error');
        print(response.body);
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  makeHttpRequest();
                },
              ),
              Expanded(
                child: TextField(
                  controller: textController,
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
        Expanded(
          child: ListView.builder(
            itemCount: userNames.length,
            itemBuilder: (context, index) {
              return UserCard(
                userNames[index],
                userIds[index],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget UserCard(String name, String id) {
    return GestureDetector(
      onTap: () => {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (ctx) => ProfileSearched(id: id,))),
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
              Text(name),
            ],
          ),
        ),
      ),
    );
  }
}
