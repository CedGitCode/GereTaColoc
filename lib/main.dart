import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gere_ta_coloc/article.dart';
import 'package:flutter/services.dart';
import 'package:gere_ta_coloc/data_manager.dart';
import 'package:gere_ta_coloc/views/leftView_colocataire.dart';

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
        drawer:leftViewColocataire(listColocataire: listColocataire),
        appBar: AppBar(
          title: const Text("Gère ta Coloc"),
        ),
        body: SafeArea(
            child: ListView.separated(
              itemCount: listViewArticle.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                List nameofColoc = listViewArticle[index].colocataire.keys
                    .toList();

                return ListTile(
                    onTap: () =>
                    {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                                builder: (context, StateSetter setState) {
                                  return AlertDialog(
                                    title: Text("Colocataires"),
                                    content: ListView.separated(
                                        itemBuilder: (BuildContext context,
                                            int colocIndex) {
                                          return Row(
                                            children: [
                                              Checkbox(
                                                value: listViewArticle[index]
                                                    .colocataire[nameofColoc[colocIndex]],
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    listViewArticle[index]
                                                        .colocataire[nameofColoc[colocIndex]] =
                                                    value!;
                                                  });
                                                },
                                              ),
                                              Text(
                                                  nameofColoc[colocIndex]
                                              )
                                            ],
                                          );
                                        },
                                        separatorBuilder: (BuildContext context,
                                            int index) => const Divider(),
                                        itemCount: listColocataire.length
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Cancel'),
                                          child: const Text("Annuler")
                                      )
                                    ],
                                  );
                                }
                            );
                          }
                      )
                    },
                    leading: Container(
                      alignment: Alignment.center,
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text("${listColocataire.length}",
                          style: TextStyle(fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),

                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(listViewArticle[index].name),
                          Text(listViewArticle[index].price + '\$')
                        ]
                    ),
                    trailing: IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.black),
                        onPressed: () {
                          setState(() {
                            listViewArticle.removeAt(index);
                          });
                        }
                    )
                );
              },
            )
        ),
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
