import "package:flutter/material.dart";
import "package:gere_ta_coloc/data_manager.dart";

class leftViewColocataire extends StatefulWidget {
  const leftViewColocataire({Key? key, required List<String> this.listColocataire }) : super(key: key);

  final List<String> listColocataire;

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
