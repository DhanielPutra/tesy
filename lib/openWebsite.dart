import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenWebsiteWidget extends StatelessWidget {
  const OpenWebsiteWidget({Key? key}) : super(key: key);

  // Function to open the website
  _launchWebsite() async {
    const url = 'https://barbeqshop.online';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _launchWebsite,
      child: Container(
        height: 60,
        color: Colors.white,
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Open Website'),
            Icon(Icons.open_in_browser),
          ],
        ),
      ),
    );
  }
}
