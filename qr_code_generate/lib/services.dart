import 'dart:convert';
import 'package:http/http.dart' as http; // add the http plugin in pubspec.yaml file.
import 'product.dart';

class Services {
  static const ROOT = 'http://localhost/Scanit/scanit.php';
  static const _GET_ALL_ACTION = 'GET_ALL';
  static const _UPDATE_EMP_ACTION = 'UPDATE_EMP';
  static const _DELETE_EMP_ACTION = 'DELETE_EMP';

  static Future<List<Product>> getProducts() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      final response = await http.post(ROOT, body: map);
      print('getEmployees Response: ${response.body}');
      if (200 == response.statusCode) {
        List<Product> list = parseResponse(response.body);
        return list;
      } else {
        return List<Product>();
      }
    } catch (e) {
      return List<Product>(); // return an empty list on exception/error
    }
  }

  static List<Product> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Product>((json) => Product.fromJson(json)).toList();
  }
  
  // Method to update an Product in Database...
  static Future<String> updateProduct(
      String proName, String manuDate) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_EMP_ACTION;
      map['pro_name'] = proName;
      map['manu_date'] = manuDate;
      final response = await http.post(ROOT, body: map);
      print('updateProduct Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  // Method to Delete an Product from Database...
  static Future<String> deleteProduct(String proName, String manuDate) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _DELETE_EMP_ACTION;
      map['pro_name'] = proName;
      map['manu_date'] = manuDate;
      final response = await http.post(ROOT, body: map);
      print('deleteProduct Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error"; // returning just an "error" string to keep this simple...
    }
  }
}