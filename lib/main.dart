import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gere_ta_coloc/article.dart';
import 'package:flutter/services.dart';
import 'package:gere_ta_coloc/colocs_class.dart';
import 'package:gere_ta_coloc/data_manager.dart';

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
  void initState()
  {
    super.initState();
    Future<List<String>> futurelist = DataManager.readColocFromJson();
    futurelist.then((value) {
      if (value != null) value.forEach((item) => listViewColocataire.add(item));
      actuallyLoading = true;
      setState(() {});
    });
  }

  @override
  void dispose() {
    myTextController.dispose();
    super.dispose();
  }

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    if (actuallyLoading) {
      return Scaffold(
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 13.0),
                        child: Text("Ajoute ton colocataire:"),
                      ),
                      TextField(
                        controller: myTextController,
                        obscureText: false,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors
                                .black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors
                                .black),
                          ),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            addingColocataireInListView(myTextController.text);
                            DataManager.writeColocToJson(myTextController.text);
                          },
                          child: const Text("Ajouter")
                      )
                    ]
                ),
              ),

              Expanded(
                  child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: listViewColocataire.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          listViewColocataire[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.red,),
                            onPressed: () {
                              setState(() {
                                listViewColocataire.removeAt(index);
                              });
                            }
                        ),
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
                                        itemCount: listViewColocataire.length
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
                      child: Text("${listViewColocataire.length}",
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

                              listViewColocataire.forEach((element) {
                                colocataire[element] = false;
                              });

                              listViewArticle.add(Article(
                                  nameTextController.text,
                                  priceTextController.text, colocataire));
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
        body:Text("JE CHARGE CONNARD \n"),
      );
    }

  }
}
