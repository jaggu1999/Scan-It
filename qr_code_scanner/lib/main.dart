import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/percent_indicator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  String result = "0",proname="",price="";
  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        List<String> date=qrResult.split(",");
        String d1=(date[0]);
        String m1=(date[1]);
        String y1=(date[2]);
        String s1 = y1+"-"+m1+"-"+d1;
        String d2=(date[3]);
        String m2=(date[4]);
        String y2=(date[5]);
        proname = date[6];
        price = "₹"+date[7];
        String s2 = y2+"-"+m2+"-"+d2;
        final date1 = DateTime.parse(s1);
        final date2 = DateTime.parse(s2);
        final dur1 =  date2.difference(date1).inDays+1;
        final temp = DateTime.now();
        String curr = temp.toString();
        curr = curr.substring(0,10);
        final dur2 = DateTime.parse(curr).difference(date1).inDays+1;
        int val=0;
        if(dur1>=dur2){
          val = (100-(dur2/dur1)*100).toInt();
        }
        result = val.toString();
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "0";
        });
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Container(
                  child: Text("Camera Permission was Denied!!"),
                ),
              );
            });
      } else {
        setState(() {
          result = "0";
        });
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Container(
                  child: Text("Unknown Error $ex"),
                ),
              );
            });
      }
    } on FormatException {
      setState(() {
        result = "0";
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Container(
                child: Text("Haven't Scanned Anything!!"),
              ),
            );
          });
    } catch (ex) {
      setState(() {
        result = "0";
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Container(
                child: Text("Unknown Error $ex"),
              ),
            );
          });
    }
  }

  @override
  void initState(){
    super.initState();
    result = "0";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan!t"),
        backgroundColor: Colors.cyan,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 50),
            child: Center(
              child: Text(
                proname,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ),
          ),
          SizedBox(height: 50,),
          Center(
              child: CircularPercentIndicator(
                radius: 200.0,
                lineWidth: 40.0,
                animation: true,
                animationDuration: 500,
                percent: int.parse(result)/100,
                center: Text("${int.parse(result)}%",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                  ),),
                circularStrokeCap: CircularStrokeCap.butt,
                progressColor: Colors.green,
                backgroundColor: Colors.red,
              ),
          ),
          SizedBox(height: 30,),
          Container(
            child: Center(
              child: Text(
                price,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.pinkAccent,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        label: Text("SCAN"),
        onPressed: _scanQR,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}