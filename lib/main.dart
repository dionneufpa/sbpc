import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
//import 'dart:math';


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

  List poi = [
    [-1.386663, -48.422659, 'Esquina 01'],
    [-1.387168, -48.422453, 'Esquina 02'],
    [-1.387680, -48.423781, 'Esquina 03'],
    [-1.387168, -48.423986, 'Esquina 04']
  ];

  String lugar = '';
  
  Position? _position;
  double dist = 0;

  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
      const Duration(seconds: 5),
      (timer) {
        _getCurrentLocation();
      }
    );
  }

  void _getCurrentLocation() async {
    Position position = await _determinePosition();
    setState(() {
      _position = position;
    });

    double x1 = position.latitude;
    double y1 = position.longitude;
    double x2, y2;
    for(int i=0; i<4; i++) {
      x2 = poi[i][0];
      y2 = poi[i][1];
      dist = Geolocator.distanceBetween(x1, y1, x2, y2);  // distância em metros
      if( dist < 10) {
        lugar = poi[i][2];
      }
      else {
        lugar = 'Sem local';
      }
    }

    //AudioPlayer player = AudioPlayer();
    //player.play(AssetSource('Faixa1.mp3'));
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();

    if(permission == LocationPermission.denied ) {
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied) {
        return Future.error('Location permition are denied');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Geolocation App'),
      ),
      body: Center(
        child: _position != null ? Text('Current Location: $_position - $lugar - $dist') : const Text('No location data'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
