import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:todo_mvc_mobX_Modular/app/modules/home/components/item_tile.dart';
import 'package:todo_mvc_mobX_Modular/app/modules/home/models/todo_model.dart';
import 'home_controller.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key key, this.title = "Home"}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, HomeController> {
  //use 'controller' variable to access controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Observer(
        builder: (_) {
          if (controller.todoList.hasError) {
            return Center(
              child: RaisedButton(
                onPressed: controller.getList,
                child: Text('Error'),
              ),
            );
          }

          if (controller.todoList.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<TodoModel> list = controller.todoList.data;
          return ListView.builder(
              itemCount: list.length,
              itemBuilder: (_, index) {
                TodoModel model = list[index];
                return ItemTile(
                  model: model,
                  ontap: () => _showDialog(model),
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialog,
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }

  _showDialog([TodoModel model]) {
    model ??= TodoModel();
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(model.title.isEmpty ? 'Novo' : 'Editar'),
          content: TextFormField(
            initialValue: model.title,
            onChanged: (value) => model.title = value,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Digite',
            ),
          ),
          actions: [
            FlatButton(
              child: Text('Cancelar'),
              onPressed: () => Modular.to.pop(),
            ),
            FlatButton(
              child: Text('Salvar'),
              onPressed: () async {
                await controller.save(model);
                Modular.to.pop();
              },
            )
          ],
        );
      },
    );
  }
}
