
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restart_app/restart_app.dart';

import 'main.dart';

class PetCreate extends StatefulWidget {
  const PetCreate({super.key});

  String get title => 'Create Profile';

  @override
  State<PetCreate> createState() => _PetCreateState();
}

class _PetCreateState extends State<PetCreate> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _goalController = TextEditingController();
  var finImg;
  bool _validate = false;
  bool _ivalidate = false;

void clearText(){
  _nameController.clear();
  _ageController.clear();
  _weightController.clear();
  _goalController.clear();
}


File? image;
Future _getFromGallery() async {
  final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (image == null) return;

  final imageTemp = File(image.path);
  setState(() => this.image = imageTemp);
  print("Image=" + image.toString());

  File temp = File(image.path);
  print("Temp =" + temp.toString());
  _ivalidate = true;

  uploadToFBS(temp);

  }
  _getFromCamera() async {
    // final image = await ImagePicker().pickImage(source: ImageSource.camera);
    // if (image == null) return;
    //
    // final imageTemp = File(image.path);
    // setState(() => this.image = imageTemp);
    // print("Image=" + image.toString());
    // uploadToFBS(imageTemp);
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;

    final imageTemp = File(image.path);
    setState(() => this.image = imageTemp);
    print("Image=" + image.toString());

    File temp = File(image.path);
    print("Temp =" + temp.toString());
    _ivalidate = true;

    uploadToFBS(temp);

  }

  void uploadToFBS(File file){
  var fileName = DateTime.now().millisecondsSinceEpoch.toString() + "jpg";
  FirebaseStorage.instance.ref().child("cs4750/" + fileName).putFile(file)
  .then((res){
    print("Successfully uploaded photo");
    res.ref.getDownloadURL().then((value){
      print("VALUE:" + value);
      finImg = value;
    }).catchError((error){
      print("Failed to get download url");
    });
  }).catchError((error){
    print("Failed to upload photo");
  });

  } //uploadToFBS
  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Pet Successfully Added!'),
        
      ),
    );
  }
  void _showImageToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Image Successfully Chosen!'),

      ),
    );
  }
  void _goMain(){

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MyHomePage(title: '',),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    print("Image TO SEND:" + image.toString());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),

      ),

      body: Column(
        children: [

          Expanded(
            flex: 35,
            child: ElevatedButton(
              onPressed: (){
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: new Icon(Icons.photo),
                            title: new Text('Photo'),
                            onTap: () {
                              _getFromGallery();
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: new Icon(Icons.camera_alt_outlined),
                            title: new Text('Camera'),
                            onTap: () {
                              _getFromCamera();
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });



              },
              child: Text("Pick an Image"),
            ),
          ),
          


          Expanded(
            flex: 10,
            child: Container(
              margin: EdgeInsets.all(12),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText:'Name',


                ),
              ),
            ),
          ),

          Expanded(
            flex: 10,
            child: Container(
              margin: EdgeInsets.all(12),
              child: TextField(
                controller: _ageController,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText:'Age',


                ),
              ),
            ),
          ),

          Expanded(
            flex: 10,
            child: Container(
              margin: EdgeInsets.all(12),
              child: TextField(
                controller: _weightController,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText:'Weight',


                ),
              ),
            ),
          ),

          Expanded(
            flex: 10,
            child: Container(
              margin: EdgeInsets.all(12),
              child: TextField(
                controller: _goalController,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText:'Weight Goal',


                ),
              ),
            ),
          ),
          
          Expanded(
            flex: 15,
            child: ElevatedButton(
              onPressed: (){
                setState(() {
                  _nameController.text.isEmpty ? _validate = false : _validate = true;
                  _weightController.text.isEmpty ? _validate = false : _validate = true;
                  _ageController.text.isEmpty ? _validate = false : _validate = true;
                  _goalController.text.isEmpty ? _validate = false : _validate = true;

                });
                print("Name:" + _nameController.toString() + "END");

                print("Validate = " + _validate.toString());
                print("iValidate = " + _validate.toString());
                if(_validate == false || _ivalidate == false){
                  Widget okButton = TextButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop('alert');
                    },
                    );

                    // set up the AlertDialog
                    AlertDialog alert = AlertDialog(
                      title: Text("Error"),
                      content: Text("Please enter for all fields."),
                      actions: [
                        okButton,
                      ],
                    );

                    // show the dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      },
                    );
                }

                else if(_validate == true && _ivalidate == true){
                  FirebaseFirestore.instance.collection("pets").add(
                      {
                        "name": _nameController.text,
                        "age": int.parse(_ageController.text),
                        "weight": double.parse(_weightController.text),
                        "goal": double.parse(_goalController.text),
                        "image": finImg,
                      }
                  ).then((DocumentReference doc) {
                    print("Successfully added pet");
                    print("Doc ID: ${doc.id}");
                    FirebaseFirestore.instance.collection("pets").doc("${doc.id}").collection("weightData").add(
                      {
                      }
                    );
                    FirebaseFirestore.instance.collection("pets").doc("${doc.id}").collection("feedTimes").add(
                        {
                        }
                    );
                    _showToast(context);
                    clearText();
                    _goMain();

                  }).catchError((error) {
                    print("Failed to add pet");
                    print(error);
                  });

                }
              },

              child: Text('Add Pet'),
            ),
          ),




        ],
      ),
    );

  }
}
