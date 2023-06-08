import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liftShare/constants.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../../providers/UserProvider.dart';
import 'package:http/http.dart' as http;

class ImageInput extends StatefulWidget {
  final Function(File)? onImageSelected;
  const ImageInput({this.onImageSelected});

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;

  void _takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _selectedImage = File(pickedImage.path);
      widget.onImageSelected!(_selectedImage!);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      onPressed: _takePicture,
      icon: Icon(Icons.camera),
      label: const Text('Hacer foto'),
    );
    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: _takePicture,
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      height: 400,
      width: double.infinity,
      alignment: Alignment.center,
      child: content,
    );
  }
}
