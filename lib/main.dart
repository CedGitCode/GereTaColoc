import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gere_ta_coloc/article.dart';
import 'package:flutter/services.dart';
import 'package:gere_ta_coloc/data_manager.dart';
import 'package:gere_ta_coloc/views/leftView_colocataire.dart';
import "package:provider/provider.dart";
import "package:gere_ta_coloc/views/articleViews.dart";

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value:Article(" ", " ", {}),
        )
      ],
      child: MaterialApp(
        title:"Gère ta coloc",
        home:MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePage();
}


class _MyHomePage extends State<MyHomePage> {

  bool actuallyLoading = false;

  List<Widget> listViewChildren = [];
  List<Article> listViewArticle = [];
  List<String> listColocataire = [];


  final nameTextController = TextEditingController();
  final priceTextController = TextEditingController();

  @override
  void initState()
  {
    super.initState();
    DataManager.fetchColocsFromDB();

    Future<List<Map<String, Object?>>?> futurelist = DataManager.fetchColocsFromDB();
    futurelist.then((value) {
      if (value != null) value.forEach((item) => listColocataire.add(item.values.toString().replaceAll('(', '').replaceAll(')','')));
      actuallyLoading = true;
      setState(() {});
    });
  }

  void updateViews() {
    setState(() {});
  }

  @override
  void dispose() {
    nameTextController.dispose();
    priceTextController.dispose();
    super.dispose();
  }

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    if (actuallyLoading) {
      return Scaffold(
        drawer: leftViewColocataire(listColocataire: listColocataire, listArticle: listViewArticle, updateViews: updateViews,),
        appBar: AppBar(
          title: const Text("Gère ta Coloc"),
        ),
        body:articleViews(listArticle: listViewArticle),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) =>
                    AlertDialog(
                      title: const Text('Ajout Article'),
                      content: SingleChildScrollView(
                          reverse: true,
                          padding: EdgeInsets.all(50),
                          child: Column(
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
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
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
                          onPressed: () =>
                          {
                            Navigator.pop(context, 'OK'),
                            setState(() {
                              Map<String, bool> colocataire = {};

                              listColocataire.forEach((element) {
                                colocataire[element] = false;
                              });

                              listViewArticle.add(Article(
                                  nameTextController.text,
                                  priceTextController.text, colocataire));
                              DataManager.InsertAchats(nameTextController.text, priceTextController.text, "colocs");
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
    else {
      return Scaffold(
        body:Text("JE CHARGE CONNARD GROS FILS DE PUTE \n"),
      );
    }

  }
}
