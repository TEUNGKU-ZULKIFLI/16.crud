import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'editdata.dart';

class Detail extends StatefulWidget {
  final List list;
  final int index;

  Detail({required this.index, required this.list});

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  // Fungsi untuk menghapus data
  void deleteData() {
    var url = Uri.parse("http://localhost:8080/my_store/deletedata.php");
    http.post(url, body: {'id': widget.list[widget.index]['id']});
  }

  // Confirmation dialog before delete
  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Confirm Delete",
            style:
                TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
          ),
          content: Text("Are you sure you want to delete this item?"),
          actions: <Widget>[
            TextButton(
              child: Text("CANCEL", style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text("DELETE"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () {
                deleteData();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Auto-format price
    String formattedPrice = NumberFormat.currency(locale: 'id', symbol: 'Rp')
        .format(int.parse(widget.list[widget.index]['price']));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.list[widget.index]['item_name']),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // Display Item Name
                Text(
                  widget.list[widget.index]['item_name'],
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                // Display Price
                Text(
                  formattedPrice,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
                SizedBox(height: 15),
                // Display Stock
                Text(
                  "Stock: ${widget.list[widget.index]['stock']}",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 30), // Space before buttons
                // Edit and Delete Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(Icons.edit, size: 18),
                      label: Text("EDIT"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                      onPressed: () {
                        // Arahkan ke halaman edit dengan data yang ada
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditData(
                              list: widget.list,
                              index: widget.index,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 20),
                    ElevatedButton.icon(
                      icon: Icon(Icons.delete, size: 18),
                      label: Text("DELETE"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                      onPressed: _confirmDelete,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
