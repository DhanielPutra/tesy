import 'package:flutter/material.dart';
import 'package:marketplace/det.dart';
import 'package:marketplace/search.dart';
import 'package:marketplace/view/Register/login.dart';
import 'package:marketplace/product.dart';
import 'package:marketplace/wishlist.dart';

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  Color _cardColor = Colors.white;
  String _selectedText = 'All'; // Initially set to 'All'
  List<List<String>> filteredItems = List.from(items);

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (context) => homepage()));
      } else if (index == 1) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => login()));
      } else if (index == 2) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context)=> Wishlist()));
      }
    });
  }

  void filterItemsByCategory(String category) {
    setState(() {
      _selectedText = category;
      if (category == 'All') {
        filteredItems = List.from(items); // Show all items
      } else {
        filteredItems = items.where((item) => item[3] == category).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchForm()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 235, 226, 226),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.black,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Search',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 15, 0),
            child: ClipOval(
              child: Image.asset(
                'assets/bbq.jpg',
                fit: BoxFit.cover,
                width: 50.0,
                height: 50.0,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {
                // Handle the tap event for the image button
                print('ImageButton tapped');
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 10, 10, 10),
                child: Image.asset(
                  'assets/disc.jpg',
                  fit: BoxFit.cover,
                  height: 120, // Set the height of the image button
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(120, 10, 5, 10),
              child: Row(
                children: [
                  ClickableText(
                    text: 'All', // Add 'All' option
                    isSelected: _selectedText == 'All',
                    onTap: () => filterItemsByCategory('All'),
                  ),
                  ClickableText(
                    text: 'Elektronik',
                    isSelected: _selectedText == 'Elektronik',
                    onTap: () => filterItemsByCategory('Elektronik'),
                  ),
                  ClickableText(
                    text: 'Sepatu',
                    isSelected: _selectedText == 'Sepatu',
                    onTap: () => filterItemsByCategory('Sepatu'),
                  ),
                  ClickableText(
                    text: 'Baju',
                    isSelected: _selectedText == 'Baju',
                    onTap: () => filterItemsByCategory('Baju'),
                  ),
                  ClickableText(
                    text: 'Meja',
                    isSelected: _selectedText == 'Meja',
                    onTap: () => filterItemsByCategory('Meja'),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Wrap(
              spacing: 20, // Gap between cards
              runSpacing: 8, // Gap between rows
              children: filteredItems.map((item) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Detail(item: item)));
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2 -
                        10, // Make each card take half of the screen width
                    child: Card(
                      color: _cardColor,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              item[0], // Accessing image path from items
                              height: 150,
                              width: double.infinity,
                            ),
                            const SizedBox(
                              height: 8,
                            ), // Add spacing between image and text
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                item[1], // Accessing text from items
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                 overflow: TextOverflow.ellipsis,
                            maxLines: 1, // Limit the text to 1 line
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                item[2], // Accessing text from items
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromARGB(255, 2, 2, 2),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Set type to fixed
        backgroundColor: const Color.fromARGB(
            255, 193, 24, 24), // Set the background color here
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded), // Add your new icon here
            label: 'Profile', // Add the label for the new icon
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        unselectedItemColor: Color.fromARGB(207, 0, 0, 0),
        onTap: _onItemTapped,
      ),
    );
  }
}

class ClickableText extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const ClickableText({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          text,
          style: TextStyle(
              color: isSelected
                  ? const Color.fromARGB(255, 0, 0, 0)
                  : const Color.fromARGB(255, 149, 149, 149),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
        ),
      ),
    );
  }
}
