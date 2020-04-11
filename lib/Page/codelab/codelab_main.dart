
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CodeLab extends StatefulWidget {
  @override
  _CodeLabState createState() => _CodeLabState();
}
class _CodeLabState extends State<CodeLab> {

  File image;
  File compressedImage;
  bool status = false;

  Future getImage()async{
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    var dir = await getTemporaryDirectory();
    String path = dir.path + "myimage.webp";

    File newImage = await FlutterImageCompress.compressAndGetFile(
      tempImage.path, 
      path,
      format: CompressFormat.webp,
      minHeight: 800,
      minWidth: 800,
      quality: 80
      );

    setState(){
      image = tempImage;
      compressedImage = newImage;
      status = true;
    }

  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Center(
            child: image == null ? Text("There is no image selected") : Image.file(image)
          ),
          Center(
            child: image == null ? Text("There is no compressed image") : Image.file(compressedImage)
          ),
          RaisedButton(
            child: Text("Select"),
            onPressed: getImage
          ),
          status == false ? Text("") : RaisedButton(child: Text("Upload"),onPressed: uploadImage),

        ],

      ),

      
    );
  }

  uploadImage(){
    final StorageReference ref = FirebaseStorage.instance.ref().child("myimage.webp");
    final StorageUploadTask task = ref.putFile(image);
  }
}