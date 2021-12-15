import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:math';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:passworld/components/rounded_button.dart';
import 'package:passworld/components/textfield_container.dart';

final FirebaseFirestore fireStore = FirebaseFirestore.instance;
final CollectionReference mainCollection = fireStore.collection('users');
final randomizer = new Random();

class AddPassword extends StatefulWidget {
  @override
  _AddPasswordState createState() => _AddPasswordState();
}

class _AddPasswordState extends State<AddPassword> {
  String service, password, about;

  getEncryptedValue(value, add) {
    final key = encrypt.Key.fromUtf8(
        dotenv.get('PRIVATE_KEY').substring(0, 15) + add.toString());
    final iv = encrypt.IV
        .fromUtf8(dotenv.get('PRIVATE_IV').substring(0, 15) + add.toString());
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(value, iv: iv);
    return encrypted.base64;
  }

  Future<bool> addService() async {
    if (service == "" || password == "") {
      return false;
    }
    int colVAL = randomizer.nextInt(10);
    Map<String, dynamic> data = {
      'service': getEncryptedValue(service, colVAL),
      'delight': getEncryptedValue(password, colVAL),
      'about': getEncryptedValue(about, colVAL) ?? "",
      'image': randomizer.nextInt(10),
      'color': colVAL
    };
    DocumentReference documentReference = mainCollection
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('passworlds')
        .doc(Uuid().v4());
    await documentReference
        .set(data)
        .whenComplete(() => print("object stored!"))
        .catchError((e) {
      return false;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Container(
        margin: EdgeInsets.only(top: 25.0),
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Align(
              alignment: Alignment.topLeft,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back,
                    color: Colors.black, size: size.width * 0.15),
              ),
            ),
            SizedBox(height: 5.0),
            Container(
              width: size.width * 0.9,
              child: Text("Add Password.",
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 70.0,
                      fontFamily: 'Quicksand-semibild'),
                  textAlign: TextAlign.left),
            ),
            SizedBox(height: 70.0),
            TextFieldContainer(
                text: 'Enter service',
                icon: Icon(Icons.miscellaneous_services),
                function: (value) {
                  service = value;
                },
                isObscure: false),
            SizedBox(height: 20),
            TextFieldContainer(
                text: 'Enter password',
                icon: Icon(Icons.lock),
                function: (value) {
                  password = value;
                },
                isObscure: true),
            SizedBox(height: 20),
            TextFieldContainer(
                text: 'Enter description(optional)',
                icon: Icon(Icons.info),
                function: (value) {
                  about = value;
                },
                isObscure: false),
            SizedBox(height: 20),
            RoundedButton(
                text: 'Done',
                primaryColor: Colors.purple,
                textColor: Colors.white,
                function: () async {
                  final status = await addService();
                  if (status) {
                    Navigator.pop(context);
                  }
                })
          ]),
        ),
      ),
    );
  }
}
