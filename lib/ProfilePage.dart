import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'DataRepository.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final TextEditingController _firstNameController = TextEditingController();
  late final TextEditingController _lastNameController = TextEditingController();
  late final TextEditingController _phoneController = TextEditingController();
  late final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    await DataRepository.loadData();
    setState(() {
      _firstNameController.text = DataRepository.firstName;
      _lastNameController.text = DataRepository.lastName;
      _phoneController.text = DataRepository.phone;
      _emailController.text = DataRepository.email;
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> saveUserData() async {
    DataRepository.firstName = _firstNameController.text;
    DataRepository.lastName = _lastNameController.text;
    DataRepository.phone = _phoneController.text;
    DataRepository.email = _emailController.text;
    await DataRepository.saveData();
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Error'),
          content: Text('This action is not supported on your device.'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: Center(
        child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome Back, ${DataRepository.username}!",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.phone),
                      onPressed: () => _launchURL('tel:${_phoneController.text}'),
                    ),
                    IconButton(
                      icon: Icon(Icons.message),
                      onPressed: () => _launchURL('sms:${_phoneController.text}'),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.mail),
                      onPressed: () => _launchURL('mailto:${_emailController.text}'),
                    ),
                  ],
                ),
              ],)
        ),
      ),
    );
  }
}