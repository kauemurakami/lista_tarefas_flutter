import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _controller = TextEditingController();
  List _tarefas = [];

  Future<File> _getFile() async{
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}/dados.json");
  }

  _salvar() async {
    var arquivo = await _getFile();
    //criar dados
    Map<String, dynamic> tarefa = Map();
    tarefa["título"] = "Ir ao mercado";
    tarefa["realizada"] = false;
    _tarefas.add(tarefa);
    //converter json
    String dados = json.encode(_tarefas);
    //adicionando no arquivo
    arquivo.writeAsString(dados);

  }

  _ler() async{
    try{
      final arquivo = await _getFile();
      return arquivo.readAsString();
    }catch(e){
      return null;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ler().then(
        (dados){
         setState(() {
           _tarefas = json.decode(dados);
         });
        });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("Tarefas"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView.builder(
                itemCount: _tarefas.length,
                  itemBuilder: (context, index){
                    return ListTile(
                      title: Text(_tarefas[index]),
                    );
                  },
              ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        splashColor: Colors.purpleAccent,
        elevation: 8,
        onPressed: (){
          showDialog(
            context: context,
            builder: (context){
              return AlertDialog(
                title: Text("Adicionar tarefa ?"),
                content: TextField(
                  decoration: InputDecoration(
                    labelText: "Digite sua tarefa",
                    labelStyle: TextStyle(
                      color: Colors.purple,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purpleAccent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple),
                    ),
                  ),
                  onChanged: (text){

                  },
                  cursorColor: Colors.purpleAccent,
                ),
                actions: <Widget>[
                  FlatButton(
                    splashColor: Colors.red,
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancelar",
                        style: TextStyle(
                          color: Colors.red
                        ),
                      ),
                  ),
                  FlatButton(
                    splashColor: Colors.green,
                    onPressed: (){

                      Navigator.pop(context);
                    },
                    child: Text(
                      "Salvar",
                      style: TextStyle(
                          color: Colors.purple
                      ),
                    ),
                  )
                ],
              );
            }
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.menu, color: Colors.white,),
                onPressed: null
            ),
          ],
        ),
      ),
    );
  }
}
