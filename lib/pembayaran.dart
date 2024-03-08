import 'package:flutter/material.dart';

class Pembayaran extends StatefulWidget {
  const Pembayaran({Key? key}) : super(key: key);

  @override
  _PembayaranState createState() => _PembayaranState();
}

class _PembayaranState extends State<Pembayaran> {
  String _selectedPaymentMethod = ''; // To store the selected payment method
  String _selectedBank = ''; // To store the selected bank

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        backgroundColor: const Color.fromARGB(255, 206, 22, 22),
        title: const Text(
          'Pembayaran',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedPaymentMethod = 'Cash on Delivery';
                  _selectedBank = ''; // Reset selected bank when cash on delivery is chosen
                });
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(400, 60),
                backgroundColor: _selectedPaymentMethod == 'Cash on Delivery' ? Colors.red : Colors.white,
                foregroundColor: _selectedPaymentMethod == 'Cash on Delivery' ? Colors.white : Colors.red,
                side: const BorderSide(color: Colors.red, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Cash on Delivery'),
                  
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final selectedMethod = await showMenu<String>(
                  context: context,
                  position: RelativeRect.fromLTRB(0, 120, 0, 0),
                  items: <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'Bank BNI',
                      height: 50,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, style: BorderStyle.none, width: 15,),
                        ),
                        child: Center(
                          child: Text(
                            'Transfer Bank BNI',
                            style: TextStyle(
                              color: _selectedPaymentMethod == 'Bank BNI' ? Colors.red : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'Bank BCA',
                      height: 50,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, style: BorderStyle.none, width: 15,),
                        ),
                        child: Center(
                          child: Text(
                            'Transfer Bank BCA',
                            style: TextStyle(
                              color: _selectedPaymentMethod == 'Bank BCA' ? Color.fromARGB(255, 19, 65, 204) : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'Bank Mandiri',
                      height: 50,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, style: BorderStyle.none, width: 15,),
                        ),
                        child: Center(
                          child: Text(
                            'Transfer Bank Mandiri',
                            style: TextStyle(
                              color: _selectedPaymentMethod == 'Bank Mandiri' ? Color.fromARGB(255, 15, 3, 255) : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
                if (selectedMethod != null && selectedMethod.startsWith('Bank')) {
                  setState(() {
                    _selectedPaymentMethod = selectedMethod;
                    _selectedBank = selectedMethod; // Set selected bank to the chosen bank name
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(400, 60),
                backgroundColor: _selectedPaymentMethod != 'Cash on Delivery' ? Colors.red : Colors.white,
                foregroundColor: _selectedPaymentMethod != 'Cash on Delivery' ? Colors.white : Colors.red,
                side: const BorderSide(color: Colors.red, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_selectedBank.isNotEmpty ? _selectedBank : 'Choose Bank'), // Display selected bank name or default text
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
