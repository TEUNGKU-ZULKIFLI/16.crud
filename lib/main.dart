import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Import intl package
import '/Detail.dart';
import '/AddData.dart';

void main() {
  runApp(MaterialApp(
    title: 'CRUD',
    debugShowCheckedModeBanner: false, // Remove the debug label
    theme: ThemeData(
      primarySwatch: Colors.teal, // Change primary theme color to teal
      scaffoldBackgroundColor: Colors.grey[100], // Light background color
    ),
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  Future<List> getData() async {
    final response =
        await http.get(Uri.parse("http://localhost:8080/my_store/getdata.php"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Reload Data
  void _reloadData() {
    setState(() {
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BELAJAR CRUD", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _reloadData, // Call reload function
          ),
        ],
        backgroundColor: Colors.teal, // Improved app bar color
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal, // Match button color to theme
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => AddData(),
          ),
        ),
      ),
      body: FutureBuilder<List>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return ItemList(list: snapshot.data!);
          }
        },
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  final List list;

  ItemList({required this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, i) {
        // Auto-format price
        String formattedPrice = NumberFormat.currency(
                locale: 'id', symbol: 'Rp')
            .format(int.parse(list[i]['price'])); // Assuming price is a number

        return Container(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      Detail(list: list, index: i)),
            ),
            child: Card(
              elevation: 4, // Add slight shadow to the card
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.teal,
                  child: Icon(Icons.widgets, color: Colors.white),
                ),
                title: Text(
                  list[i]['item_name'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Text(
                  "Stock: ${list[i]['stock']} \nPrice: $formattedPrice",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
