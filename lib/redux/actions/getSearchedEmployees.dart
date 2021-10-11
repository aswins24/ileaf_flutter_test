import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:ileaf_flutter_test/model/employee.dart';
import 'package:ileaf_flutter_test/redux/actions/getEmployees.dart';
import 'package:ileaf_flutter_test/redux/state/appState.dart';

class GetSearchedEmployees extends ReduxAction<AppState> {
  final String keyword;

  bool isLoading = false;
  GetSearchedEmployees(this.keyword);
  @override
  Future<AppState> reduce() async {
    List<Employee> temPEmployee = [];
    print('Search method is called');
    if (keyword.trim().isEmpty) {
      state.subSetEmployees = state.employees;
      // notifyListeners();
      return state.copy(
          employees: state.employees,
          subsetEmployee: state.subSetEmployees,
          isLoading: false);
    }
    for (var employee in state.employees) {
      if (employee.name.toUpperCase().contains(keyword.trim().toUpperCase()) ||
          employee.email.toUpperCase().contains(keyword.trim().toUpperCase()))
        temPEmployee.add(employee);
    }
    state.subSetEmployees = temPEmployee;
    // notifyListeners();
    return state.copy(
        employees: state.employees,
        subsetEmployee: state.subSetEmployees,
        isLoading: false);
  }
}
