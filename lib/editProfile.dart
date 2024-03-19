import 'package:flutter/material.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 201, 11, 11),
        leading: IconButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Center(
            child: Text(
          'Edit Profil',
          style: TextStyle(color: Colors.white),
        )),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'SAVE',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        //gambar
                        children: [
                          Container(
                            padding: const EdgeInsets.all(50),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 201, 11, 11),
                            ),
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: Center(
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/dn.jpg',
                                ),
                              ),
                              // child: Image.network(
                              //   'https://th.bing.com/th/id/R.e5eece3464b4cc1ffa89d823f8aace44?rik=OkMVK4pPCgW6EQ&riu=http%3a%2f%2fwww.techpowerup.com%2fimg%2f06-08-24%2f12886.jpg&ehk=rgRfxllS%2bstUSt6vxZEfZQs7Ox%2fUb1CTYYquyoPDAgk%3d&risl=&pid=ImgRaw&r=0', // Ganti dengan URL gambar yang sebenarnya
                              //   width:
                              //       250.0, // Sesuaikan lebar gambar sesuai kebutuhan Anda
                              //   height:
                              //       250.0, // Sesuaikan tinggi gambar sesuai kebutuhan Anda
                              // ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
                  child: const Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fullname'),
                      TextField(
                        decoration: InputDecoration(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Phone number'),
                      TextField(
                        decoration: InputDecoration(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Email'),
                      TextField(
                        decoration: InputDecoration(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
