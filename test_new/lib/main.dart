import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Map<String, dynamic>> _items = [];
  bool _isProcessing = false;
  Map<String, dynamic>? _selectedItem;

  void _addItem() async {
    setState(() => _isProcessing = true);
    // 模拟数据处理过程
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _items.add({
        'title': '新标题 ${_items.length + 1}',
        'content': '内容 ${_items.length + 1}',
        'isChecked': false,
      });
      _isProcessing = false;
    });
  }

  void _deleteSelectedItems() {
    setState(() {
      _items.removeWhere((item) => item['isChecked']);
    });
  }

  void _editItem(Map<String, dynamic> item) {
    TextEditingController titleController =
        TextEditingController(text: item['title']);
    TextEditingController contentController =
        TextEditingController(text: item['content']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('编辑内容'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: '标题'),
              ),
              TextField(
                controller: contentController,
                decoration: InputDecoration(labelText: '内容'),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('保存'),
              onPressed: () {
                setState(() {
                  item['title'] = titleController.text;
                  item['content'] = contentController.text;
                  _selectedItem = null;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('创建内容'),
        actions: [
          if (_selectedItem != null)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => _editItem(_selectedItem!),
            ),
          if (_items.any((item) => item['isChecked']))
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _deleteSelectedItems,
            ),
        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: _items.length,
            itemBuilder: (context, index) {
              final item = _items[index];
              return CheckboxListTile(
                title: Text(item['title']),
                subtitle: Text(item['content']),
                secondary: Icon(MdiIcons.fileImage),
                value: item['isChecked'],
                onChanged: (bool? value) {
                  setState(() {
                    item['isChecked'] = value!;
                    if (value == true) {
                      _selectedItem = item;
                    } else {
                      if (_selectedItem == item) {
                        _selectedItem = null;
                      }
                    }
                  });
                },
              );
            },
          ),
          if (_isProcessing)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        tooltip: '创建',
        child: Icon(Icons.add),
      ),
    );
  }
}
