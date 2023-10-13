import 'dart:io';
import 'package:path/path.dart';

Map<String,File> getFileMap(List<String> fileList,String path){
  Map<String,File> result = {};

  for(var file in fileList){
    final fileobj = File(join(path,file));
    fileobj.createSync(recursive: true);
    result[file] = fileobj;
  }

  return result;
}

class LocalStoreInterface {
  Map<String, File> collection;
  String path;
  LocalStoreInterface({required List<String> collection,required this.path}):
    collection = getFileMap(collection,path)
  ;

  File getBoxbyName(String name) {
    return collection[name] ?? File("random.txt");
  }



  void writeAndEncryptFile(File file,String content) {
    file.writeAsStringSync(content);
  }

  String readAndDecryptFile(File file) {
    if (file.existsSync()) {
      final content = file.readAsStringSync();
      return content;
    }
    return '';
  }
}
