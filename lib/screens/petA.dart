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
  String cond ="";
  var i, j, k, l;
  //ADDED
  DatabaseReference ref = FirebaseDatabase.instance.reference();
  DatabaseReference ref2 = FirebaseDatabase.instance.reference();

  void _randtemp() {
      min = 0;
      max = 2;
      rnd = new Random();
      r = min + rnd.nextInt(max - min);

    if(r == 1) {
      min = 70;
      max = 75;
      rnd = new Random();
      r = min + rnd.nextInt(max - min);
      //changetemp = r.toString();
    }
    else {
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
      /*
      await Firestore.instance.collection('temperature').document('79wQd4mxeMego9DSEwDU').get().then((DocumentSnapshot ds)
      {
        i = ds['temp'];
      }
    );*/

    _updateData();

    await ref.child("petA/name").once().then((DataSnapshot dataSnap){
      i = dataSnap.value;
    });

    await ref.child("petA/temperature").once().then((DataSnapshot dataSnapShot){
      j = dataSnapShot.value;
    });

    await ref.child("petA/house").once().then((DataSnapshot dataSnap){
      k = dataSnap.value;
    });

    await ref.child("petA/battery").once().then((DataSnapshot dataSnap){
      l = dataSnap.value;
    });
    
    _collarstatus();
    });
  }

  void _collarstatus() {
    setState(() {
      if(j > 92) status = "on";
      else status = "off";
    });
  }

  void _updateData()
  {
    //TEMPERATURE
    _randtemp();

    // INSIDE OR OUTSIDE
    min = 0;
    max = 10;
    rnd = new Random();
    t = min + rnd.nextInt(max - min);
    if(t % 2 == 0) cond = "OUTSIDE";
    else cond = "INSIDE";
    
    // BATTERY
    min = 0;
    max = 9;
    rnd = new Random();
    b = min + rnd.nextInt(max-min);
    b = b * 12;

    ref.child("petA").update({
      'temperature': r,
      'house': cond,
      'battery': b
    });
  }

  /*
  
  
  void _deleteData()
  {
	DBRef.child("1").remove();
  }
  */
  //FLUTTER + FIREBASE - How To Add Firebase Real Time Database to Flutter (Android and iOS):
  //https://www.youtube.com/watch?v=rWXaiwN2FzE
  //Firebase Database : Creating Data in Firebase Relatime Database | CRUD | by Nitish Kumar Singh
  //https://www.youtube.com/watch?v=bBwgQ6_lfsk
  //Using Cloud Firestore as a Realtime Datastore for CRUD with Dart's Flutter Framework
  //https://www.youtube.com/watch?v=OJ_u34bD_q8

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('FluffyFinds Prototype'), centerTitle: true),
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
                  child: Text("$b%"),
                ),
                ],
            ),
          ),
        ),
        Card(
          color: Colors.lightBlueAccent[100],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          elevation: 10.0,
          child: ListTile(
            leading: Icon(Icons.map),
            title: Text('GPS'),
            onTap: () async {
              //print('Working on it...');
              /*const url = 'https://maps.google.com';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }*/
              MapUtils.openMap();
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
