import 'package:ileaf_flutter_test/model/employee.dart';

class AppState {
  List<Employee> employees = [];
  List<Employee> subSetEmployees = [];
  bool isLoading = true;

  static AppState initialise() => AppState([], [], true);

  AppState(this.employees, this.subSetEmployees, this.isLoading);

  AppState copy(
      {List<Employee> employees,
      List<Employee> subsetEmployee,
      bool isLoading}) {
    return AppState(employees, subsetEmployee, isLoading);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          employees == other.employees &&
          subSetEmployees == other.subSetEmployees &&
          isLoading == other.isLoading;

  @override
  int get hashCode =>
      employees.hashCode ^ subSetEmployees.hashCode ^ isLoading.hashCode;
}
