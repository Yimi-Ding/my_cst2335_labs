import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {

  var _counter = 0.0;
  var myFontSize = 30.0;

  // Controllers for the text fields
  final TextEditingController  _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // a string variable that is initialized to the image
  var imageSource = "images/question-mark.png";

  // instance of EncryptedSharedPreferences for secure storage
  final EncryptedSharedPreferences _encryptedPrefs = EncryptedSharedPreferences();

  // Initialize state
  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  // Load saved credentials from encrypted storage
  Future<void> _loadSavedCredentials() async {
    final String? savedUsername = await _encryptedPrefs.getString('username');
    final String? savedPassword = await _encryptedPrefs.getString('password');

    // if there is a saved username and password, save them to the text fields
    if (savedUsername != null && savedPassword != null) {
      setState(() {
        _loginController.text = savedUsername;
        _passwordController.text = savedPassword;
      });

      if (mounted) {
        // Show snackbar with undo option when credentials are loaded
        final snackBar = SnackBar(
          content: const Text('Previous login credentials loaded'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _loginController.clear();
                _passwordController.clear();
              });
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  // save credentials to encrypted storage
  Future<void> _saveCredentials() async {
    await _encryptedPrefs.setString('username', _loginController.text);
    await _encryptedPrefs.setString('password', _passwordController.text);
  }

  // clear saved credentials from encrypted storage
  Future<void> _clearCredentials() async {
    await _encryptedPrefs.remove('username');
    await _encryptedPrefs.remove('password');
  }

  // show dialog for saving credentials
  Future<void> _showSaveCredentialsDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Save Credentials'),
        content: const Text('Would you like to save your username and password for next time?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              _clearCredentials();
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              _saveCredentials();
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }



  void setNewValue(double value) {
    setState(() {
      _counter = value;
      myFontSize = value;
    });
  }


  void _incrementCounter() {
    setState(() {
      if ( _counter < 99.0 ) { //add missing brackets
        _counter++;
        myFontSize = _counter;
      }
    });
  }

  //widgets
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            // text field login
            TextField(
              controller: _loginController,
              decoration: const InputDecoration(
              hintText:"Login",
              border: OutlineInputBorder(),
              labelText: "Login"
            ),),

            // text field password
            TextField(
              controller: _passwordController,
              obscureText: true, // make the password field not show what is typed
              decoration: const InputDecoration(
                  hintText:"Password",
                  border: OutlineInputBorder(),
                  labelText: "Password",
              ),),

            // login button
            ElevatedButton(
                onPressed: (){
                  String password = _passwordController.text; // get the string that was typed in the password field
                  setState(() {
                    //  If the string is "QWERTY123", then change the image source to be a light bulb
                    if (password == "QWERTY123"){
                      imageSource = "images/idea.png";
                    } else { //If the string is anything other than "QWERTY123", then set the image to a stop sign
                      imageSource = "images/stop.png";
                    }
                  });
                  // show save credentials dialog after login
                  _showSaveCredentialsDialog();
                },
                child: const Text("Login"),
            ),

            Image.asset(imageSource, width: 300, height:300),


          ],



        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
