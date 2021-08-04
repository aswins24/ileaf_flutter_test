import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ileaf_flutter_test/model/employee.dart';
import 'package:ileaf_flutter_test/provider/employee_model.dart';
import 'package:ileaf_flutter_test/screens/employee_detail_page.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  //SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => EmployeeModel(),
    ),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'iLeaf Flutter Test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isSearching = false;
  TextEditingController _searchTextController = TextEditingController();
  EmployeeModel _employeeModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _employeeModel = Provider.of<EmployeeModel>(context);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          if (!isSearching)
            InkWell(
              onTap: () {
                searchEmployee('');
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Icon(Icons.refresh),
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 400),
              decoration: BoxDecoration(
                  color: isSearching ? Colors.white : Colors.blue,
                  borderRadius: BorderRadius.circular(20)),
              width: isSearching ? 200 : 36,
              height: 36,
              curve: isSearching ? Curves.easeIn : Curves.bounceOut,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          isSearching = !isSearching;
                        });
                      },
                    ),
                  ),
                  isSearching
                      ? Expanded(
                          flex: 3,
                          child: TextField(
                            controller: _searchTextController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(bottom: 10),
                                hintText: 'Search'),
                          ),
                        )
                      : Container(),
                  isSearching
                      ? Flexible(
                          child: IconButton(
                            icon: Icon(
                              Icons.send,
                              color: Colors.blue,
                            ),
                            onPressed: () async {
                              searchEmployee(_searchTextController.text.trim());
                              FocusScope.of(context).requestFocus(FocusNode());
                              setState(() {
                                isSearching = false;
                              });
                            },
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          )
        ],
      ),
      body: Consumer<EmployeeModel>(builder: (context, model, ind) {
        if (model.isLoading)
          return Center(
            child: CircularProgressIndicator(),
          );
        if (model.subSetEmployees.isEmpty)
          return Center(
            child: Text('Employee List is empty'),
          );
        return ListView.separated(
          itemBuilder: (context, index) {
            return employeeTile(model.subSetEmployees[index], context);
          },
          separatorBuilder: (context, index) => Divider(),
          itemCount: model.subSetEmployees.length,
        );
      }),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget employeeTile(Employee employee, context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EmployeeDetailScreen(employee)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: ListTile(
          leading: Container(
            decoration: BoxDecoration(
                //borderRadius: BorderRadius.circular(50),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black)),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                employee.profileImage != null ? employee.profileImage : '',
                //fit: BoxFit.fill,
              ),
            ),
          ),
          title: Column(
            children: [
              Text(employee.name != null ? employee.name : 'Anonymous'),
              Text(employee.company != null && employee.company.name != null
                  ? employee.company.name
                  : 'Anonymous'),
            ],
          ),
        ),
      ),
    );
  }

  void searchEmployee(String keyword) {
    _employeeModel.getSearchedEmployees(keyword);
    _searchTextController.clear();
  }
}
