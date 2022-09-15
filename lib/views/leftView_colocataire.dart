import "package:flutter/material.dart";
import 'package:gere_ta_coloc/colocs_class.dart';

import "package:gere_ta_coloc/data_manager.dart";
import "package:gere_ta_coloc/article.dart";
import 'package:gere_ta_coloc/dbg_class.dart';
import 'package:gere_ta_coloc/math_logic.dart';
import "package:gere_ta_coloc/views/articleViews.dart";

class leftViewColocataire extends StatefulWidget {
  const leftViewColocataire({Key? key, required List<Colocs> this.listColocataire, required this.listArticle, required this.updateViews}) : super(key: key);

  final List<Colocs> listColocataire;
  final List<Article> listArticle;
  final Function updateViews;

  @override
  State<leftViewColocataire> createState() => _leftViewColocataireState();
}

class _leftViewColocataireState extends State<leftViewColocataire> {

  final myTextController = TextEditingController();


 /* void addingColocataireInListView(String textTyped) {
    if (textTyped.isEmpty) return;
    if (widget.listColocataire.contains(textTyped)) return;

    setState(() {
      widget.listColocataire.add(textTyped);
    });
  }*/

  void addingColocataire(String textTyped) {
    if (textTyped.isEmpty) return;
    widget.listColocataire.forEach((element) {
      if(element.name == textTyped) return;
    });

    setState(() {
      Colocs newColocs = Colocs(name: textTyped, expensesPerAchats: 0);
      DataManager.InsertColocs(newColocs);
      widget.listColocataire.add(newColocs);

      for( Article element in widget.listArticle) {
        element.updateNumberColocataire();
      }
    });
  }

  @override
  void dipose(){
    myTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                        if (myTextController.text.isEmpty) return;
                        widget.listColocataire.forEach((element) {
                          if(element.name == myTextController.text) return;
                        });
                        addingColocataire(myTextController.text);

                        for( Article element in widget.listArticle) {
                          element.colocataire[myTextController.text] = false;
                        }

                        widget.updateViews();
                        DebugInfos.printPerColocsExpenses(widget.listColocataire);
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
                itemCount: widget.listColocataire.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  return ListTile(
                    title:Row(
                      children: <Widget> [

                        Text(
                        widget.listColocataire[index].name,
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                        Expanded(
                            child:Text(
                          "${widget.listColocataire[index].expensesPerAchats.toStringAsFixed(2)}\$",
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          )
                        ),
                    ]
                    ),
                    trailing: IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red,),
                        onPressed: () {
                          setState(() {
                            widget.listArticle.forEach((element) {
                              element.colocataire.remove(widget.listColocataire[index].name);
                            });
                            DataManager.DeleteColocs(widget.listColocataire[index].name);
                            widget.listColocataire.removeAt(index);
                            DataManager.UpdateAllData(widget.listArticle, widget.listColocataire);
                          });
                        }
                    ),
                  );
                },
              )
          )
        ],
      ),
    );
  }
}
