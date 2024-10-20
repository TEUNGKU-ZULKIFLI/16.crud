import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddData extends StatefulWidget {
  @override
  _AddDataState createState() => new _AddDataState();
}

class _AddDataState extends State<AddData> {
  // Controllers for form input fields
  TextEditingController controllerCode = new TextEditingController();
  TextEditingController controllerName = new TextEditingController();
  TextEditingController controllerPrice = new TextEditingController();
  TextEditingController controllerStock = new TextEditingController();

  // Function to handle adding data
  void addData() {
    var url = Uri.parse("http://localhost:8080/my_store/adddata.php");

    http.post(url, body: {
      "itemcode": controllerCode.text,
      "itemname": controllerName.text,
      "price": controllerPrice.text,
      "stock": controllerStock.text
    });
  }

  // Helper method to check if all fields are filled
  bool _isFormValid() {
    return controllerCode.text.isNotEmpty &&
        controllerName.text.isNotEmpty &&
        controllerPrice.text.isNotEmpty &&
        controllerStock.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Item"),
        backgroundColor: Colors.teal, // Updated app bar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                // Item Code Input Field
                TextField(
                  controller: controllerCode,
                  decoration: InputDecoration(
                    hintText: "Enter Item Code",
                    labelText: "Item Code",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20), // Add space between fields

                // Item Name Input Field
                TextField(
                  controller: controllerName,
                  decoration: InputDecoration(
                    hintText: "Enter Item Name",
                    labelText: "Item Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Price Input Field
                TextField(
                  controller: controllerPrice,
                  keyboardType: TextInputType.number, // Ensure numeric input
                  decoration: InputDecoration(
                    hintText: "Enter Price",
                    labelText: "Price",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Stock Input Field
                TextField(
                  controller: controllerStock,
                  keyboardType: TextInputType.number, // Ensure numeric input
                  decoration: InputDecoration(
                    hintText: "Enter Stock",
                    labelText: "Stock",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 30), // Add some space before button

                // Add Data Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal, // Match the theme color
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "ADD DATA",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  onPressed: () {
                    // Validate the form before adding data
                    if (_isFormValid()) {
                      addData();
                      Navigator.pop(context);
                    } else {
                      // Show an alert if any field is empty
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Form Error"),
                          content: Text("All fields must be filled!"),
                          actions: <Widget>[
                            TextButton(
                              child: Text("OK"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
