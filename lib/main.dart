import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // app bar
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("ABCDE"),
          actions: [
            // buttons in the app bar
            OutlinedButton(onPressed: () { }, child:Text("Button 1")),
            OutlinedButton(onPressed: (){ }, child: Text("Button 2"))]
      ),

      drawer:Drawer(child:Text("Hi there")),   // NavigationDrawer

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

      // bottom navigator bar
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem( icon: Icon(Icons.camera), label: 'Camera' ),
        BottomNavigationBarItem( icon: Icon(Icons.add_call), label: 'Phone'  ),
      ],
        onTap: (buttonIndex) {  } ,
      ),

    );
  }
}
