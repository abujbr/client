import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';



String _txt='test1';
String _txt2='test2';
String _serverResponse = 'test3' ;
double _val= 1.0;

void main() async{
  runApp(const MyApp());

}

Future<void> sendMessage(Socket socket, String message) async {
  print('Client: $message');
  //_txt2=message;
  socket.write(message);
  await Future.delayed(Duration(seconds: 2));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int counter2= 0;

  void _incrementCounter() {
    setState(() {
      _txt = _serverResponse;
    });
  }
  void _connecting() async{
    final socket = await Socket.connect('localhost', 4567);
    print('Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');
    // listen for responses from the server
    socket.listen(
      // handle data from the server
          (Uint8List data) {
        _serverResponse = String.fromCharCodes(data);
        print('Server: $_serverResponse');
       setState(() {
          _val = double.parse(_serverResponse);
          _txt =_serverResponse;
        });
      },

      // handle errors
      onError: (error) {
        print(error);
        socket.destroy();
      },

      // handle server ending connection
      onDone: () {
        print('Server left.');
        socket.destroy();
      },
    );

    // send some messages to the server
    await sendMessage(socket, 'request value');
   /* await sendMessage(socket, 'Banana');
    await sendMessage(socket, 'Banana');
    await sendMessage(socket, 'Banana');
    await sendMessage(socket, 'Banana');
    await sendMessage(socket, 'Banana');
    await sendMessage(socket, 'Orange');
    await sendMessage(socket, "Orange you glad I didn't say banana again?");*/
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    _connecting();
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Stack(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.

       // width:  _val! * 100,
         // top: 1500,
          //mainAxisAlignment: MainAxisAlignment.center,


       //child: Column(


          children: <Widget>[
            Positioned(
                top: 20,
                left: _val * 30,
                child: Center(

            child: Image.asset('assets/image1.png'),
            //child: Image.asset('assets/image1.png'),
    )
            )


          ],
        //),
      ),

      /*floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),*/ // This trailing comma makes auto-formatting nicer for build methods.
    );


  }
}
