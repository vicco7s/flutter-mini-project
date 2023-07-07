import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kec_app/components/DropDownSearch/DropDownSearch.dart';
import 'package:kec_app/components/inputborder.dart';
import 'package:kec_app/util/controlleranimasiloading/CircularControlAnimasiProgress.dart';
// import 'model.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class CreateUser extends StatefulWidget {
  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  _CreateUserState();

  bool showProgress = false;
  bool visible = false;
  bool isLoading = false;

  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  final namaController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpassController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final _uid = TextEditingController();
  bool _isObscure = true;
  bool _isObscure2 = true;
  File? file;
  String _selectedValue = "";

  var options = [
    'Camat',
    'Pegawai',
    'Admin',
  ];
  var _currentItemSelected = "Pegawai";
  var rool = "Pegawai";


 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Tambah Pengguna'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 0.0,
                            right: 0.0,
                            left: 0.0,
                          ),
                          child: Container(
                              child: FutureBuilder(
                                  future: firestore.collection("pegawai").get(),
                                  builder: ((context, snapshot) {
                                    if (snapshot.hasData) {
                                      QuerySnapshot querySnapshot =
                                          snapshot.data as QuerySnapshot;
                                      List<DocumentSnapshot> items =
                                          querySnapshot.docs;
                                      List<String> namaList = items
                                          .map((item) => item['nama'] as String)
                                          .toList();
                                      return Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 10.0,
                                              right: 10.0,
                                              left: 10.0,
                                            ),
                                            child: DropdownButtonSearch(
                                              itemes: namaList,
                                              textDropdownPorps: "Nama Pegawai",
                                              hintTextProps: "Search Nama...",
                                              onChage: (value) {
                                                setState(() {
                                                  _selectedValue = value!;
                                                  getUidPegawai(value)
                                                      .then((result) {
                                                    setState(() {
                                                      _uid.text = result['uid']!;
                                                    });
                                                  });
                                                });
                                              },
                                              // validators: (value) => (value ==
                                              //         null
                                              //     ? 'Nama tidak boleh kosong!'
                                              //     : null),
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return ColorfulCirclePrgressIndicator();
                                    }
                                  }))),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10.0,
                            right: 10.0,
                            left: 10.0,
                          ),
                          child: TextFormFields(
                            controllers: emailController,
                            labelTexts: 'Email',
                            keyboardtypes: TextInputType.emailAddress,
                            validators: (value) {
                              if (value!.length == 0) {
                                return "Email tidak boleh kosong";
                              }
                              if (!RegExp(
                                      "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                  .hasMatch(value)) {
                                return ("Mohon masukan email dengan benar !");
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10.0,
                            right: 10.0,
                            left: 10.0,
                          ),
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: _isObscure,
                            validator: (value) {
                              RegExp regex = RegExp(r'^.{6,}$');
                              if (value!.isEmpty) {
                                return "Password tidak boleh kosong !";
                              }
                              if (!regex.hasMatch(value)) {
                                return ("Masukan dengan benar dan min 6 karakter! ");
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              // hintText: "Masukan Email",
                              fillColor: Colors.white70,
                              labelText: "Password",
                              suffixIcon: IconButton(
                                  icon: Icon(_isObscure
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    });
                                  }),
                              enabled: true,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10.0,
                            right: 10.0,
                            left: 10.0,
                          ),
                          child: TextFormField(
                            obscureText: _isObscure2,
                            controller: confirmpassController,
                            validator: (value) {
                              if (confirmpassController.text !=
                                  passwordController.text) {
                                return "Password tidak Cocok !";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              // hintText: "Masukan Email",
                              fillColor: Colors.white70,
                              labelText: "Konfirmasi Password",
                              suffixIcon: IconButton(
                                  icon: Icon(_isObscure2
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      _isObscure2 = !_isObscure2;
                                    });
                                  }),
                              enabled: true,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10.0,
                            right: 10.0,
                            left: 10.0,
                          ),
                          child: DropdownButtonFormField<String>(
                            dropdownColor: Colors.white,
                            isExpanded: true,
                            iconEnabledColor: Colors.black,
                            focusColor: Colors.black,
                            items: options.map((String dropDownStringItem) {
                              return DropdownMenuItem<String>(
                                value: dropDownStringItem,
                                child: Text(
                                  dropDownStringItem,
                                ),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              // hintText: "Masukan Email",
                              fillColor: Colors.white70,
                              labelText: "Role",
                            ),
                            onChanged: (newValueSelected) {
                              setState(() {
                                _currentItemSelected = newValueSelected!;
                                rool = newValueSelected;
                              });
                            },
                            value: _currentItemSelected,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              elevation: 5.0,
                              height: 40,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Kembali",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              color: Colors.blueAccent,
                            ),
                            MaterialButton(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              elevation: 5.0,
                              height: 40,
                              onPressed: () {
                                setState(() {
                                  isLoading = true;
                                });
                                if (_formkey.currentState!.validate()) {
                                  signUp(emailController.text,
                                      passwordController.text, rool);
                                }
                              },
                              color: Colors.blueAccent,
                              child: Text(
                                "Buat Akun",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void signUp(String email, String password, String rool) async {
    // ignore: prefer_const_constructors
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ));
    try {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    CollectionReference usersRef = firebaseFirestore.collection('users');

    // Memulai transaksi
    await firebaseFirestore.runTransaction((transaction) async {
      // Memeriksa apakah UID sudah ada dalam koleksi "users"
      bool isUidExists = await checkUidExists(usersRef, _uid.text);

      if (isUidExists) {
        // Jika UID sudah ada, batalkan transaksi dan tampilkan pesan kesalahan
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Pegawai sudah memiliki Akun'),
          ),
        );
        Navigator.pop(context);
        return;
      } else if(rool == 'Pegawai') {
        if (_selectedValue.isEmpty) {
          // Jika role adalah "Pegawai" dan nama kosong, tampilkan pesan kesalahan
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text('Nama tidak boleh kosong untuk role Pegawai'),
            ),
          );
          Navigator.pop(context);
          return;
        }
        UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String userUID = authResult.user!.uid;

        DocumentReference userDocRef = usersRef.doc(userUID);

        transaction.set(userDocRef, {
          'nama': _selectedValue,
          'email': emailController.text,
          'role': rool,
          'uid': userUID,
        });

      // Update UID pengguna di dokumen "users"
      transaction.update(userDocRef, {
        'uid': _uid.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text('Email Berhasil Dibuat'),
          ),
        );

        Navigator.pop(context);
        Navigator.pop(context);

      }else{
           UserCredential authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      var user = _auth.currentUser;

      usersRef.doc(user!.uid).set({
        'email': emailController.text,
        'role': rool,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text('Email Berhasil Dibuat'),
        ),
      );

      Navigator.pop(context);
      Navigator.pop(context);
      }
    });
      
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Email sudah digunakan'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Terjadi kesalahan saat membuat akun'),
          ),
        );
      }
      Navigator.pop(context);
    }
  }
}

Future<bool> checkUidExists(CollectionReference usersRef, String uid) async {
  QuerySnapshot snapshot = await usersRef.where('uid', isEqualTo: uid).get();
  return snapshot.docs.isNotEmpty;
}

Future<Map<String, String>> getUidPegawai(String value) async {
  QuerySnapshot querySnapshot = await firestore
      .collection('pegawai')
      .where('nama', isEqualTo: value)
      .get();
  if (querySnapshot.docs.isNotEmpty) {
    String uid = querySnapshot.docs[0]['uid'];
    return {
      'uid': uid,
    };
  } else {
    return {'uid': 'uid tidak ditemukan'};
  }
}
