import 'dart:convert';

import 'package:ileaf_flutter_test/model/employee.dart';
import 'package:http/http.dart' as http;

class API {
  static String baseUrl = 'https://run.mocky.io/v3/';

  Future<List<Employee>> getEmployees() async {
    var uri = Uri.parse(baseUrl + '3440c30c-8872-4d73-bef5-1a5d33e2ad87');

    try {
      var response = await http.get(uri);
      print(response.statusCode);
      if (response.statusCode == 200) {
        List<Employee> employees = [];
        var jsonDecodedResponse = jsonDecode(response.body);
        for (var employee in jsonDecodedResponse) {
          employees.add(Employee.fromJson(employee));
        }
        return employees;
      }
      return [];
    } catch (e) {
      print('Get employee exception: $e');
      return null;
    }
  }
}
