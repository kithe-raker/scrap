import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class ResizeImage {
  ///resize image required [image] file , you can pass image [quality] 0-100
  ///default is 60 and image [type] default is webp this will return a resized Image
  Future<File> resize(
      {@required File image, int quality = 60, String type = 'webp'}) async {
    var dir = await getTemporaryDirectory();
    String path = "${dir.path}/resizeImage.$type";
    File newImage = await FlutterImageCompress.compressAndGetFile(
        image.path, path,
        format: type == 'webp' ? CompressFormat.webp : CompressFormat.jpeg,
        quality: quality);
    return newImage;
  }
}

final resize = ResizeImage();
