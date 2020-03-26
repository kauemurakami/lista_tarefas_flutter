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
  Map<String,dynamic> _removido = Map();

  Future<File> _getFile() async{
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}/dados.json");
  }

  Widget criarItemLista(context, index){

    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (direction){

        //recuperar o item a ser excluido
        _removido = _tarefas[index];
        //remover item da lista
        _tarefas.removeAt(index);
        _salvarArquivo();

        //snackBar retroceder a decisão
        final snackbar = SnackBar(
          duration: Duration(seconds: 4),
          action: SnackBarAction(
              label: "Desfazer",
              onPressed: (){
                setState(() {
                  _tarefas.insert(index, _removido);
                  _salvarArquivo();
                });
              }),
            content: Text("Tarefa removida !"),
        );

        Scaffold.of(context).showSnackBar(snackbar);

      },
      background: Container(
        padding: EdgeInsets.all(16),
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ],
        )
      ),
        child: CheckboxListTile(
          title: Text(_tarefas[index]['titulo']),
          value: _tarefas[index]['realizada'],
          onChanged: (value){
            setState(() {
              _tarefas[index]['realizada'] = value;
            });
            _salvarArquivo();
          },
        ),
    );
  }

  _salvarArquivo() async {
    var arquivo = await _getFile();
    //converter json
    String dados = json.encode(_tarefas);
    //adicionando no arquivo
    arquivo.writeAsString(dados);
  }

  _salvarTarefa() async{
    String tarefaDigitada = _controller.text;

    Map<String, dynamic> tarefa = Map();
    tarefa["titulo"] = tarefaDigitada;
    tarefa["realizada"] = false;
    setState(() {
      _tarefas.add(tarefa);
    });
    _salvarArquivo();
    _controller.clear();
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
                  itemBuilder: criarItemLista
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
                  controller: _controller,
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
                      _salvarTarefa();
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
