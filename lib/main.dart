import 'dart:convert';

import 'package:emnlp_sh/sub.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KOAF',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var controller = TextEditingController(text: '');
  double value_ = 0;
  String abusive = '-';
  String sentiment = '-';
  String abusive_score = '-';
  String sentiment_score = '-';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(
          'Korea University',
          style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Noto'),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            alignment: Alignment.center,
            child: Container(
              alignment: Alignment.topLeft,
              width: MediaQuery.of(context).size.width * 0.7,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      height: 20,
                      color: Colors.transparent,
                    ),
                    Text(
                      '댓글 작성 (Add comment)',
                      style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Noto',
                          fontWeight: FontWeight.w600),
                    ),
                    Divider(
                      height: 30,
                      color: Colors.black,
                    ),
                    TextField(
                      onChanged: (value) {
                        setState(() {});
                      },
                      style: TextStyle(
                          color: Colors.grey[850],
                          fontSize: 20,
                          fontFamily: 'Noto',
                          fontWeight: FontWeight.w600),
                      maxLines: 2,
                      controller: controller,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Colors.black, width: 2)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey)),
                        hintText: '댓글 입력 (enter a comment)',
                        hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontSize: 20,
                            fontFamily: 'Noto',
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Divider(
                      height: 15,
                      color: Colors.transparent,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      // ignore: deprecated_member_use
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        onPressed: controller.text == ''
                            ? null
                            : () async {
                                var url =
                                    'http://163.152.23.120:5000/cls?text=';
                                url += controller.text.trim();
                                final response = await http.get(Uri.parse(url));
                                if (response.statusCode == 200) {
                                  var result = json.decode(response.body);
                                  var score = double.parse(
                                      result['result']['offensive_score']);
                                  var a_score =
                                      result['result']['abusive_score'];
                                  var s_score =
                                      result['result']['sentiment_score'];
                                  var a = result['result']['abusive'];
                                  var s = result['result']['sentiment'];

                                  setState(() {
                                    value_ = score;
                                    abusive = a;
                                    sentiment = s;
                                    abusive_score = a_score;
                                    sentiment_score = s_score;
                                  });
                                  return;
                                } else {
                                  throw Exception('Failed to load post');
                                }
                              },
                        color: Colors.cyan[800],
                        child: Container(
                          alignment: Alignment.center,
                          height: 60,
                          width: 120,
                          child: Text(
                            'Go!',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Noto',
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    new ModelOutput(value_, abusive, abusive_score, sentiment,
                        sentiment_score)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
