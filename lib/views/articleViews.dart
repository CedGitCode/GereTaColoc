import 'package:flutter/material.dart';
import 'package:gere_ta_coloc/data_manager.dart';
import 'package:gere_ta_coloc/dbg_class.dart';
import 'package:gere_ta_coloc/math_logic.dart';
import 'package:gere_ta_coloc/article.dart';
import 'package:gere_ta_coloc/colocs_class.dart';

class articleViews extends StatefulWidget {

  const articleViews({Key? key, required  this.listColocataire, required this.listArticle, required this.updateViews}) : super(key: key);

  final List<Colocs> listColocataire;
  final List<Article> listArticle;
  final Function updateViews;

  @override
  State<articleViews> createState() => _articleViewsState();
}

class _articleViewsState extends State<articleViews> {

  void updateViews() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: ListView.separated(
          itemCount: widget.listArticle.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            List nameofColoc = widget.listArticle[index].colocataire.keys.toList();

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
                                content: Container(
                                    width: double.maxFinite,
                                        child: ListView.separated(
                                    itemBuilder: (BuildContext context,
                                        int colocIndex) {
                                      return Row(
                                        children: [
                                          Checkbox(
                                            value: widget.listArticle[index].colocataire[nameofColoc[colocIndex]],
                                            onChanged: (bool? value) {
                                              widget.listArticle[index]
                                                  .colocataire[nameofColoc[colocIndex]] = value!;
                                              setState(() {});
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
                                ),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: ()  {
                                        MathLogic.updateColocOwnExpenses(widget.listArticle, widget.listColocataire);
                                        DataManager.UpdateAchats(widget.listArticle);
                                        Navigator.pop(context, 'Cancel');
                                        updateViews();
                                        },
                                      child: const Text("Quitter")
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
                  child: Text("${widget.listArticle[index].getColoc()}",
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
                        DataManager.DeleteAchats(widget.listArticle[index].name);
                        widget.listArticle.removeAt(index);
                        widget.updateViews();
                      });
                    }
                )
            );
          },
        )
    );
  }
}
