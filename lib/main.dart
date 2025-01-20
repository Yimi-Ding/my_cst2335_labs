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
  // 1. Change how the _counter variable is declared so that it uses var instead of double
  var _counter = 0.0;
  // 2. Declare another variable called myFontSize and have it initialized to 30.0
  var myFontSize = 30.0;


  // 3. Change the setNewValue() function so that it also sets your new myFontSize variable equal to the new value.
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

  //
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
            Text(
              'You have pushed the button this many times:',
              // 2. Change both the Text() widgets so that they use a TextStyle() object that are both set to that size.
              style: TextStyle(fontSize: myFontSize),
            ), Image.asset("images/algonquin.jpg", width: 200, height: 200),

            Text(
              '$_counter',
              //style: Theme.of(context).textTheme.headlineMedium,
              // update font size
              style: TextStyle(fontSize: myFontSize),
            ),
            Image.asset("images/ac-logo.jpg", width: 200, height: 200), //image
            Slider(value:_counter, max:100.0, onChanged: setNewValue, min:0.0 )
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
