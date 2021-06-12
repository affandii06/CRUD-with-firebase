import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_firebase/service/crudfirebase.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController cNama = TextEditingController();
  TextEditingController cAge = TextEditingController();
  TextEditingController cNope = TextEditingController();

  final picker = ImagePicker();
  File image;
  var pickedFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crud With Firebase', style: GoogleFonts.poppins(fontWeight: FontWeight.bold),),
      ),
      body: ListView(
        children: [
          StreamBuilder<DocumentSnapshot>(
            stream: CRUDFirebase().read(),
            builder: (context, snapshotimage){
            return Column(
              children: [
                SizedBox(height: 20,),
                (snapshotimage.data.data()['image'] != '' ) ? FutureBuilder(
                      future: CRUDFirebase().getImage(snapshotimage.data.data()['image']),
                      builder: (context, snapshotimage1) {
                        return Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(
                                      snapshotimage1.data),
                                  fit: BoxFit.cover
                              )
                          ),
                        );
                      }
                  ):Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle
                    ),
                  ),
                  SizedBox(height: 10,),
                  RaisedButton(
                    child: Text(
                      'Ganti Foto', style: GoogleFonts.poppins(
                      color: Colors.blue,),),
                    onPressed: (){
                      showBottomSheet(
                          context: context,
                          builder: (context){
                            return Container(
                                height: MediaQuery.of(context).size.height*0.3,
                                child: Center(
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                              margin: EdgeInsets.all(20),
                                              child: Text('Pilih Metode :' ,style: GoogleFonts.poppins(fontSize: 16),)
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Column(
                                                  children: [
                                                    Container(
                                                        height: 60,
                                                        width: 60,
                                                        decoration: BoxDecoration(
                                                            color: Colors.blue,
                                                            borderRadius: BorderRadius.circular(100)
                                                        ),
                                                        child: InkWell(
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(100),
                                                            child: Icon(Icons.camera_alt, color: Colors.white, size: 30,),
                                                          ),
                                                          onTap: ()async{
                                                            pickedFile = await picker.getImage(source: ImageSource.camera);
                                                            image = File(pickedFile.path);
                                                            CRUDFirebase().uploadimage(image, snapshotimage.data.data()['image']);
                                                            Navigator.pop(context);
                                                          },
                                                        )
                                                    ),
                                                    Container(
                                                        margin: EdgeInsets.all(10),
                                                        child: Text('Kamera', style: GoogleFonts.poppins(),)
                                                    )
                                                  ]
                                              ),
                                              Column(
                                                  children: [
                                                    Container(
                                                      height: 60,
                                                      width: 60,
                                                      decoration: BoxDecoration(
                                                          color: Colors.blue,
                                                          borderRadius: BorderRadius.circular(100)
                                                      ),
                                                      child: InkWell(
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(100),
                                                          child: Icon(Icons.image, color: Colors.white, size: 30,),
                                                        ),
                                                        onTap: ()async{
                                                          pickedFile = await picker.getImage(source: ImageSource.gallery);
                                                          image = File(pickedFile.path);
                                                          CRUDFirebase().uploadimage(image, snapshotimage.data.data()['image']);
                                                          Navigator.pop(context);
                                                        },
                                                      ),
                                                    ),
                                                    Container(
                                                        margin: EdgeInsets.all(10),
                                                        child: Text('Galery', style: GoogleFonts.poppins(),)
                                                    )
                                                  ]
                                              )
                                            ],
                                          )
                                        ]
                                    )
                                )
                            );
                          }
                      );
                    },
                  )
                ]
              );
            }
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: StreamBuilder<DocumentSnapshot>(
              stream: CRUDFirebase().read(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.data()['name'] != '' &&
                      snapshot.data.data()['age'] != '' &&
                      snapshot.data.data()['phone'] != '') {
                    return Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Nama  ', style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold),),
                                Text(' : '),
                                Text(snapshot.data.data()['name'],
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold),)
                              ],
                            ),

                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Usia  ', style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold),),
                                Text(' : '),
                                Text(snapshot.data.data()['age'],
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold),)
                              ],
                            ),

                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('No. HP  ', style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold),),
                                Text(' : '),
                                Text(snapshot.data.data()['phone'],
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold),)
                              ],
                            ),

                            SizedBox(height: 20,),
                            RaisedButton(
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Center(
                                    child: Text('Perbaharui Data',
                                      style: GoogleFonts.poppins(
                                          color: Colors.white),),
                                  ),
                                ),
                                color: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context){
                                      return AlertDialog(
                                        content: SingleChildScrollView(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Perbaharui Data', style: GoogleFonts.poppins(fontWeight: FontWeight.bold),),

                                              SizedBox(height: 20,),
                                              TextFormField(
                                                controller: cNama,
                                                decoration: InputDecoration(
                                                    labelText: 'Nama Lengkap',
                                                    hintText: snapshot.data.data()['name'],
                                                    border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8)
                                                    )
                                                ),
                                                style: GoogleFonts.roboto(fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),

                                              SizedBox(height: 10,),
                                              TextFormField(
                                                controller: cAge,
                                                decoration: InputDecoration(
                                                    labelText: 'Usia',
                                                    hintText: snapshot.data.data()['age'],
                                                    border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8)
                                                    )
                                                ),
                                                style: GoogleFonts.roboto(fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                                keyboardType: TextInputType.number,
                                              ),

                                              SizedBox(height: 10,),
                                              TextFormField(
                                                controller: cNope,
                                                decoration: InputDecoration(
                                                    labelText: 'No. HP',
                                                    hintText: snapshot.data.data()['phone'],
                                                    border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8)
                                                    )
                                                ),
                                                style: GoogleFonts.roboto(fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                                keyboardType: TextInputType.number,
                                              ),

                                              SizedBox(height: 20,),
                                              RaisedButton(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(15),
                                                    child: Center(
                                                      child: Text('Simpan Data',
                                                        style: GoogleFonts.poppins(
                                                            color: Colors.white),),
                                                    ),
                                                  ),
                                                  color: Colors.blue,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(15)
                                                  ),
                                                  onPressed: () {
                                                    if(cAge.text.isNotEmpty && cNama.text.isNotEmpty && cNope.text.isNotEmpty) {
                                                      CRUDFirebase().update(
                                                          cAge.text, cNama.text,
                                                          cNope.text);
                                                      cAge.clear();
                                                      cNama.clear();
                                                      cNope.clear();
                                                      Navigator.pop(context);
                                                    }
                                                  }
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  );
                                }
                            ),

                            SizedBox(height: 20,),
                            RaisedButton(
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Center(
                                    child: Text('Hapus Data',
                                      style: GoogleFonts.poppins(
                                          color: Colors.white),),
                                  ),
                                ),
                                color: Colors.red,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                onPressed: () {
                                  CRUDFirebase().delete();
                                  CRUDFirebase().deleteimage(snapshot.data.data()['image']);
                                }
                            )
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Center(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: 20,),
                              TextFormField(
                                controller: cNama,
                                decoration: InputDecoration(
                                    labelText: 'Nama Lengkap',
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8)
                                    )
                                ),
                                style: GoogleFonts.roboto(fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),

                              SizedBox(height: 10,),
                              TextFormField(
                                controller: cAge,
                                decoration: InputDecoration(
                                    labelText: 'Usia',
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8)
                                    )
                                ),
                                style: GoogleFonts.roboto(fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                keyboardType: TextInputType.number,
                              ),

                              SizedBox(height: 10,),
                              TextFormField(
                                controller: cNope,
                                decoration: InputDecoration(
                                    labelText: 'No. HP',
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8)
                                    )
                                ),
                                style: GoogleFonts.roboto(fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                keyboardType: TextInputType.number,
                              ),

                              SizedBox(height: 20,),
                              RaisedButton(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Center(
                                      child: Text('Simpan Data',
                                        style: GoogleFonts.poppins(
                                            color: Colors.white),),
                                    ),
                                  ),
                                  color: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)
                                  ),
                                  onPressed: () {
                                    CRUDFirebase().create(cAge.text, cNama.text, cNope.text, snapshot.data.data()['image']);
                                    cAge.clear();
                                    cNama.clear();
                                    cNope.clear();
                                  }
                              ),

                            ],
                          ),
                        )
                    );
                  }
                }else{
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }
            ),
          ),
        ]
      ),
    );
  }
}
