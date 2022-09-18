import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gere_ta_coloc/article.dart';
import 'package:flutter/services.dart';
import 'package:gere_ta_coloc/colocs_class.dart';
import 'package:gere_ta_coloc/data_manager.dart';
import 'package:gere_ta_coloc/math_logic.dart';
import 'package:gere_ta_coloc/views/leftView_colocataire.dart';
import "package:gere_ta_coloc/views/articleViews.dart";
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
  );

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title:"Gère ta coloc",
        home:MyHomePage()
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
  List<Colocs> listColocataire = [];

  final nameTextController = TextEditingController();
  final priceTextController = TextEditingController();

  @override
  void initState()
  {
    super.initState();

    List<Object?> colocsInfo = [];
    List<Object?> achatsInfo = [];
    List<String> newColocsList = [];
    Map<String, bool> colocataireMap = {};


    Future<List<Map<String, Object?>>?> futureColocslist = DataManager.fetchColocsFromDB();
    Future<List<Map<String, Object?>>?> futureAchatslist = DataManager.fetchAchatsFromDB();

    futureColocslist.then((value) {
      if (value != null) value.forEach((item) {
        colocsInfo = item.values.toList();
        listColocataire.add(Colocs(name: colocsInfo[1].toString(),
            expensesPerAchats: double.parse(colocsInfo[2].toString())));
        colocataireMap[colocsInfo[1].toString()] = false;
      });
    });

    futureAchatslist.then((value) {
      if (value != null) value.forEach((item) {
        Map<String, bool> newMap = Map.from(colocataireMap);
        achatsInfo = item.values.toList();
        newColocsList = achatsInfo[3].toString().replaceAll(' ', '').split(',');

        newColocsList.forEach((element) {
          if(newMap.containsKey(element))
            {
              newMap[element] = true;
            }
        });
        Article newArticle = Article(achatsInfo[1].toString(), achatsInfo[2].toString(), newMap);
        listViewArticle.add(newArticle);

      });


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
        body:articleViews(listColocataire: listColocataire, listArticle: listViewArticle, updateViews: updateViews),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              nameTextController.clear();
              priceTextController.clear();

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
                          onPressed: () {
                            Navigator.pop(context, 'Cancel');
                          },
                          child: const Text('Annuler'),
                        ),
                        TextButton(
                          onPressed: () =>
                          {
                            if (priceTextController.text.isNotEmpty && nameTextController.text.isNotEmpty) {
                              Navigator.pop(context, 'OK'),
                              setState(() {
                                Map<String, bool> colocataire = {};

                                listColocataire.forEach((element) {
                                  colocataire[element.name] = true;
                                });

                                Article newArticle = Article(nameTextController.text, priceTextController.text, colocataire);
                                listViewArticle.add(newArticle);
                                DataManager.InsertAchats(newArticle);

                                MathLogic.updateColocOwnExpenses(listViewArticle, listColocataire);
                              })
                            }
                          },
                          child: const Text('Ajouter'),
                        ),
                      ],
                    ),
              );
            },
            tooltip: 'Ajout Nourritures',
            child: const Icon(Icons.add)
        ),
        bottomNavigationBar: BottomAppBar(
          child:Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.1,
            color: Colors.blue,
            child:Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child:Text(
              "Prix total: ${MathLogic.getTotalPrice(listViewArticle).toStringAsFixed(2)}\$",
              style:const TextStyle(
                fontSize: 22
              ),
              textAlign: TextAlign.center,
            )
            )
          )
        ),
      );
    }
    else {
      return Scaffold(
        body:Text("JE CHARGE \n"),
      );
    }

  }
}
