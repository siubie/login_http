import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Welcome to the home page'),
              SizedBox(
                height: 8,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    //request logout
                    final pref = await SharedPreferences.getInstance();
                    final token = pref.getString('token');

                    final logoutRequest = await http.post(
                      Uri.parse('http://10.0.2.2:8000/api/auth/logout'),
                      headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json',
                        'Authorization': 'Bearer $token',
                      },
                    );
                    if (!mounted) return;
                    if (logoutRequest.statusCode == 204) {
                      print("logout success");
                      //logout success
                      pref.remove('token');
                      //navigate to login page
                      Navigator.of(context).pushReplacementNamed('/');
                    }
                  },
                  child: Text('Logout'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
