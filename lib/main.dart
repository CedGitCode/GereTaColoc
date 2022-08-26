import 'package:flutter/material.dart';
import 'package:gere_ta_coloc/article.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePage();
}


class _MyHomePage extends State<MyHomePage> {

  List<Widget> listViewChildren = [];
  List<Article> listViewArticle = [];
  List<String> listViewColocataire = [];

  final myTextController = TextEditingController();
  final nameTextController = TextEditingController();
  final priceTextController = TextEditingController();

  void addingColocataireInListView(String textTyped) {
    if (textTyped.isEmpty) return;
    if (listViewColocataire.contains(textTyped)) return;

    setState(() {
      listViewColocataire.add(textTyped);
    });
  }

  @override
  void dispose() {
    myTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child:Column(
            children: <Widget>[
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:  <Widget>[
                    const Padding(
                      padding:EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 13.0),
                      child:Text("Ajoute ton colocataire:"),
                    ),
                    TextField(
                      controller: myTextController,
                      obscureText: false,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.visiblePassword,
                      decoration:const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.black),
                        ),
                      ),
                    ),
                    ElevatedButton(
                        onPressed:() => addingColocataireInListView(myTextController.text),
                        child:const Text("Ajouter")
                    )
                  ]
                ),
              ),

              Expanded(
                child:ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: listViewColocataire.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      title:Text(
                        listViewColocataire[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    );
                  },
                )
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: const Text("Gère ta Coloc"),
        ),
        body:SafeArea(
          child:ListView.separated(
            itemCount: listViewArticle.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              return ListTile(
                title:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(listViewArticle[index].name),
                      Text(listViewArticle[index].price + '\$')
                  ]
                )
              );
            },
          )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Ajout Article'),
                content: SingleChildScrollView(
                  reverse: true,
                  padding: EdgeInsets.all(50),
                  child:Column(
                    children: [
                      TextField(
                        controller: nameTextController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nom de l\'article',
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        controller: priceTextController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Prix'
                        ),
                      ),
                    ],
                  )
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Annuler'),
                  ),
                  TextButton(
                    onPressed: () => {
                      Navigator.pop(context, 'OK'),
                      setState(() {
                          listViewArticle.add(Article(nameTextController.text, priceTextController.text) );
                      })
                    },
                    child: const Text('Ajouter'),
                  ),
                ],

              ),
            );
            //Navigator.push(context, MaterialPageRoute(builder: (context) => Article()) );
          },
          tooltip: 'Ajout Nourritures',
          child: const Icon(Icons.add)
        ),
    );
  }
}
