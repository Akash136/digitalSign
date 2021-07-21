import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class UploadService {
  // static Future<String> upload(File file, String dpname) async {
  static Future<String> upload(File file) async {
    var postUri = Uri.parse("http://14.98.134.214:19/API/DMS/UploadFiles");

    http.MultipartRequest request = new http.MultipartRequest("POST", postUri);
    String fileName = '';
    fileName = path.basename(file.path);
    http.MultipartFile multipartFile =
        await http.MultipartFile.fromPath('file', file.path);

    request.files.add(multipartFile);

    http.StreamedResponse response = await request.send();

    print(fileName);
    String opt = response.statusCode.toString();
    return opt;
  }
}
