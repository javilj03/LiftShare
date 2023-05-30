import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Post extends StatefulWidget {
  const Post({super.key});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  // late List<CameraDescription> cameras;
  // late CameraController cameraController;

  // @override
  // void initState() {
  //   super.initState();
  //   setupCamera();
  // }

  // Future<void> setupCamera() async {
  //   cameras = await availableCameras();
  //   cameraController = CameraController(cameras[0], ResolutionPreset.medium);
  //   await cameraController.initialize();
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  // Future<void> takePicture() async {
  //   if (!cameraController.value.isInitialized) {
  //     return;
  //   }
  //   final Directory? extDir = await getExternalStorageDirectory();
  //   final String dirPath = '${extDir!.path}/Pictures/flutter_camera';
  //   await Directory(dirPath).create(recursive: true);
  //   final String filePath =
  //       '$dirPath/${DateTime.now().millisecondsSinceEpoch}.jpg';

  //   try {
  //     await cameraController.takePicture();
  //     // Aquí puedes realizar otras acciones con la imagen, como mostrarla en otra pantalla o guardar su ruta en una lista para mostrar todas las imágenes capturadas.
  //     // Además, puedes utilizar el paquete `image_gallery_saver` para guardar la imagen en la galería.
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // @override
  // void dispose() {
  //   cameraController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // if (cameraController == null || !cameraController.value.isInitialized) {
    //   return Container();
    // }
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('Camera Example'),
    //   ),
    //   body: AspectRatio(
    //     aspectRatio: cameraController.value.aspectRatio,
    //     child: CameraPreview(cameraController),
    //   ),
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: () {
    //       takePicture();
    //     },
    //     child: Icon(Icons.camera),
    //   ),
    // );
    return Container(child: Text('Hola'),);
  }
}
