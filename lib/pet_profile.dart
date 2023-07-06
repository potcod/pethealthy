import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pet_healthy_proj/pet_feeding.dart';
import 'package:pet_healthy_proj/pet_editor.dart';
import 'package:pet_healthy_proj/pet_weight.dart';


class PetProfile extends StatefulWidget {

  //const PetProfile({super.key});
  var petDetails;
  var petID;
  PetProfile({this.petDetails, this.petID});
  final title = 'Profile';

  @override
  State<PetProfile> createState() => _PetProfileState();

}
class _PetProfileState extends State<PetProfile> {

  _PetProfileState(){
    FirebaseDatabase.instance.ref().child("pets").onChildChanged.listen((event) {
      print("Data Changed");



    });
  }
  TextEditingController _newWeightController = TextEditingController();

  get petID => petID;
  var petDetails = [];
  var name;

  void _goPetWeight(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PetWeight(petID: widget.petID))
    );
  }
  void _goPetFeeding(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PetFeeding(petID: widget.petID))
    );
  }
  void _goPetEdit(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PetEdit(petID: widget.petID))
    );
  }
  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Weight Updated!'),

      ),
    );
  }
  void clearText() {
    _newWeightController.clear();
  }
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  void updateInfo() {
    FirebaseFirestore.instance.collection("pets").doc(widget.petID).snapshots().listen((DocumentSnapshot snapshot) {

      widget.petDetails['weight'] = _newWeightController.text;

      setState(() {

      });
    });
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),


      ),
      body: Column(
        children: [

            Expanded(
              flex: 45,
              child: Container(
                margin: EdgeInsets.all(15),
                child: Image(
                  fit: BoxFit.fill,
                  image: NetworkImage("${widget.petDetails['image']}"),
                ),
              ),
            ),

          Expanded(

            flex: 10,
            child: Row(
              children: [

                Container(
                  margin: EdgeInsets.all(10),
                    child: Expanded(child: Text("${widget.petDetails['name']}", style: TextStyle(fontSize: 20), ))
                ),

                Spacer(),

                Container(
                  margin: EdgeInsets.all(10),
                    child: Text("Age: ${widget.petDetails['age']}", style: TextStyle(fontSize: 20),))
                ,
              ],
            )
            ,
          ),
          
          Expanded(
            flex: 10,
              child: Text("Current Weight: ${widget.petDetails['weight']}", style: TextStyle(fontSize: 25)),

          ),

          Expanded(
            flex: 5,

            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 50, right: 50),
                    child: TextField(
                      controller: _newWeightController,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText:'Enter New Weight',


                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: (){
                    FirebaseFirestore.instance.collection('pets').doc('${widget.petID}').update(
                        {
                          "weight" : double.parse(_newWeightController.text),
                        }
                    );

                    FirebaseFirestore.instance.collection('pets').doc('${widget.petID}').collection('weightData').add(
                      {
                        "weight": double.parse(_newWeightController.text),
                      }
                    ).then((value) {
                        print("Successfully added weight instance");

                        setState(() {});
                        _showToast(context);
                        clearText();


                      }).catchError((error) {
                        print("Failed to add weight");
                        print(error);
                      });
                    updateInfo();

                  },
                  icon: Icon(Icons.check),

                ),

              ],
            ),
          ),


          Expanded(
            flex: 8,
            child: ElevatedButton(
              onPressed: _goPetWeight,
              child: Text("Weight Insights"),
              
            ),
          ),

          Expanded(
            flex: 8,
            child: ElevatedButton(
              onPressed: _goPetFeeding,
              child: Text("Feeding Insights"),

            ),
          ),
          IconButton(onPressed: _goPetEdit, icon: Icon(Icons.edit))

          

        ],
      ),
    );
  }
}
