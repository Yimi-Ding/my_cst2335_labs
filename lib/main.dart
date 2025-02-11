import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'ProfilePage.dart';
import 'DataRepository.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        '/second':(context)=> ProfilePage(),
      },
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
  late TextEditingController _loginController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _loginController = TextEditingController();
    _passwordController = TextEditingController();
    loadSavedData();
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  var imageSource = "images/question-mark.png";

  void showSaveDataDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(
            title: Text('Save Data'),
            content: Text('Would you like to save your username and password?'),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    clearData();
                    Navigator.pop(context);
                  },
                  child: Text('No')),
              ElevatedButton(
                  onPressed: () async {
                    saveData(_loginController.text, _passwordController.text);
                    Navigator.pop(context);
                  },
                  child: Text('Yes'))
            ],
          ),
    );
  }

  //EncryptedSharedPreferences object
  EncryptedSharedPreferences prefs = EncryptedSharedPreferences();

  Future <void> saveData(String username, String password) async {
    await prefs.setString('username', username);
    await prefs.setString('password', password);
  }

  Future <void> clearData() async {
    await prefs.remove('username');
    await prefs.remove('password');
  }

  Future <void> loadSavedData() async {
    String savedUsername = await prefs.getString('username');
    String savedPassword = await prefs.getString('password');

    setState(() {
      _loginController.text = savedUsername ?? '';
      _passwordController.text = savedPassword ?? '';
    });

    if (savedUsername.isNotEmpty && savedPassword.isNotEmpty) {
      showSnackBar(context);
    }
  }

  void showSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('Previous login data loaded.'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          setState(() {
            _loginController.text = "";
            _passwordController.text = "";
          });
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void login(){
    if(_loginController.text == "yimi" && _passwordController.text =="123456"){
      DataRepository.username = _loginController.text;
      DataRepository.password = _passwordController.text;
      DataRepository.saveData(); // save data

      Navigator.pushNamed(context,'/second');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Welcome Back, ${DataRepository.username}!")),
      );
    }
  }

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
            TextField(
                controller: _loginController,
                decoration: InputDecoration(
                  hintText: 'Type username',
                  labelText: 'Login',
                  border: OutlineInputBorder(),
                )
            ),

            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: 'Type password',
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),

            ElevatedButton(
              onPressed: () async {
                login();
                showSaveDataDialog(context);

                String password = _passwordController.text;
                if (password == "123456"){
                  setState(() {
                    imageSource = 'images/idea.png';
                  });
                }else{
                  setState(() {
                    imageSource = 'images/stop.png';
                  });
                }

              },
              child: Text(
                  "Login", style:TextStyle(fontSize: 36.0,color: Colors.blue)
              ),
            ),

            Image.asset(imageSource, width: 300, height:300),
          ],
        ),
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
