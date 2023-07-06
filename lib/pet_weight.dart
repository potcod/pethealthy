import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_healthy_proj/lineChart.dart';
import 'package:pet_healthy_proj/weightData.dart';
import 'package:collection/collection.dart';

class PetWeight extends StatefulWidget {
  //const PetWeight({super.key});
  var petID;
  PetWeight({this.petID});

  String title = "Weight Insights";

  @override
  State<PetWeight> createState() => _PetWeightState();
}

//List<WeightData> get weightDataForList{
  //final wdata = <double>[];
  //
  // Future<void> getWeightData() async {
  //   //Get data and use it for weight graph
  //   await FirebaseFirestore.instance.collection("pets").doc("GWOt6I3jMBKqCkXTGe1v").collection("weightData").get()
  //       .then((querySnapshot){
  //     print("Successfully loaded weightData collection");
  //     querySnapshot.docs.forEach((element) {
  //
  //       wdata.add(element.data()['weight']);
  //       print("Document data:" + element.data()['weight'].toString());
  //     });
  //
  //   }).catchError((error){
  //     print("Failed to load weight graph data");
  //     print("Error:" + error);
  //   });
  // } //getWeightData


  //getWeightData();

  //print("LENGTH OF WDATA:${wdata.length}");

//   return wdata
//       .mapIndexed(
//           (index, element) => WeightData(x: index.toDouble(), y: element))
//       .toList();
//
// }

class _PetWeightState extends State<PetWeight> {
  var weightList = [];
  var currentWeight, goal, difference, name;
  void _getWeightData() async{
    await FirebaseFirestore.instance.collection("pets").doc("${widget.petID}").collection("weightData").get()
        .then((QuerySnapshot querySnapshot){

      querySnapshot.docs.forEach((QueryDocumentSnapshot document) {
        weightList.add(document.data());

      });

    }).catchError((error){
      print("Failed to load weight list");
      print("Error:" + error);
    });

  } //getWeightData

  Future<void> _getWeightDifference() async{
    await FirebaseFirestore.instance.collection("pets").doc("${widget.petID}").get()
        .then((value){

          currentWeight = value.data()?['weight'];
          name = value.data()?['name'];
          goal =  value.data()?['goal'];
          print("Name is" + name.toString());

          difference = currentWeight-goal;

    });

  } //getWeightDifference
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_getWeightData();
    _getWeightDifference();

  }


  @override

  Widget build(BuildContext context) {
    // _getWeightData();
    // _getWeightDifference();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 50,
            child: content(),
          ),


          Expanded(
            flex: 25,
              child: Text(name.toString() + " is " + difference.toString() + "lbs away from their goal!", style: TextStyle(fontSize: 17),)
          ),

          Expanded(
            flex: 25,
              child: Text("Weight Goal:" + goal.toString(), style: TextStyle(fontSize: 20, ),)
          ),

          //Text("W List is" + weightList.length.toString()),


        ],
      ),
    );
  }
  Widget content(){
    return Container(
      child: LineChartWidget(weightDataForList),

    );
  }

}
