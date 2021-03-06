part of 'front.dart';

class _PetA extends StatefulWidget {
  _PetA({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _PetAPage createState() => _PetAPage();
}

class _PetAPage extends State<_PetA> {
  int s = 0;
  int min, max, r, t, b;
  Random rnd;
  String changetemp = "";
  String status = "off";
  String cond = "";
  String newName = "";
  var i, j, k, l, m, n;
  DatabaseReference ref = FirebaseDatabase.instance.reference();
  DatabaseReference ref2 = FirebaseDatabase.instance.reference();

  void _randtemp() {
    min = 0;
    max = 2;
    rnd = new Random();
    r = min + rnd.nextInt(max - min);

    if (r == 1) {
      min = 70;
      max = 75;
      rnd = new Random();
      r = min + rnd.nextInt(max - min);
      //changetemp = r.toString();
    } else {
      min = 93;
      max = 98;
      rnd = new Random();
      r = min + rnd.nextInt(max - min);
    }
  }

  @override
  void initState() {
    _getThingsOnStartup();
    super.initState();
  }

  Future _getThingsOnStartup() async {
    _changeInfo();
  }

  void _changeInfo() {
    setState(() async {
      await ref.child("petA/name").once().then((DataSnapshot dataSnap) {
        i = dataSnap.value;
      });

      await ref.child("petA/temperature").once().then((DataSnapshot dataSnap) {
        j = dataSnap.value;
      });

      await ref.child("petA/house").once().then((DataSnapshot dataSnap) {
        k = dataSnap.value;
      });

      await ref.child("petA/battery").once().then((DataSnapshot dataSnap) {
        l = dataSnap.value;
      });

      await ref.child("petA/latitude").once().then((DataSnapshot dataSnap) {
        m = dataSnap.value;
      });

      await ref.child("petA/longitude").once().then((DataSnapshot dataSnap) {
        n = dataSnap.value;
      });

      _collarstatus();
    });
  }

  void _collarstatus() {
    setState(() {
      if (j > 92)
        status = "on";
      else
        status = "off";
    });
  }

  void _updateName(String name) {
    ref.child("petA").update({'name': name});
    _changeInfo();
  }

  void findLocation() async {
    //Future.delayed(const Duration(milliseconds: 2000));
    //_changeInfo();
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=' +
        m.toString() +
        ',' +
        n.toString();
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open map';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(i.toString()), centerTitle: true),
      body: Card(
        elevation: 10.0,
        child: ListView(
          children: <Widget>[
            Container(
              height: 50.0,
              width: 50.0,
              child: FittedBox(
                child: Row(
                  children: [
                    RaisedButton(
                      color: Colors.lightGreenAccent[100],
                      onPressed: () {
                        _changeInfo();
                      },
                      child: Text('Update Info'),
                    ),
                    RaisedButton(
                      color: Colors.lightGreenAccent[100],
                      onPressed: () {
                        return showDialog<String>(
                          context: context,
                          barrierDismissible:
                              true, // dialog is dismissible with a tap on the barrier
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Edit Pet Name'),
                              content: new Row(
                                children: <Widget>[
                                  new Expanded(
                                      child: new TextField(
                                    autofocus: true,
                                    decoration: new InputDecoration(
                                        labelText: 'Enter Pet Name:',
                                        hintText: 'Enter Name Here!'),
                                    onChanged: (value) {
                                      newName = value;
                                    },
                                  ))
                                ],
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                FlatButton(
                                  child: Text('Ok'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _updateName(newName);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text('Edit Name'),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 10.0,
              child: ListTile(
                leading: Icon(Icons.local_pizza),
                title: Row(
                  children: [
                    Expanded(
                      child: Text("Name"),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xffddddff),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: Text(i.toString()),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 10.0,
              child: ListTile(
                leading: Icon(Icons.wb_sunny),
                title: Row(
                  children: [
                    Expanded(
                      child: Text("Temperature"),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xffddddff),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: Text(j.toString()),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 10.0,
              child: ListTile(
                leading: Icon(Icons.pets),
                title: Row(
                  children: [
                    Expanded(
                      child: Text("Collar Status"),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xffddddff),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: Text(status),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 10.0,
              child: ListTile(
                leading: Icon(Icons.home),
                title: Row(
                  children: [
                    Expanded(
                      child: Text("Inside the House?"),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xffddddff),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: Text(k.toString()),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              borderOnForeground: false,
              elevation: 10.0,
              child: ListTile(
                leading: Icon(Icons.battery_charging_full),
                title: Row(
                  children: [
                    Expanded(
                      child: Text("Check Collar Battery"),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xffddddff),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: Text(l.toString()+'%'),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              color: Colors.lightBlueAccent[100],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)),
              elevation: 10.0,
              child: ListTile(
                leading: Icon(Icons.map),
                title: Text('Get Location'),
                onTap: () async {
                  findLocation();
                  final snackBar = SnackBar(content: Text("Working on it..."));
                  Scaffold.of(context).showSnackBar(snackBar);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
