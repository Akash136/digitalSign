import 'dart:convert';

// import 'package:digitalsignature/shared_preference.dart';
// import 'package:digitalsignature/user.dart';
import 'package:http/http.dart' as http;

class URLS {
  static const String BASE_URL = 'http://10.10.10.179:89/API/DMS';
}

class ApiService {
  static Future<Map<String, dynamic>> getEmployeesNew() async {
    final response =
        await http.get(Uri.parse("http://10.10.10.179:89/API/DMS/getEmplist"));
    print(response.body);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }

  static Future<bool> addappuserdata(body) async {
    final response = await http.post(
        Uri.parse("http://10.10.10.179:89/API/DMS/AddAppUserData"),
        body: body);
    // final response = await http.post('${URLS.BASE_URL}/create', body: body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> addappsalesentry(body) async {
    final response = await http.post(
        Uri.parse("http://10.10.10.179:89/API/DMS/AddAPPSALESEntry"),
        body: body);
    // await http.post('${URLS.BASE_URL}/AddAPPSALESEntry', body: body);
    // final response = await http.post('${URLS.BASE_URL}/create', body: body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> addsamajdetails(body) async {
    final response = await http.post(
        Uri.parse("http://10.10.10.179:89/API/DMS/AddSamajDetails"),
        body: body);
    // await http.post('${URLS.BASE_URL}/AddAPPSALESEntry', body: body);
    // final response = await http.post('${URLS.BASE_URL}/create', body: body);
    print(response);
    print(response.statusCode);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> signin(String email, pass) async {
    //var posturl = "Uri.parse("http://10.10.10.179:89/API/DMS/Checklogin";
    Map data = {'username': email, 'password': pass};
    //var jsonResponse = null;
    var response = await http.post(
        Uri.parse("http://14.98.134.214:19/API/DMS/Checksignlogin"),
        body: data);
    var data1 = jsonDecode(response.body);
    var res = data1['Status_Code'];

    if (res == 1) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> updatedocumentStatus(body) async {
    final response = await http.post(
        Uri.parse("http://14.98.134.214:19/API/DMS/UpdatedocumentStatus"),
        body: body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
