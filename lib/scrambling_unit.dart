
class _Rotor {

  List<int> charListDiso;
  List<int> charList = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".runes.toList();

  List<int> initCharList;
  List<int> initCharListDiso;

  int revCounter = 0;

  _Rotor(List<int> charListDiso) {
    this.charListDiso = charListDiso;
    this.initCharListDiso = List.from(charListDiso);
    this.initCharList = List.from(charList);
  }

  rotate(int lapsNumber) {
    if(lapsNumber > 0) {
      var firstCharList, firstCharListDiso;

      for(int j = 0; j < lapsNumber; j++) {
        firstCharList = charList.elementAt(0);
        firstCharListDiso = charListDiso.elementAt(0);

        for(int i = 0; i < 25; i++) {
            charList[i] = charList.elementAt(i + 1);
            charListDiso[i] = charListDiso.elementAt(i + 1);
        }

        charList[charList.length - 1] = firstCharList;
        charListDiso[charListDiso.length - 1] = firstCharListDiso;

        revCounter++;
      }
    }
  }

  bool completeTurn() {
    return revCounter == 26;
  }

  int switchCharCode(int cell, bool forwardingCoding) {
    if(forwardingCoding) return charList.indexOf(charListDiso.elementAt(cell));
    else return charListDiso.indexOf(charList.elementAt(cell));
  }

  setPosition(String initPosition) {
    int initCell = charList.indexOf(initPosition.codeUnitAt(0));

    rotate(initCell);

    initCharList = List.from(charList);
    initCharListDiso = List.from(charListDiso);
  }
}

class Pair {
  
  int source;
  int reflex;

  Pair(String source, String reflex) {
    this.source = source.codeUnitAt(0);
    this.reflex = reflex.codeUnitAt(0);
  }
}

class _Reflector {

  List<int> charList;
  List<Pair> pairs = [
    new Pair("G", "R"),
    new Pair("M", "K"),
    new Pair("O", "T"),
    new Pair("F", "I"),
    new Pair("P", "W"),
    new Pair("N", "J"),
    new Pair("A", "L"),
    new Pair("X", "E"),
    new Pair("Z", "B"),
    new Pair("Y", "D"),
    new Pair("H", "U"),
    new Pair("C", "Q"),
    new Pair("V", "S")
  ];

  _Reflector(List<int> charList) {
    this.charList = charList;
  }

  int reflexCellOf(int charCode) {
    for(Pair pair in pairs) {
      if(pair.source == charCode) 
        return charList.indexOf(pair.reflex);
      else if(pair.reflex == charCode)
        return charList.indexOf(pair.source);
    }
    return -1;
  }
}

class _RotorsManager {

  List<_Rotor> rotors;

  _RotorsManager(List<_Rotor> rotors) {
    this.rotors = rotors;
  }

  turnsRotors() {
    rotors.elementAt(0).rotate(1);

    for(int i = 1; i < rotors.length - 1; i++) {
      if(rotors.elementAt(i - 1).completeTurn()) {
        rotors.elementAt(i).rotate(1);
        rotors.elementAt(i - 1).revCounter = 0;
      }
    }

    if(rotors.elementAt(rotors.length - 2).completeTurn()) {
      rotors.elementAt(rotors.length - 1).rotate(1);
      rotors.elementAt(rotors.length - 2).revCounter = 0;
      if(rotors.elementAt(rotors.length - 1).completeTurn())
        rotors.elementAt(rotors.length - 1).revCounter = 0;
    }
  }

  void resetRotors(List<String> beforeCoding) {
    for(int i = 0; i < rotors.length; i++) {
      rotors.elementAt(i).setPosition(beforeCoding.elementAt(i));
      if(rotors.elementAt(i).revCounter != 0) 
        rotors.elementAt(i).revCounter = 0;
    }
  }
}

class ScramblingUnit {

  int rotorsNumber;

  _Reflector _reflector;
  _RotorsManager _rotorsManager;
  List<int> _plugboard = "PRODBEVCGKILHTUMQYSXJAZWFN".runes.toList();
  List<int> _entryRotor = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".runes.toList();

  ScramblingUnit(List<String> charListRot, String charListRefl) {
    this._reflector = new _Reflector(charListRefl.runes.toList());
    this._rotorsManager = new _RotorsManager(
      new List<_Rotor>.generate(
        charListRot.length, 
        (index) => new _Rotor(charListRot.elementAt(index).runes.toList())
      )
    );
    this.rotorsNumber = _rotorsManager.rotors.length;
  }

  String encoding(String message) {
    if(message.isEmpty) return "";

    int spacingCounter = 0;
    String codedMess = "";
    List<String> beforeCoding = new List<String>.generate(
      rotorsNumber,
      (index) => String.fromCharCode(
        _rotorsManager.rotors.elementAt(index).charList.elementAt(0)
      )
    );
    
    for(int charCode in message.runes.toList()) {
      int cell = _entryRotor.indexOf(charCode);
      if(cell != -1) {
        int codedCharCode = _letterPath(cell);
        codedMess += String.fromCharCode(codedCharCode);
        spacingCounter++;
        if(spacingCounter == 5) {
          codedMess += "  ";
          spacingCounter = 0;
        }
      } else {
        _rotorsManager.resetRotors(beforeCoding);
        return "";
      }
    }
    
    return codedMess;
  }

  int _letterPath(int cell) {
    cell = _entryRotor.indexOf(_plugboard.elementAt(cell));

    for(_Rotor rotor in _rotorsManager.rotors) {
      cell = rotor.switchCharCode(cell, true);
    }

    cell = _reflector.reflexCellOf(_reflector.charList.elementAt(cell));

    for(_Rotor rotor in _rotorsManager.rotors.reversed) {
      cell = rotor.switchCharCode(cell, false);
    }

    _rotorsManager.turnsRotors();

    return _entryRotor.elementAt(
      _plugboard.indexOf(_entryRotor.elementAt(cell))
    );
  }

  void setKey(List<String> key) {
    for(int i = 0; i < key.length; i++) {
      _rotorsManager.rotors.elementAt(i).setPosition(key.elementAt(i));
    }
  }

  void setPositionRotor(int index, String position) {
    _rotorsManager.rotors.elementAt(index).setPosition(position);
  }

  void resetRevCounter() {
    for(int i = 0; i < _rotorsManager.rotors.length; i++) {
      if(_rotorsManager.rotors.elementAt(i).revCounter != 0) 
        _rotorsManager.rotors.elementAt(i).revCounter = 0;
    }
  }

  String getPositionRotor(int index) {
    return String.fromCharCode(_rotorsManager.rotors.elementAt(index).charList.elementAt(0));
  }
}