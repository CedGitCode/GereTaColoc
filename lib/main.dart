import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp()); 
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  List<Widget> listViewChildren = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Gère ta Coloc")
        ),
        body:SafeArea(
          child:ListView.separated(
            itemCount: listViewChildren.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              return ListTile(
                title:listViewChildren[index]
              );
            },
          )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => setState(() {
            listViewChildren.add(Text("Coucou"));
          }),
          tooltip: 'Ajout Nourritures',
          child: const Icon(Icons.add)
        ),
      ),
    );
  }
}
