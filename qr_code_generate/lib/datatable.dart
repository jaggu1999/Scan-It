import 'package:flutter/material.dart';
import 'product.dart';
import 'services.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
class DataTableDemo extends StatefulWidget {

  DataTableDemo() : super();

  final String title = 'Flutter Data Table';

  @override
  DataTableState createState() => DataTableState();
}

class DataTableState extends State<DataTableDemo> {
  List<Product> _Products;
  GlobalKey<ScaffoldState> _scaffoldKey;
  Product _selectedProduct;
  bool _isUpdating;
  String _titleProgress;

  @override
  void initState() {
    super.initState();
    _Products = [];
    _isUpdating = false;
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _getProducts();
  }

  // Method to update title in the AppBar Title
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  _showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  _updateProduct(String a, String b) {
    setState(() {
      _isUpdating = true;
    });
    _showProgress('Updating Product...');
    Services.updateProduct(a,b)
        .then((result) {
      if ('success' == result) {
        _getProducts(); // Refresh the list after update
        setState(() {
          _isUpdating = false;
        });
        //_clearValues();
      }
    });
  }
  _getProducts() {
    _showProgress('Loading Employees...');
    Services.getProducts().then((products) {
      setState(() {
        _Products = products;
      });
      _showProgress(widget.title); // Reset the title...
      print("Length ${products.length}");
    });
  }
  _deleteProduct(Product Product) {
    _showProgress('Deleting Product...');
    Services.deleteProduct(Product.proname, Product.manu).then((result) {
      if ('success' == result) {
        _getProducts(); // Refresh after delete...
      }
    });
  }

  String result = "0",pron="",price="";
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
        pron = date[6];
        price = date[7];
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
        _updateProduct(pron,s1);
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
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_titleProgress),
      ),
      body:
      Center(

      ),floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        label: Text("SCAN"),
        onPressed: _scanQR,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}