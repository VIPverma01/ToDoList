import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

void main() {
  runApp((MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  )));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> todolist = [];
  List<bool> ischecked = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  addinlist(String context) {
    todolist.add(context);
    _listKey.currentState.insertItem(todolist.length - 1);
    setState(() {});
  }

  addnewtodo(BuildContext context) {
    TextEditingController newtodocontroller = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30))),
          title: Text('Add TODO task'),
          content: TextField(
            controller: newtodocontroller,
            decoration: InputDecoration(
              hintText: 'Add TODO task here',
            ),
          ),
          actions: <Widget>[
            RawMaterialButton(
              child: Text(
                'Add',
                style: TextStyle(fontSize: 15),
              ),
              fillColor: Colors.white,
              elevation: 10.0,
              shape: CircleBorder(),
              onPressed: () {
                addinlist(newtodocontroller.text);
                ischecked.add(false);
                Navigator.of(context, rootNavigator: true).pop();
                newtodocontroller.clear();
              },
            ),
          ],
        );
      },
    );
  }

  Tween<Offset> _offset = Tween(begin: Offset(0, 5), end: Offset(0, 0));
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TO DO List',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              '${now.day}-${now.month}-${now.year}',
              style: TextStyle(color: Colors.white, fontSize: 14.0),
            )
          ],
        ),
      ),
      body: AnimatedList(
        key: _listKey,
        initialItemCount: todolist.length,
        itemBuilder: (context, index, animation) {
          return SlideTransition(
            position: animation.drive(_offset),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Checkbox(
                        value: ischecked[index],
                        onChanged: (val) {
                          setState(() {
                            ischecked[index] = val;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      flex: 15,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 20.0),
                        child: Text(
                          todolist[index],
                          style: TextStyle(
                              fontSize: 16,
                              color: ischecked[index]
                                  ? Colors.grey[500]
                                  : Colors.black),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: RawMaterialButton(
                          child: Icon(
                            Icons.delete,
                          ),
                          fillColor: Colors.white,
                          elevation: 10.0,
                          shape: CircleBorder(),
                          onPressed: () {
                            todolist.removeAt(index);
                            ischecked.removeAt(index);
                            _listKey.currentState.removeItem(index,
                                (context, animation) {
                              return SizedBox(
                                width: 0,
                                height: 0,
                              );
                            });
                            setState(() {});
                          }),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addnewtodo(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
