import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:ileaf_flutter_test/model/employee.dart';
import 'package:ileaf_flutter_test/redux/state/appState.dart';
import 'package:ileaf_flutter_test/service/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class GetEmployees extends ReduxAction<AppState> {
  List<Employee> employees = [];
  List<Employee> subSetEmployees = [];
  bool isLoading = true;

  @override
  Future<AppState> reduce() async {
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
      // notifyListeners();
    } else {
      List<String> tempEmployees =
          _sharedPreferences.getStringList('employees');
      for (var employee in tempEmployees) {
        employees.add(Employee.fromJson(jsonDecode(employee)));
      }
      subSetEmployees = employees;
      isLoading = false;
      // notifyListeners();
    }
    return state.copy(
        employees: employees,
        subsetEmployee: subSetEmployees,
        isLoading: isLoading);
  }
}
