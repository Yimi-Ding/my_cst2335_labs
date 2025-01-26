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

      debugShowCheckedModeBanner: false,      // remove "Debug" banner

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
          title: Text("ABCDE"),
          actions: [
            OutlinedButton(onPressed: () { }, child:Text("Button 1")),
            OutlinedButton(onPressed: (){ }, child: Text("Button 2"))]
      ),

      drawer:Drawer(child:Text("Hi there")),// NavigationDrawer

        body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

            // button 1
            ElevatedButton(
                onPressed: () {  },
                child: Text("Button 1")),

            // button 2
            ElevatedButton(
                onPressed: () {  },
                child: Text("Button 2")),

            // button 3
            ElevatedButton(
                onPressed: () {  },
                child: Text("Button 3")),

            // button 4
            ElevatedButton(
                onPressed: () {  },
                child: Text("Button 4")),
          ],

        ),
      ),

      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem( icon: Icon(Icons.camera), label: 'Camera' ),
        BottomNavigationBarItem( icon: Icon(Icons.add_call), label: 'Phone'  ),
      ],
        onTap: (buttonIndex) {  } ,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
