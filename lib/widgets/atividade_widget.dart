import 'package:flutter/material.dart';
import 'package:note_academy/widgets/rotina_widget.dart';

class atividades_widget extends StatefulWidget {
  @override
  _atividades_widgetState createState() => _atividades_widgetState();
}

class _atividades_widgetState extends State<atividades_widget> {
  static List _atividadeList = [];
  List<String> _materiaList = rotinaWidget.materiaList;
  final _atividadeController = TextEditingController();
  String _materiaSelecionada = "Selecione uma Materia";
  DateTime _dataDeEntrega;

  // Widget widgetAtividade(BuildContext context, int index) {
  //   return Dismissible(
  //     key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
  //     background: Container(
  //       color: Colors.red,
  //       child: Align(
  //         alignment: Alignment(0.85, 0),
  //         child: Icon(
  //           Icons.delete_forever_outlined,
  //           color: Colors.white,
  //         ),
  //       ),
  //     ),
  //     direction: DismissDirection.endToStart,
  //   );
  // }

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
                    child: DropdownButton(
                        value: _materiaSelecionada == null
                            ? "Selecione uma Materia"
                            : _materiaSelecionada,
                        onChanged: (newValue) {
                          setState(() {
                            _materiaSelecionada = newValue;
                          });
                        },
                        items: _materiaList.map((String materia) {
                          return DropdownMenuItem(child: Text(materia));
                        }).toList()),
                  ),
                  Container(
                    child: FloatingActionButton(
                        child: Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.white,
                        ),
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
                  Container(
                    child: FloatingActionButton(
                      child: Icon(
                        Icons.save_sharp,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
