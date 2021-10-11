import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:ileaf_flutter_test/model/employee.dart';
import 'package:ileaf_flutter_test/redux/actions/getEmployees.dart';
import 'package:ileaf_flutter_test/redux/actions/getSearchedEmployees.dart';
import 'package:ileaf_flutter_test/redux/state/appState.dart';

import '../../main.dart';

class MyHomePageConnector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      onInitialBuild: (context, store, model) async {
        await store.dispatch(GetEmployees());
      },
      vm: () => Factory(this),
      builder: (BuildContext context, ViewModel vm) => MyHomePage(
        title: 'iLeaf Flutter Test',
        onSearching: vm.onSearched,
        employee: vm.employees,
        isLoading: vm.isLoading,
      ),
    );
  }
}

class Factory extends VmFactory<AppState, MyHomePageConnector> {
  Factory(widget) : super(widget);

  @override
  ViewModel fromStore() => ViewModel(
      onSearched: (String keyword) async {
        return await dispatch(GetSearchedEmployees(keyword));
      },
      onRefreshed: () async {
        return await dispatch(GetEmployees());
      },
      employees: state.subSetEmployees.isNotEmpty
          ? state.subSetEmployees
          : state.employees,
      isLoading: state.isLoading);
}

class ViewModel extends Vm {
  final Function onSearched;
  final Function onRefreshed;
  final List<Employee> employees;
  final bool isLoading;

  ViewModel({this.onSearched, this.onRefreshed, this.employees, this.isLoading})
      : super(equals: [employees]);
}
