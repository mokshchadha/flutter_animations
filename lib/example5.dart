import 'package:flutter/material.dart';

class Example5 extends StatefulWidget {
  const Example5({super.key});

  @override
  State<Example5> createState() => _Example5State();
}

final double defaultwidth = 300.0;

class _Example5State extends State<Example5> {
  bool _isZoomedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Example 5')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: _isZoomedIn ? defaultwidth * 1.5 : defaultwidth,
              child: Image.asset('assets/1.jpg'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isZoomedIn = !_isZoomedIn;
                });
              },
              child: Text(_isZoomedIn ? 'Zoom Out' : 'Zoom In'),
            ),
          ],
        ),
      ),
    );
  }
}
