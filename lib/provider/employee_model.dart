import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:ileaf_flutter_test/model/employee.dart';
import 'package:ileaf_flutter_test/service/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeModel with ChangeNotifier {
  EmployeeModel() {
    getEmployees();
  }
  List<Employee> employees = [];
  List<Employee> subSetEmployees = [];
  bool isLoading = true;

  Future<List<Employee>> getEmployees() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    if (_sharedPreferences.getStringList('employees') == null ||
        _sharedPreferences.getStringList('employees').isEmpty) {
      subSetEmployees = employees = await API().getEmployees();
      List<String> tempEmployees = [];
      for (var employee in employees)
        tempEmployees.add(jsonEncode(employee.toJson()));
      _sharedPreferences.setStringList('employees', tempEmployees);
      isLoading = false;
      notifyListeners();
    } else {
      List<String> tempEmployees =
          _sharedPreferences.getStringList('employees');
      for (var employee in tempEmployees) {
        employees.add(Employee.fromJson(jsonDecode(employee)));
      }
      subSetEmployees = employees;
      isLoading = false;
      notifyListeners();
    }
    return employees;
  }

  List<Employee> getSearchedEmployees(String keyword) {
    List<Employee> temPEmployee = [];
    if (keyword.trim().isEmpty) {
      subSetEmployees = employees;
      notifyListeners();
      return subSetEmployees;
    }
    for (var employee in employees) {
      if (employee.name.toUpperCase().contains(keyword.trim().toUpperCase()) ||
          employee.email.toUpperCase().contains(keyword.trim().toUpperCase()))
        temPEmployee.add(employee);
    }
    subSetEmployees = temPEmployee;
    notifyListeners();
    return subSetEmployees;
  }
}
