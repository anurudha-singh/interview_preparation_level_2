import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sharpsheel/model/users_model.dart';
import 'package:sharpsheel/screens/first_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  static String routeName = '/';

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<dynamic>> fetchUserData() async {
    http.Response response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    print('response: ${response.body}');
    if (response.statusCode == 200) {
      print('User data: ${response.body} ');
      print('User data type: ${response.body.runtimeType} ');
      print('deocode data type: ${jsonDecode(response.body).runtimeType} ');

      // return jsonDecode(response.body);
      return usersDataFromJson(response.body);
    } else {
      print('Error: ${response.statusCode}');
      return [{}];
    }
  }

  List<String> items = [];
  void addListItemToTheList(String item) {
    items.add(item);
    setState(() {});
    print('items length: ${items.length}');
  }

  late StreamController<int> _streamController;
  late Stream<int> stream;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<int>();
    stream = _streamController.stream;
    _startPeriodicStream();
  }

  void _startPeriodicStream() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_streamController.isClosed) {
        timer.cancel();
        return;
      }
      _streamController.add(timer.tick - 1);
      if (timer.tick >= 10) {
        timer.cancel();
        _streamController.close();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _streamController.close();
    super.dispose();
    print('dispose method called');
  }

  @override
  Widget build(BuildContext context) {
    // print('build method called');
    // print('items length in build method: ${items.length}');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      //   body: FutureBuilder(
      //     future: fetchUserData(),
      //     builder: (context, snapshot) {
      //       if (snapshot.connectionState == ConnectionState.waiting) {
      //         return Center(child: CircularProgressIndicator());
      //       }
      //       if (snapshot.hasError) {
      //         return Center(child: Text('Error: ${snapshot.error}'));
      //       }
      //       if (snapshot.hasData) {
      //         // return Center(child: Text('User data: ${snapshot.data}'));
      //         List<UsersData> users = snapshot.data as List<UsersData>;
      //         return Column(
      //           children: [
      //             Container(
      //               height: 400,
      //               color: Colors.amber,
      //               child: ListView.builder(
      //                 scrollDirection: Axis.vertical,
      //                 itemCount: users.length,
      //                 itemBuilder: (context, index) {
      //                   return ListTile(
      //                     title: Text(users[index].name),
      //                     subtitle: Text(users[index].email),
      //                   );
      //                 },
      //               ),
      //             ),
      //             Container(
      //               padding: EdgeInsets.all(16),
      //               width: double.infinity,
      //               child: ElevatedButton(
      //                 onPressed: () {
      //                   Navigator.pushNamed(context, FirstScreen.routeName);
      //                 },
      //                 child: Text('Go to First Screen'),
      //               ),
      //             ),
      //           ],
      //         );
      //       }
      //       return Column(children: [Text('No data')]);
      //     },
      //   ),
      // );
      body: StreamBuilder(
        stream: stream,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (asyncSnapshot.hasError) {
            return Center(child: Text('Error: ${asyncSnapshot.error}'));
          }
          if (asyncSnapshot.hasData) {
            print('Future data: ${asyncSnapshot.data}');
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                color: Colors.black,
                height: 100,
                width: 100,
                child: Text('Hello World'),
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      child: Text('Cancel'),
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      child: Text('Ok'),
                      onPressed: () {
                        // Navigator.pushNamed(context, FirstScreen.routeName);
                        // Use pushReplacementNamed if you don't want users to go back
                        Navigator.pushReplacementNamed(
                          context,
                          FirstScreen.routeName,
                        );
                        // setState(() {
                        // addListItemToTheList(count.toString());
                        // count += 1;

                        // });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              // Expanded(
              //   flex: 2,
              //   child: ListView.builder(
              //     // shrinkWrap: true,
              //     itemCount: items.length,
              //     itemBuilder: ((context, index) {
              //       return Text(items[index]);
              //     }),
              //   ),
              // ),
            ],
          );
        },
      ),
    );
  }
}
