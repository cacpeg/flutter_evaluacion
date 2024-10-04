import 'dart:convert';

import 'package:evaluacion/models/Generico.dart';
import 'package:evaluacion/services/api/prueba.dart';
import 'package:flutter/material.dart';

import 'package:evaluacion/services/httpInterseptor.dart' as http;
import 'package:google_fonts/google_fonts.dart';

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
      debugShowMaterialGrid: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.openSansTextTheme(
          Theme.of(context).textTheme,
        ),
        primaryColor: const Color(0xff79b329),
        fontFamily: "Monserrat",
        scaffoldBackgroundColor: const Color(0xffffffff),
        appBarTheme: const AppBarTheme(
          toolbarHeight: 50,
          centerTitle: true,
          backgroundColor: Color(0xffffffff),
          foregroundColor: Color(0xff585857),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),
        cardColor: Color(0xffffffff),
        cardTheme: CardTheme(
          surfaceTintColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        tabBarTheme: const TabBarTheme(
          labelColor: Colors.black,
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
        ),
        dialogTheme: const DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
        ),
        colorScheme: const ColorScheme.light(
            primary: Color(0xff79b329),
            onPrimary: Color(0xffffffff),
            primaryContainer: Color(0xff146049),
            secondary: Color(0xffFDC41F),
            onSecondary: Color(0xffffffff),
            tertiary: Color(0xff585857),
            onTertiary: Color(0xffffffff),
            tertiaryContainer: Color(0xffe7e7e7),
            onBackground: Color(0xfff2f2f2)),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff79b329),
          surfaceTintColor: Color(0xff79b329),
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        )),
        outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
                backgroundColor: Color(0xfff2f2f2),
                foregroundColor: const Color(0xff585857),
                side: const BorderSide(color: Color(0xff585857)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60)))),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        primaryColor: const Color(0xff79b329),
        appBarTheme: const AppBarTheme(
          toolbarHeight: 50,
          centerTitle: true,
          backgroundColor: Color(0xffF2F2F2),
          foregroundColor: Color(0xffffffff),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(25),
            ),
          ),
        ),
        dialogTheme: const DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xff79b329),
          onPrimary: Colors.black,
          primaryContainer: Color(0xff146049),
          secondary: Color(0xffFDC41F),
          tertiary: Color(0xff585857),
          onTertiary: Color(0xffffffff),
          tertiaryContainer: Color(0xff878787),
        ),
        scaffoldBackgroundColor: const Color(0xff131715),
        cardColor: const Color(0xff131A17),
        cardTheme: CardTheme(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        tabBarTheme: const TabBarTheme(
          labelColor: Color(0xffffffff),
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
        ),
        brightness: Brightness.dark,
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          foregroundColor: Color(0xffffffff),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
        )),
        outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xffF2C54A),
                side: const BorderSide(color: Color(0xffF2C54A)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60)))),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      themeMode: ThemeMode.light,
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
  bool loading = false;

  late List<Generico> _listaSucursalesData = [];
  void _incrementCounter() async {
    setState(() {
      loading = true;
    });
    PruebaService().obtenerSucursales().then((onValue) => {
          setState(() {
            _listaSucursalesData = onValue;

            loading = false;
          })
        });
  }

  peticionFront() {}

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
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // the App.build method, and use it to set our appbar title.
        // Here we take the value from the MyHomePage object that was created by
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: loading
                  ? [CircularProgressIndicator()]
                  : _listaSucursalesData
                      .map((toElement) => Text(toElement.descripcion))
                      .toList(),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        label: Text("oficinas"),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
