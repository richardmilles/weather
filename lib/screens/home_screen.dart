import 'package:flutter/material.dart';
import 'package:examflu/screens/progress_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bienvenue !',
              style: TextStyle(fontSize: 24),
            ),
            ElevatedButton(
              child: Text('Commencer'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProgressScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
