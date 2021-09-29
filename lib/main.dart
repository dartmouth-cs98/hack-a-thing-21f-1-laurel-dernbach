import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:english_words/english_words.dart';
import 'dart:convert';
import 'dart:core';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
    Widget build(BuildContext context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Startup Name Generator',
        theme: ThemeData(
            brightness: Brightness.dark,
        ),
        home: RandomWords(),
      );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _bandNames = <String>[];
  // final _suggestions = <WordPair>[];
  final _saved = <String>{};
  final _biggerFont = const TextStyle(fontSize: 18);
  @override
  Widget build(BuildContext context) {
    return Scaffold (
          appBar: AppBar(
            title: Text('Startup Name Generator'),
            actions: [
                IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
            ],
          ),
          body: _buildSuggestions(),
        );
  }

  readFilesFromAssets() async {
    String text = await rootBundle.loadString('assets/BNtest.txt');

    // print(text);

    LineSplitter ls = new LineSplitter();
    List<String> lines = ls.convert(text);
    //print(lines);
    //_bandNames = ls.convert(text);
    _bandNames.addAll(lines);
    print(_bandNames[1]);
    print(_bandNames[0]);
    //return lines;
  }

  Widget _buildSuggestions() {
     readFilesFromAssets();
     return ListView.builder(
       padding: const EdgeInsets.all(16),
       itemBuilder: (BuildContext _context, int i) {
         print(i);
         if (i.isOdd) {
             return Divider();
         }
         final int index = i ~/ 2;
         //if (index < _bandNames.length) {
           //return _buildRow(_bandNames[index]);
         //}
         return _buildRow(_bandNames[index]);
       }
     );
  }

  Widget _buildRow(String pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
        title: Text(
            pair,
            style: _biggerFont,
        ),
        trailing: Icon(
            alreadySaved ? Icons.favorite : Icons.favorite_border,
            color: alreadySaved ? Colors.red : null,
        ),
        onTap: () {     
          setState(() {
            if (alreadySaved) {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          });
        },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
        MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  final tiles = _saved.map(
                    (String pair) {
                      return ListTile(
                        title: Text(
                          pair,
                          style: _biggerFont,
                        ),
                      );
                    },
                  );
                  final divided = tiles.isNotEmpty
                      ? ListTile.divideTiles(context: context, tiles: tiles).toList()
                      : <Widget>[];

                  return Scaffold(
                    appBar: AppBar(
                      title: Text('Saved Suggestions'),
                    ),
                    body: ListView(children: divided),
                  );
                },
              ),
    );
  }
}
