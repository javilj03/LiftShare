import 'dart:io';
import 'package:flutter/material.dart';
import 'Camera/Image_input.dart';
import '../constants.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../providers/UserProvider.dart';
import 'dart:convert';
import 'package:requests/requests.dart';
import 'package:dio/dio.dart' as dio;

class Camera extends StatefulWidget {
  const Camera({super.key});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  final _titleController = TextEditingController();
  File? selectedImage;
  void onImageSelected(File file) {
    setState(() {
      selectedImage = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
              controller: _titleController,
            ),
            const SizedBox(height: 16),
            ImageInput(onImageSelected: onImageSelected),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                _uploadImage();
              },
              label: const Text('Subir'),
              icon: const Icon(Icons.check),
              style: ElevatedButton.styleFrom(backgroundColor: Color(ORANGE)),
            )
          ],
        ));
  }

  Future<void> _uploadImage() async {
    try {
      String userId =
          Provider.of<UserProvider>(context, listen: false).getUserProvider;
      String url = 'http://44.197.8.254:3000/api/upload/$userId';

      String fileName = selectedImage!.path.split('/').last;

      dio.FormData formData = dio.FormData();
      formData.fields.addAll([
        MapEntry('title', _titleController.text),
        MapEntry('date', DateTime.now().toString())
      ]);
      formData.files.add(MapEntry(
        'image',
        await dio.MultipartFile.fromFile(selectedImage!.path,
            filename: fileName),
      ));

      dio.Dio dioClient = dio.Dio();
      var response = await dioClient.post(
        url,
        data: formData,
        onSendProgress: (count, total) => {print('$count, $total')},
      );

      print(response.data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Imagen añadida correctamente',
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 4), // Duración del SnackBar
        ),
      );
      selectedImage = null;
      _titleController.text = '';
    } catch (err) {
      print(err);
    }
  }
}
