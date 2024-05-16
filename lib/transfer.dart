import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketplace/pesanan_berhasil.dart';

class Transfer extends StatefulWidget {
  const Transfer({super.key});

  @override
  State<Transfer> createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer Bank'),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('No Rekening Transfer'),
            SizedBox(
              height: 10,
            ),
            Card(
              elevation: 5,
              shadowColor: Colors.black,
              color: Colors.red[600],
              child: SizedBox(
                width: 500,
                height: 50,
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bank BNI'),
                        Text(' : '),
                        Text('217-04057-68')
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text('Upload Bukti Transfer'),
            SizedBox(
              height: 10,
            ),
            Card(
              elevation: 5,
              shadowColor: Colors.black,
              color: Colors.red[600],
              child: SizedBox(
                width: 500,
                height: 350,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: _image == null
                          ? Text("No image selected.")
                          : Image.file(
                              _image!,
                              width: 200,
                              height: 200,
                            ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: Text("Pick Image from Gallery"),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PesananBerhasil()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(200, 50),
                  // Properti gaya tombol
                  backgroundColor:
                      Colors.red[600], // Warna latar belakang tombol
                  foregroundColor: Colors.red[600],
                  // Padding tombol

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    // Bentuk tepi tombol
                  ),
                ),
                child: Text('Selesai',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
