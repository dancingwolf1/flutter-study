import 'package:flutter/material.dart';
import 'package:flutter_spterp/component/appbar.dart';
import 'package:signature/signature.dart';

class MySignaturePage extends StatefulWidget {
  @override
  MySignaturePageState createState() => MySignaturePageState();
}

class MySignaturePageState extends State<MySignaturePage> {
  var _signatureCanvas = Signature(
    height: 300,
    backgroundColor: Colors.lightBlueAccent,
  );


  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Scaffold(
        appBar: getAppBar(
          context,
          "MySignature",
        ),
        body: Container(
          padding: EdgeInsets.only(right: 20),
          child: ListView(
            children: <Widget>[
              _signatureCanvas,
              //OK AND CLEAR BUTTONS
              Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      //SHOW EXPORTED IMAGE IN NEW ROUTE
                      IconButton(
                        icon: const Icon(Icons.check),
                        color: Colors.blue,
                        onPressed: () async {
                          if (_signatureCanvas.isNotEmpty) {
                            var data = await _signatureCanvas.exportBytes();
                            print("：：：："+data.toString());
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return Scaffold(
                                    appBar: AppBar(),
                                    body: Container(
                                      color: Colors.grey[300],
                                      child: Image.memory(data),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                        },
                      ),
                      //CLEAR CANVAS
                      IconButton(
                        icon: const Icon(Icons.clear),
                        color: Colors.blue,
                        onPressed: () {
                          setState(() {
                            return _signatureCanvas.clear();
                          });
                        },
                      ),
                    ],
                  )),
            ],
          ),
        ),
      )
    ]);
  }

}
