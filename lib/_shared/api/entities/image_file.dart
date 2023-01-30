import 'dart:typed_data';


class ImageFile {
  final Uint8List bytes;
  final String name;

  const ImageFile( {required this.name,required this.bytes,});
}

