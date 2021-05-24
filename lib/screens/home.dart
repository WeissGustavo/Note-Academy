import 'package:flutter/material.dart';
import 'package:note_academy/widgets/atividade_widget.dart';
import 'package:note_academy/widgets/rotina_widget.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Note Academy"),
            centerTitle: false,
            bottom: TabBar(
              tabs: [
                Tab(text: "Rotina"),
                Tab(text: "Atividades"),
                // Tab(text: "Calendário")
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              rotinaWidget(),
              atividades_widget(),
              // calendario_widget
            ],
          ),
        ));
  }
}
