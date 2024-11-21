import 'package:flutter/material.dart';
import 'package:crud/utils/remote/firebase/database_service.dart';

class EmployScreen extends StatefulWidget {
  final bool isEdit;
  final String docId;
  final Map<String, dynamic> UseremployData;

  @override
  State<EmployScreen> createState() => _EmployScreenState();
  EmployScreen(
      {required this.docId,
      required this.isEdit,
      required this.UseremployData});
}

class _EmployScreenState extends State<EmployScreen> {
  final GlobalKey<FormState> employKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.UseremployData != null) {
      nameController.text = widget.UseremployData['Name'] ?? '';
      ageController.text = widget.UseremployData['age']?.toString() ?? '';
      locationController.text = widget.UseremployData['location'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(children: [
            TextSpan(
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 30,
                  fontWeight: FontWeight.w700),
              text: widget.isEdit ? "Update Employee " : "Add Employee ",
            ),
            TextSpan(
              style: TextStyle(
                  color: Colors.red, fontSize: 30, fontWeight: FontWeight.w700),
              text: "Firebase".toUpperCase(),
            )
          ]),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Form(
            key: employKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                ),
                Text(
                  "NAME :",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 4) {
                        return "Please Enter a Valid Name ";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide:
                                BorderSide(color: Colors.black, width: 2))),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "AGE :",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    controller: ageController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter Age ";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide:
                                BorderSide(color: Colors.black, width: 2))),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "LOCATION :",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    controller: locationController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter a Valid location ";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide:
                                BorderSide(color: Colors.black, width: 2))),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (employKey.currentState!.validate()) {
                        Map<String, dynamic> employinfoMap = {
                          "Name": nameController.text.trim(),
                          'age': ageController.text.trim(),
                          'location': locationController.text.trim(),
                        };
                        if (widget.isEdit) {
                          DatabaseService()
                              .updateEmploy(widget.docId, employinfoMap);
                        } else {
                          DatabaseService().addEmployDetails(employinfoMap);
                        }
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Form Submitted Successfully")));
                        Navigator.pop(context);
                      }
                    },
                    child: Text(widget.isEdit ? "Update" : "Submit"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
