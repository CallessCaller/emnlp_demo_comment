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
      title: 'EMNLP demo: KOAS',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
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
  bool is_bert = false;
  bool is_loading = false;
  double value_ = 0;
  String abusive = '-';
  String sentiment = '-';
  String abusive_score = '0';
  String sentiment_score = '0';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text.rich(
              TextSpan(children: [
                TextSpan(
                  text: 'KOAS',
                  style: TextStyle(
                      shadows: <Shadow>[
                        Shadow(
                            offset: Offset(0, 0),
                            blurRadius: 1,
                            color: Colors.black)
                      ],
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Noto',
                      fontSize: 40),
                ),
                TextSpan(
                  text: ': Korean Text Offensiveness Analysis System',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Noto',
                      fontSize: 26),
                )
              ]),
            ),
            Container(
              height: 60,
              child: Image.asset(
                'images/logo.png',
                fit: BoxFit.fitWidth,
              ),
            ),
          ],
        ),
        leadingWidth: MediaQuery.of(context).size.width,
        leading: Row(
          children: [
            VerticalDivider(
              color: Colors.transparent,
            ),
            Container(
              height: 60,
              child: Image.asset(
                'images/dilab.png',
                fit: BoxFit.fitWidth,
              ),
            ),
          ],
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '댓글 작성 (Add comment)',
                          style: TextStyle(
                              fontSize: 30,
                              fontFamily: 'Noto',
                              fontWeight: FontWeight.w600),
                        ),
                        Row(
                          children: [
                            Text(
                              'Choose model:   CNN',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Noto',
                                  fontWeight: FontWeight.w600),
                            ),
                            VerticalDivider(
                              color: Colors.transparent,
                            ),
                            Transform.scale(
                              scale: 2.0,
                              child: new Switch(
                                value: is_bert,
                                onChanged: (value) {
                                  setState(() {
                                    value_ = 0;
                                    abusive = '-';
                                    sentiment = '-';
                                    abusive_score = '0';
                                    sentiment_score = '0';
                                    is_bert = value;
                                  });
                                },
                                activeColor: Colors.blue,
                                inactiveThumbColor: Colors.pink,
                                inactiveTrackColor: Colors.pink[200],
                              ),
                            ),
                            VerticalDivider(
                              color: Colors.transparent,
                            ),
                            Text(
                              'BERT ',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Noto',
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '(BETA)',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                  fontFamily: 'Noto',
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      height: 30,
                      color: Colors.black,
                    ),
                    TextField(
                      onTap: value_ == 0
                          ? () {
                              setState(() {});
                            }
                          : () {},
                      onChanged: value_ == 0
                          ? (value) {
                              setState(() {});
                            }
                          : (value) {},
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
                        hintText: '댓글 입력 (input text)',
                        hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontSize: 20,
                            fontFamily: 'Noto',
                            fontWeight: FontWeight.w600),
                        // ignore: deprecated_member_use
                        suffix: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          onPressed: controller.text == ''
                              ? null
                              : is_loading
                                  ? null
                                  : () async {
                                      setState(() {
                                        value_ = 0;
                                        abusive = '-';
                                        sentiment = '-';
                                        abusive_score = '0';
                                        sentiment_score = '0';
                                        is_loading = true;
                                      });
                                      var url =
                                          'http://koas.korea.ac.kr:20000/cls?text=';
                                      url += controller.text.trim();
                                      url += is_bert
                                          ? '&mode=electra'
                                          : '&model=cnn';
                                      final response = await http
                                          .get(Uri.parse(url), headers: {
                                        "Accept": "application/json",
                                        "Access-Control-Allow-Origin": "*",
                                        //"Access-Control-Allow-Credentials": true,
                                        "Access-Control-Allow-Headers":
                                            "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
                                        "Access-Control-Allow-Methods":
                                            "POST, OPTIONS"
                                      });
                                      if (response.statusCode == 200) {
                                        var result = json.decode(response.body);

                                        var score = double.parse(
                                            result['result']
                                                ['offensive_score']);
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
                                          is_loading = false;
                                        });
                                        return;
                                      } else {
                                        throw Exception('Failed to load post');
                                      }
                                    },
                          color: is_bert ? Colors.blue : Colors.pink,
                          child: Container(
                            alignment: Alignment.center,
                            height: 60,
                            width: 120,
                            child:
                                //  is_loading
                                //     ? Column(
                                //         crossAxisAlignment:
                                //             CrossAxisAlignment.center,
                                //         mainAxisAlignment: MainAxisAlignment.center,
                                //         children: <Widget>[
                                //           Center(
                                //             child: Container(
                                //               height: 20,
                                //               width: 20,
                                //               margin: EdgeInsets.all(5),
                                //               child: CircularProgressIndicator(
                                //                 strokeWidth: 2.0,
                                //                 valueColor: AlwaysStoppedAnimation(
                                //                     Colors.white),
                                //               ),
                                //             ),
                                //           ),
                                //         ],
                                //       )
                                //     :
                                is_loading
                                    ? Text(
                                        'Wait...',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontFamily: 'Noto',
                                            fontWeight: FontWeight.w600),
                                      )
                                    : Text(
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
                    ),
                    new ModelOutput(value_, abusive, abusive_score, sentiment,
                        sentiment_score, is_loading)
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
