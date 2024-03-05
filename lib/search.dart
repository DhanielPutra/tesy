import 'package:flutter/material.dart';

class SearchForm extends StatefulWidget {
  @override
  _SearchFormState createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40, // Adjust the width of the leading widget
        leading: IconButton(
          padding: EdgeInsets.zero, // Remove padding around the icon
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 40), // Adjust the right padding
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 18,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Color.fromARGB(255, 235, 226, 226),
                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
