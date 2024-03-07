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
              onPressed: () async {
                final selectedMethod = await showMenu<String>(
                  context: context,
                  position: RelativeRect.fromLTRB(0, 100, 0, 0),
                  items: <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'Cash on Delivery',
                      child: Text(
                        'Cash on Delivery',
                        style: TextStyle(
                          color: _selectedPaymentMethod == 'Cash on Delivery' ? Colors.red : null,
                        ),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'Transfer Bank',
                      child: PopupMenuButton<String>(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'Bank A',
                            child: Text('Bank A'),
                          ),
                          PopupMenuItem(
                            value: 'Bank B',
                            child: Text('Bank B'),
                          ),
                          PopupMenuItem(
                            value: 'Bank C',
                            child: Text('Bank C'),
                          ),
                        ],
                        onSelected: (value) {
                          setState(() {
                            _selectedBank = value;
                            _selectedPaymentMethod = 'Transfer Bank ($_selectedBank)';
                          });
                        },
                      ),
                    ),
                  ],
                );
                if (selectedMethod != null && !selectedMethod.startsWith('Transfer Bank')) {
                  setState(() {
                    _selectedPaymentMethod = selectedMethod;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(400, 60),
                backgroundColor: Colors.white,
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Save your Payment'),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Selected Payment Method: $_selectedPaymentMethod',
              style: const TextStyle(fontSize: 16),
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
