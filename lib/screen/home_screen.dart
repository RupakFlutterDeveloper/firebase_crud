import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/screen/employ_screen.dart';
import 'package:crud/utils/remote/firebase/database_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Database
  DatabaseService dataservice = DatabaseService();
  Stream<QuerySnapshot>? employstream;

  @override
  void initState() {
    // TODO: implement initState

    employstream = dataservice.FetchemployDetails();
  }

  Widget allEmployDetails() {
    return StreamBuilder<QuerySnapshot>(
      stream: employstream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Container(
            child: Text("error ${snapshot.error}"),
          );
        }
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var employee = snapshot.data!.docs[index];
              var docId = employee.id;
              return Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(10),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      //  color: Colors.grey,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Name : ${employee['Name']}".toUpperCase()),
                              InkWell(
                                onTap: () {
                                  var employData = {
                                    "Name": employee["Name"],
                                    "age": employee['age'],
                                    'location': employee['location']
                                  };
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return EmployScreen(
                                          docId: docId,
                                          isEdit: true,
                                          UseremployData: employData);
                                    },
                                  ));
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.lightBlueAccent,
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showDialogueBox(docId, employee['Name']);
                                  },
                                  icon: Icon(Icons.delete))
                            ],
                          ),
                          Text("Age : ${employee['age']}"),
                          Text("Location : ${employee['location']}"
                              .toUpperCase()),
                          // SizedBox(
                          //   height: 20,
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
        return Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        title: RichText(
          text: TextSpan(
              style: TextStyle(
                  color: Colors.red, fontSize: 30, fontWeight: FontWeight.w700),
              children: [
                TextSpan(
                    text: "Flutter ".toUpperCase(),
                    style: TextStyle(color: Colors.blue)),
                TextSpan(text: "Firebase :".toUpperCase())
              ]),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: allEmployDetails()),
          ],
        ),
      ),
      //Floating Action Button
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  EmployScreen(
                UseremployData: {},
                docId: '',
                isEdit: false,
              ),
            ));
          }),
    );
  }

  void showDialogueBox(String docId, String name) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(child: Text(name.toUpperCase())),
          content: Text("Your Employ Data is Premanantly Delete ? "),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel")),
                ElevatedButton(
                    onPressed: () {
                      DatabaseService().deleteEmploy(docId);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "Employ Data ${name} Successfully Delete ..."
                                  .toUpperCase())));
                    },
                    child: Text("Delete"))
              ],
            )
          ],
        );
      },
    );
  }
}
