import 'package:enigma_flutter/scrambling_unit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.orange,
        accentColor: Colors.amber,
      ),
      home: MainPage(title: 'Enigma'),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  TextEditingController tec = new TextEditingController();

  List<String> key = ["A", "A", "A"];
  List<String> memKey = [];
  final List<String> charList = new List<String>.generate(
    26, 
    (index) => String.fromCharCode("A".codeUnitAt(0) + index)
  );

  ScramblingUnit scramblingUnit = new ScramblingUnit(
    [
      "HJLCPRTXVZNYEIWGAKMUSQOBDF", 
      "JDKSIRUXBLHWTMCQGZNPYFVOEA", 
      "EKMFLGDQVZNTOWYHXUSPAIBRCJ"
    ], 
    "GMKOFPNAJXZYRHICVLEBSTDUQW"
  );

  String codedMessageOutput = "";
  String usedKey = "Key: A A A";

  @override
  void initState() {
    super.initState();

    scramblingUnit.setKey(key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Image.asset("assets/enigma_logo.png", fit: BoxFit.cover),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Row(
                    children: <Widget>[
                      
                      DropdownButton(
                        value: key.elementAt(0),
                        onChanged: (String position) {
                          setState(() {
                            scramblingUnit.setPositionRotor(0, position);
                            key[0] = scramblingUnit.getPositionRotor(0);
                            scramblingUnit.resetRevCounter();
                          });
                        },
                        items: charList.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),

                      Padding(padding: EdgeInsets.only(right: 40)),

                      DropdownButton(
                        value: key.elementAt(1),
                        onChanged: (String position) {
                          setState(() {                        
                            scramblingUnit.setPositionRotor(1, position);
                            key[1] = scramblingUnit.getPositionRotor(1);
                            scramblingUnit.resetRevCounter();
                          });
                        },
                        items: charList.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),

                      Padding(padding: EdgeInsets.only(right: 40)),
                        
                      DropdownButton(
                        value: key.elementAt(2),
                        onChanged: (String position) {
                          setState(() {                        
                            scramblingUnit.setPositionRotor(2, position);
                            key[2] = scramblingUnit.getPositionRotor(2);
                            scramblingUnit.resetRevCounter();
                          });
                        },
                        items: charList.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),

                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      
                      Text(
                        usedKey,
                        style: TextStyle(
                          color: Theme.of(context).hintColor
                        ),
                      ),

                      FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child: Text(
                          "MEMORIZZA CHIAVE"
                        ),
                        onPressed: changeKey,
                      ),
                    
                    ],
                  ),

                  //Output container
                  Container(
                    padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 5),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    height: 300,
                    child: Column(
                      children: <Widget> [
                        
                        Expanded(
                          flex: 4,
                          child: SingleChildScrollView(
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                codedMessageOutput,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 20
                                ),
                              ),
                            )
                          ),
                        ),
                        
                        Expanded(                       
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[

                              IconButton(
                                icon: Icon(Icons.content_copy),
                                color: Theme.of(context).hintColor,
                                tooltip: "Copia",
                                onPressed: () {
                                  if(codedMessageOutput.isNotEmpty) {
                                    Clipboard.setData(
                                      ClipboardData(text: codedMessageOutput)
                                    );
                                    Scaffold.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.black38,
                                        content: Text(
                                          "Testo copiato",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16
                                          ),
                                        )
                                      )
                                    );
                                  }
                                },
                              ),

                              IconButton(
                                icon: Icon(Icons.cancel),
                                color: Theme.of(context).hintColor,
                                tooltip: "Cancella",
                                onPressed: () {
                                  setState(() {
                                    codedMessageOutput = "";
                                  });
                                },
                              ),
                              
                            ] 
                          ),
                        )

                      ]
                    )
                  ),

                  Padding(padding: EdgeInsets.all(10)),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child: TextField(
                      controller: tec,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 15, right: 5, top: 10, bottom: 15),
                        labelText: 'Messaggio',
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(Icons.cancel),
                          tooltip: "Cancella",
                          onPressed: () {
                            tec.clear();
                          }    
                        ),
                      ),
                    ),
                  ),

                  Padding(padding: EdgeInsets.all(20)),

                  SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 15,
                        bottom: 15
                      ),
                      child: Text(
                        "CODIFICA",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18
                        ),
                      ),
                      onPressed: startEncoding,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16))
                      ),
                    ),
                  ),

                  Padding(padding: EdgeInsets.only(bottom: 50))

                ],
              ),
            ),
          );
        }),
    );
  }

  startEncoding() {
    String message = "";

    List<String> messageSplit = tec.text.toUpperCase().split(" ");
    messageSplit.forEach((s) => message += s);

    String result = scramblingUnit.encoding(message);
    setState(() {
      if(result.isEmpty) codedMessageOutput = "Invalid message";
      else codedMessageOutput = result;
      for(int i = 0; i < scramblingUnit.rotorsNumber; i++) {
        key[i] = scramblingUnit.getPositionRotor(i);
      }
    });
  }

  changeKey() {
    setState(() {
      usedKey = "Key: ";
      key.forEach((key) => usedKey += key + " ");
    });
  }
}
