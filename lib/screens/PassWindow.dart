import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:passworld/screens/AddPassword.dart';

final FirebaseFirestore fireStore = FirebaseFirestore.instance;

class PassWindow extends StatefulWidget {
  @override
  _PassWindowState createState() => _PassWindowState();
}

class _PassWindowState extends State<PassWindow> {
  String searchField = "";
  final colors = [
    LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [Color(0xFFFF5F6D), Color(0XFFFFC371)]),
    LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [Color(0xFF16BFFD), Color(0XFFCB3066)]),
    LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [Color(0xFF0099F7), Color(0XFFF11712)]),
    LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [Color(0xFFC02425), Color(0XFFF0CB35)]),
    LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [Color(0xFF8E0E00), Color(0XFF1F1C18)]),
    LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [Color(0xFF673AB7), Color(0XFF512DA8)]),
    LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [Color(0xFF005C97), Color(0XFF363795)]),
    LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [Color(0xFFe53935), Color(0XFFe35d5b)]),
    LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [Color(0xFFfc00ff), Color(0XFF00dbde)]),
    LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [Color(0xFF7b4397), Color(0XFFdc2430)]),
  ];
  final images = [
    Image.asset('assets/images/octocat.png'),
    Image.asset('assets/images/fb.png'),
    Image.asset('assets/images/google.png')
  ];
  String getDecryptedData(value, add) {
    try {
      final key = encrypt.Key.fromUtf8(
          dotenv.get('PRIVATE_KEY').substring(0, 15) + add.toString());
      final iv = encrypt.IV
          .fromUtf8(dotenv.get('PRIVATE_IV').substring(0, 15) + add.toString());
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final decrypted =
          encrypter.decrypt(encrypt.Encrypted.from64(value), iv: iv);
      return decrypted;
    } catch (e) {
      return "Corrupted Data";
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddPassword()));
        },
        child: Icon(Icons.add),
      ),
      body: Container(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser.uid)
                  .collection('passworlds')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return EmptyData(size: size);
                }
                final _masterData = snapshot.data.docs;
                List _results = [];
                if (searchField != "") {
                  for (final value in _masterData) {
                    if (getDecryptedData(value['service'], value['color'])
                        .toLowerCase()
                        .contains(searchField.toLowerCase())) {
                      _results.add(value);
                    }
                  }
                } else {
                  _results = _masterData;
                }
                return Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 30.0),
                        Container(
                            child: Text(
                          "Browse & Pick.",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 42.0,
                              fontFamily: 'Quicksand-semibold'),
                          textAlign: TextAlign.center,
                        )),
                        SizedBox(height: 30.0),
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.grey[200]),
                            width: size.width * 0.85,
                            margin: EdgeInsets.symmetric(vertical: 6),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  searchField = value.trim();
                                });
                              },
                              obscureText: false,
                              decoration: InputDecoration(
                                  icon: Icon(Icons.search),
                                  hintText: 'Search passwords',
                                  border: InputBorder.none),
                            )),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _results.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: EdgeInsets.only(
                                    top: 4.0,
                                    bottom: 4.0,
                                    left: 8.0,
                                    right: 8.0),
                                child: Column(
                                  children: [
                                    Card(
                                        child: Container(
                                      decoration: BoxDecoration(
                                          gradient:
                                              colors[_results[index]['color']],
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.yellow,
                                                spreadRadius: 3),
                                          ]),
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                              leading: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.0),
                                                child: images[0],
                                              ),
                                              title: Text(
                                                  getDecryptedData(
                                                      _results[index]
                                                          ['service'],
                                                      _results[index]
                                                              ['color'] ??
                                                          0),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 30.0,
                                                      fontFamily: 'Roboto')),
                                              subtitle: Text(
                                                  getDecryptedData(
                                                      _results[index]['about'],
                                                      _results[index]
                                                              ['color'] ??
                                                          0),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 17.0))),
                                          SizedBox(height: 20.0),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                TextButton(
                                                    onPressed: () {
                                                      final text =
                                                          getDecryptedData(
                                                              _results[index]
                                                                  ['delight'],
                                                              _results[index][
                                                                      'color'] ??
                                                                  0);
                                                      Clipboard.setData(
                                                              ClipboardData(
                                                                  text: text))
                                                          .then((_) => ScaffoldMessenger
                                                                  .of(context)
                                                              .showSnackBar(SnackBar(
                                                                  content: Text(
                                                                      "Copied to clipboard 📝"))));
                                                    },
                                                    child: Text("Copy",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white))),
                                                TextButton(
                                                    onPressed: () {},
                                                    child: Text("Modify",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)))
                                              ])
                                        ],
                                      ),
                                    )),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      ]),
                );
              })),
    );
  }
}

class EmptyData extends StatelessWidget {
  const EmptyData({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      child: Column(children: [
        SizedBox(height: 10.0),
        Container(
            margin: EdgeInsets.only(top: 45.0),
            width: size.width * 1,
            child: Text("EMPTY!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 55,
                    fontFamily: 'Quicksand-semibold',
                    fontWeight: FontWeight.w900))),
        SizedBox(height: 10.0),
        Container(
            margin: EdgeInsets.only(top: 20.0),
            child: Text(
                "Just press '+' button and get started with adding a password.",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center)),
        SizedBox(height: 40.0),
        Image.asset('assets/images/empty.jpg')
      ]),
    );
  }
}
