import 'package:flutter/material.dart';

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
                },
                child: const Text("Login"),
            ),

          ],

          // question mark image

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
