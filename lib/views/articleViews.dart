import 'package:flutter/material.dart';

class articleViews extends StatefulWidget {
  const articleViews({Key? key, required this.listArticle}) : super(key: key);

  final listArticle;
  @override
  State<articleViews> createState() => _articleViewsState();
}

class _articleViewsState extends State<articleViews> {


  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: ListView.separated(
          itemCount: widget.listArticle.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            List nameofColoc = widget.listArticle[index].colocataire.keys
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
                                            value: widget.listArticle[index]
                                                .colocataire[nameofColoc[colocIndex]],
                                            onChanged: (bool? value) {
                                              setState(() {
                                                widget.listArticle[index]
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
                                    itemCount: widget.listArticle[index].colocataire.length
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
                  child: Text("${widget.listArticle[index].colocataire.length}",
                      style: TextStyle(fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),

                title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(widget.listArticle[index].name),
                      Text(widget.listArticle[index].price + '\$')
                    ]
                ),
                trailing: IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.black),
                    onPressed: () {
                      setState(() {
                        widget.listArticle.removeAt(index);
                      });
                    }
                )
            );
          },
        )
    );
  }
}
