import 'package:flutter/material.dart';
import 'package:sharpsheel/screens/sixth_scree.dart';

class FifthScreen extends StatefulWidget {
  static String routeName = '/fifthScreen';
  const FifthScreen({super.key});

  @override
  State<FifthScreen> createState() => _FifthScreenState();
}

class _FifthScreenState extends State<FifthScreen> {
  // Remove the separate employees list, use only ValueNotifier
  ValueNotifier<List<String>> employeesNotifier = ValueNotifier<List<String>>([
    "Anurudh Singh Software Engineer at SharpShell.AI",
    "John Doe Product Manager at TechCorp",
    "Jane Smith UX Designer at CreativeStudio",
    "Michael Johnson Data Scientist at DataWorks",
    "Emily Davis Marketing Specialist at MarketMinds",
    "David Wilson Sales Executive at SalesForce",
  ]);

  void addItemToList(String newEmployee) {
    // Create a new list with the additional item
    final currentList = List<String>.from(employeesNotifier.value);
    currentList.add(newEmployee);
    employeesNotifier.value = currentList;
  }

  @override
  void dispose() {
    // Don't forget to dispose the ValueNotifier
    employeesNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fifth Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text('Fifth Screen'),
            SizedBox(height: 20),

            SizedBox(height: 20),
            ValueListenableBuilder<List<String>>(
              valueListenable: employeesNotifier,
              builder: (context, employees, child) => Container(
                height: 200,
                color: Colors.amber,
                child: ListView.builder(
                  itemCount: employees.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Index ${index + 1} ${employees[index]}'),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Go Back'),
                ),
                ElevatedButton(
                  onPressed: () {
                    print(
                      'Add item to the list button pressed ${employeesNotifier.value.length}',
                    );
                    addItemToList(
                      "Anurudh Singh Software Engineer at SharpShell.AI",
                    );
                  },
                  child: Text('Add item to the list'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const SixthScreen(),
                  ),
                );
              },
              child: Text('go to sixth screen'),
            ),
          ],
        ),
      ),
    );
  }
}
