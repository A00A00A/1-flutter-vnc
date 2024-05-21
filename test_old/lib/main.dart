import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'test_new',
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
    await Future.delayed(Duration(seconds: 1));
    final int index = _items.length;
    Map<String, dynamic> newItem = {
      'title': '新标题 ${index + 1}',
      'content': '内容 ${index + 1}',
      'fileimage': 'abacus',
      'isChecked': false,
    };
    setState(() {
      _items.insert(index, newItem);
      _isProcessing = false;
    });
    _listKey.currentState?.insertItem(index);
  }
  void _deleteSelectedItems() {
    final List<int> checkedItems = _items.asMap().entries
      .where((entry) => entry.value['isChecked'])
      .map((entry) => entry.key)
      .toList();
    for (int index in checkedItems.reversed) {
      var item = _items.removeAt(index);
        _listKey.currentState?.removeItem(
        index,
        (context, animation) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Interval(0.5, 1.0),
            ),
            child: SizeTransition(
              sizeFactor: animation,
              axisAlignment: 0.0,
              child: CheckboxListTile(
                title: Text(item['title']),
                subtitle: Text(item['content']),
                secondary: Icon(MdiIcons.fromString(item['fileimage'])),
                value: item['isChecked'],
                onChanged: null,
              ),
            ),
          );
        },
        duration: Duration(milliseconds: 200),
      );
    }
  }
  void _editItem(Map<String, dynamic> item) {
    TextEditingController titleController =
        TextEditingController(text: item['title']);
    TextEditingController contentController =
        TextEditingController(text: item['content']);
    TextEditingController imageController =
        TextEditingController(text: item['fileimage']);
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
              TextField(
                controller: imageController,
                decoration: InputDecoration(labelText: '图片名字'),
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
                  item['fileimage'] = imageController.text;
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
          AnimatedList(
            key: _listKey,
            initialItemCount: _items.length,
            itemBuilder: (context, index, animation) {
              final item = _items[index];
              return FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  child: CheckboxListTile(
                    title: Text(item['title']),
                    subtitle: Text(item['content']),
                    secondary: Icon(MdiIcons.fromString(item['fileimage'])),
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
                  ),
                ),
              );
            },
          )
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