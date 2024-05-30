import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:marketplace/detail.dart';

class SearchForm extends StatefulWidget {
  @override
  _SearchFormState createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  String _searchQuery = '';
  late TextEditingController _searchController;
  List<dynamic> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose(); 
    super.dispose();
  }

  Future<void> _searchProducts(String query) async {
    final String apiUrl = 'https://barbeqshop.online/api/produk/search?query=$query';

    try {
      final response = await http.post(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          _searchResults = responseData['data'];
        });
        print('Search API response: $responseData');
      } else {
        print('Failed to search products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error searching products: $e');
    }
  }

  void _clearSearchResults() {
    setState(() {
      _searchResults.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,
        leading: IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 40),
              child: TextField(
                controller: _searchController,
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
                  fillColor: const Color.fromARGB(255, 235, 226, 226),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                  if (value.isEmpty) {
                    _clearSearchResults(); // Clear search results if query is empty
                  } else {
                    _searchProducts(value); // Call search method here
                  }
                },
                onSubmitted: (value) {
                  _searchProducts(value); 
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () {
                _searchController.clear();
                FocusScope.of(context).unfocus();
              },
              child:const Text(
                'Cancel',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _searchProducts(_searchQuery);
            },
          ),
        ],
      ),
      body: Padding(
  padding: const EdgeInsets.symmetric(horizontal: 13.0),
  child: _searchResults.isNotEmpty
      ? GridView.builder(
          gridDelegate:const  SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 11,
            childAspectRatio: 0.72,
          ),
          itemCount: _searchResults.length,
          itemBuilder: (context, index) {
            final product = _searchResults[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Detail(
                    item: product,wishlistItem: product,
                  ),
                ));
              },
              child: Card(
                color: Colors.white,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(
                        product['gambar'],
                        height: 150,
                        width: double.infinity,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        product['nama_produk'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        'Rp ${product['harga']}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(255, 2, 2, 2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        )
      : Center(
          child: Text(
            '',
            style: TextStyle(fontSize: 20),
          ),
        ),
),

    );
  }
}
