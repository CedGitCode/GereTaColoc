import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:gere_ta_coloc/data_manager.dart";
import "package:gere_ta_coloc/article.dart";
import "package:gere_ta_coloc/views/articleViews.dart";

class leftViewColocataire extends StatefulWidget {
  const leftViewColocataire({Key? key, required List<String> this.listColocataire, required this.listArticle, required this.updateViews}) : super(key: key);

  final List<String> listColocataire;
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
    if (widget.listColocataire.contains(textTyped)) return;

    setState(() {
      DataManager.InsertColocs(textTyped);
      widget.listColocataire.add(textTyped);

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
                        if (widget.listColocataire.contains(myTextController.text)) return;
                        addingColocataire(myTextController.text);

                        for( Article element in widget.listArticle) {
                          element.colocataire[myTextController.text] = false;
                        }

                        widget.updateViews();
                        Navigator.pop(context, true);
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
                    title: Text(
                      widget.listColocataire[index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red,),
                        onPressed: () {
                          setState(() {
                            DataManager.DeleteColocs(widget.listColocataire[index]);
                            widget.listColocataire.removeAt(index);
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
