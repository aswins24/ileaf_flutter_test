import 'package:flutter/material.dart';
import 'package:ileaf_flutter_test/model/employee.dart';

class EmployeeDetailScreen extends StatelessWidget {
  final Employee employee;

  EmployeeDetailScreen(this.employee);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Details'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black),
                  ),
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(
                      employee.profileImage != null
                          ? employee.profileImage
                          : '',
                    ),
                  ),
                ),
                Table(
                  children: [
                    emptyTableRow(),
                    getTableRow('Employee Name', employee.name),
                    emptyTableRow(),
                    getTableRow('E-mail ID', employee.email),
                    emptyTableRow(),
                    if (employee.phone != null)
                      getTableRow('Phone Number', employee.phone),
                    if (employee.phone != null) emptyTableRow(),
                    getTableRow('User Name', employee.username),
                    emptyTableRow(),
                    getTableRow(
                        'Address',
                        employee.address.suite +
                            employee.address.street +
                            employee.address.city +
                            employee.address.zipcode +
                            '\n' +
                            '\n' +
                            '[' +
                            employee.address.geo.lat +
                            employee.address.geo.lng +
                            ']'),
                    emptyTableRow(),
                    if (employee.website!= null)
                      getTableRow('Website', employee.website),
                    emptyTableRow(),
                  ],
                ),
                Text(
                  'Company Details',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                employee.company != null
                    ? Table(
                        children: [
                          emptyTableRow(),
                          getTableRow('Company Name', employee.company.name),
                          emptyTableRow(),
                          getTableRow('Bs', employee.company.bs),
                          emptyTableRow(),
                          if (employee.phone != null)
                            getTableRow(
                                'Catch Phrase', employee.company.catchPhrase),
                          emptyTableRow(),
                        ],
                      )
                    : Text('No Details'),
              ],
            ),
          )
        ],
      ),
    );
  }

  TableRow getTableRow(String field, String value) {
    return TableRow(children: [
      Text(
        field,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Text(value)
    ]);
  }

  TableRow emptyTableRow() {
    return TableRow(children: [
      SizedBox(
        height: 20,
      ),
      SizedBox(
        height: 20,
      )
    ]);
  }
}
