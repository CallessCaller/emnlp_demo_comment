import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ModelOutput extends StatefulWidget {
  final double value_;
  final String abusive_score;
  final String sentiment_score;
  final String abusive;
  final String sentiment;
  const ModelOutput(this.value_, this.abusive, this.abusive_score,
      this.sentiment, this.sentiment_score,
      {Key? key})
      : super(key: key);

  @override
  _ModelOutputState createState() => _ModelOutputState();
}

class _ModelOutputState extends State<ModelOutput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SfRadialGauge(
            animationDuration: 1000,
            enableLoadingAnimation: true,
            axes: <RadialAxis>[
              RadialAxis(
                  showFirstLabel: true,
                  showLastLabel: true,
                  minimum: 0,
                  maximum: 100,
                  showLabels: false,
                  showTicks: false,
                  radiusFactor: 0.8,
                  axisLineStyle: AxisLineStyle(
                      cornerStyle: CornerStyle.bothCurve,
                      color: Colors.black12,
                      thickness: 20),
                  pointers: <GaugePointer>[
                    RangePointer(
                        enableAnimation: true,
                        value: widget.value_,
                        cornerStyle: CornerStyle.bothCurve,
                        width: 20,
                        sizeUnit: GaugeSizeUnit.logicalPixel,
                        gradient: SweepGradient(
                            colors: widget.value_ > 67
                                ? <Color>[
                                    Colors.greenAccent,
                                    Colors.orangeAccent,
                                    Colors.redAccent,
                                  ]
                                : widget.value_ > 35
                                    ? <Color>[
                                        Colors.greenAccent,
                                        Colors.orangeAccent
                                      ]
                                    : <Color>[
                                        Colors.greenAccent,
                                      ],
                            stops: widget.value_ > 67
                                ? <double>[
                                    0.1,
                                    0.4,
                                    0.5,
                                  ]
                                : widget.value_ > 35
                                    ? <double>[0.25, 0.75]
                                    : <double>[1])),
                    MarkerPointer(
                        enableAnimation: true,
                        value: widget.value_,
                        enableDragging: false,
                        onValueChanged: null,
                        markerHeight: 34,
                        markerWidth: 34,
                        markerType: MarkerType.circle,
                        color: Colors.blueGrey,
                        borderWidth: 2,
                        borderColor: Colors.white54)
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                        angle: 90,
                        axisValue: 5,
                        positionFactor: 0.2,
                        widget: Text('${widget.value_}%\n',
                            style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: widget.value_ > 67
                                    ? Colors.redAccent
                                    : widget.value_ > 34
                                        ? Colors.orangeAccent
                                        : Colors.greenAccent)))
                  ])
            ]),
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          alignment: Alignment.topCenter,
          child: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.width * 0.05,
            width: MediaQuery.of(context).size.width * 0.5,
            decoration: BoxDecoration(),
            child: Text(
              widget.value_ > 67 ? '이 댓글은 삭제될 위험이 있습니다.' : '악의성이 없는 댓글입니다.',
              style: TextStyle(
                  color: Colors.grey[850],
                  fontFamily: 'Noto',
                  fontSize: 30,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    'Abusive',
                    style: TextStyle(
                        color: Colors.grey[850],
                        fontFamily: 'Noto',
                        fontSize: 17,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.width * 0.04,
                  width: MediaQuery.of(context).size.width * 0.12,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          width: 2.5, color: Colors.black.withOpacity(0.75))),
                  child: Text(
                    widget.abusive,
                    style: TextStyle(
                        color: Colors.grey[850],
                        fontFamily: 'Noto',
                        fontSize: 30,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    'Abusive score',
                    style: TextStyle(
                        color: Colors.grey[850],
                        fontFamily: 'Noto',
                        fontSize: 17,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.width * 0.04,
                  width: MediaQuery.of(context).size.width * 0.12,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          width: 2.5, color: Colors.black.withOpacity(0.75))),
                  child: Text(
                    widget.abusive_score + '%',
                    style: TextStyle(
                        color: Colors.grey[850],
                        fontFamily: 'Noto',
                        fontSize: 30,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    'Sentiment',
                    style: TextStyle(
                        color: Colors.grey[850],
                        fontFamily: 'Noto',
                        fontSize: 17,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.width * 0.04,
                  width: MediaQuery.of(context).size.width * 0.12,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          width: 2.5, color: Colors.black.withOpacity(0.75))),
                  child: Text(
                    widget.sentiment,
                    style: TextStyle(
                        color: Colors.grey[850],
                        fontFamily: 'Noto',
                        fontSize: 30,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    'Sentiment score',
                    style: TextStyle(
                        color: Colors.grey[850],
                        fontFamily: 'Noto',
                        fontSize: 17,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.width * 0.04,
                  width: MediaQuery.of(context).size.width * 0.12,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          width: 2.5, color: Colors.black.withOpacity(0.75))),
                  child: Text(
                    widget.sentiment_score + '%',
                    style: TextStyle(
                        color: Colors.grey[850],
                        fontFamily: 'Noto',
                        fontSize: 30,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
