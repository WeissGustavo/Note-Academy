import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:note_academy/widgets/rotina_widget.dart';
import 'package:path_provider/path_provider.dart';

class atividades_widget extends StatefulWidget {
  @override
  _atividades_widgetState createState() => _atividades_widgetState();
}

class _atividades_widgetState extends State<atividades_widget> {
  static List _atividadeList = [];
  List<String> _materiaList = rotinaWidget.materiaList;
  final _atividadeController = TextEditingController();
  String _materiaSelecionada;
  DateTime _dataDeEntrega;
  Map<String, dynamic> _ultimoRemovido;
  int _indexUltimoRemovido;

  @override
  void initState() {
    super.initState();
    _lerDados().then((value) {
      setState(() {
        _atividadeList = json.decode(value);
      });
    });
  }

  Future<String> _lerDados() async {
    try {
      final arquivo = await _abreArquivo();
      return arquivo.readAsString();
    } catch (e) {
      print("deu errado");
      return null;
    }
  }

  void _adicionarAtividade() {
    setState(() {
      Map<String, dynamic> novaAtividade = Map();
      novaAtividade['titulo'] = _atividadeController.text;
      novaAtividade['materia'] = _materiaSelecionada;
      novaAtividade['data'] = _dataDeEntrega;
      novaAtividade['realizado'] = false;
      _atividadeController.text = "";
      _materiaSelecionada = null;
      _dataDeEntrega = null;
      _atividadeList.add(novaAtividade);
      _salvarDados();
    });
  }

  Future<File> _salvarDados() async {
    String dados = json.encode(_atividadeList);
    final file = await _abreArquivo();
    return file.writeAsString(dados);
  }

  Future<File> _abreArquivo() async {
    final dir = await getApplicationDocumentsDirectory();
    return File("${dir.path}/atividadesList.json");
  }

  Future<Null> _refreshLista() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _atividadeList.sort((a, b) {
        if (a["realizado"] && !b["realizado"]) return 1;
        if (!a["realizado"] && b["realizado"]) return -1;
        return 0;
      });
      _salvarDados();
    });
  }

  Widget widgetAtividade(BuildContext context, int index) {
    return Dismissible(
      key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(0.85, 0),
          child: Icon(
            Icons.delete_forever_outlined,
            color: Colors.white,
          ),
        ),
      ),
      direction: DismissDirection.endToStart,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ExpansionTile(
              title: CheckboxListTile(
                  title: Text(_atividadeList[index]["titulo"]),
                  value: _atividadeList[index]['realizado'],
                  secondary: CircleAvatar(
                    child: Icon(
                      _atividadeList[index]['realizado']
                          ? Icons.check
                          : Icons.error,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _atividadeList[index]['realizado'] = value;
                      _salvarDados();
                    });
                  },
                  checkColor: Theme.of(context).primaryColor,
                  activeColor: Theme.of(context).secondaryHeaderColor),
              children: [
                Row(
                  children: [
                    Text(_atividadeList[index]['materia']),
                    Text(_atividadeList[index]['data'].toString())
                  ],
                )
              ],
            )
          ],
        ),
      ),
      onDismissed: (direction) {
        setState(() {
          _ultimoRemovido = Map.from(_atividadeList[index]);
          _indexUltimoRemovido = index;
          _atividadeList.removeAt(index);
          _salvarDados();
        });
        final snack = SnackBar(
          content: Text("Atividade \"${_ultimoRemovido['titulo']}\" Removida"),
          duration: Duration(seconds: 4),
          action: SnackBarAction(
            label: "Desfazer",
            onPressed: () {
              setState(() {
                _atividadeList.insert(_indexUltimoRemovido, _ultimoRemovido);
                _salvarDados();
              });
            },
          ),
        );
        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(snack);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Builder(
        builder: (context) => Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: _atividadeController,
                    maxLength: 50,
                    decoration: InputDecoration(labelText: "Nova Atividade"),
                  )),
                  Container(
                    child: RaisedButton(
                        color: Theme.of(context).accentColor,
                        child: Text("Data de Entrega"),
                        onPressed: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2001),
                                  lastDate: DateTime(2222))
                              .then((date) {
                            setState(() {
                              _dataDeEntrega = date;
                            });
                          });
                        }),
                  ),
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
                child: Row(children: [
                  Expanded(
                    child: DropdownButton(
                        hint: Text("Selecione uma Matéria"),
                        value: _materiaSelecionada,
                        onChanged: (value) {
                          setState(() {
                            print(value);
                            _materiaSelecionada = value;
                            print(_materiaSelecionada);
                          });
                        },
                        items: _materiaList.isEmpty
                            ? [
                                DropdownMenuItem(
                                    child: Text("Não há Nenhuma Matéria"))
                              ]
                            : _materiaList.map((String materia) {
                                return DropdownMenuItem(
                                    child: Text(materia), value: materia);
                              }).toList()),
                  ),
                  Container(
                    child: FloatingActionButton(
                      child: Icon(
                        Icons.save_sharp,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (_atividadeController.text.isEmpty) {
                          final alerta = SnackBar(
                            content: Text("A Atividade Precisa de um Titulo!"),
                            duration: Duration(seconds: 4),
                            action: SnackBarAction(
                                label: 'Ok',
                                onPressed: () {
                                  Scaffold.of(context).removeCurrentSnackBar();
                                }),
                          );
                          Scaffold.of(context).removeCurrentSnackBar();
                          Scaffold.of(context).showSnackBar(alerta);
                        } else if (_materiaSelecionada == null) {
                          final alerta = SnackBar(
                            content: Text("A Materia não pode ser vazia!"),
                            duration: Duration(seconds: 4),
                            action: SnackBarAction(
                                label: 'Ok',
                                onPressed: () {
                                  Scaffold.of(context).removeCurrentSnackBar();
                                }),
                          );
                          Scaffold.of(context).removeCurrentSnackBar();
                          Scaffold.of(context).showSnackBar(alerta);
                        } else if (_dataDeEntrega == null) {
                          final alerta = SnackBar(
                            content: Text(
                                "A Atividade Precisa de uma Data de Entrega"),
                            duration: Duration(seconds: 4),
                            action: SnackBarAction(
                                label: 'Ok',
                                onPressed: () {
                                  Scaffold.of(context).removeCurrentSnackBar();
                                }),
                          );
                          Scaffold.of(context).removeCurrentSnackBar();
                          Scaffold.of(context).showSnackBar(alerta);
                        } else {
                          _adicionarAtividade();
                        }
                      },
                    ),
                  )
                ])),
            Padding(padding: (EdgeInsets.only(top: 10.0))),
            Expanded(
                child: RefreshIndicator(
                    onRefresh: _refreshLista,
                    child: ListView.builder(
                      itemBuilder: widgetAtividade,
                      itemCount: _atividadeList.length,
                      padding: EdgeInsets.only(top: 10.0),
                    )))
          ],
        ),
      ),
    );
  }
}
