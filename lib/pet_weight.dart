import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_healthy_proj/lineChart.dart';
import 'package:pet_healthy_proj/weightData.dart';


class PetWeight extends StatefulWidget {
  //const PetWeight({super.key});
  var petID;
  PetWeight({this.petID});
  String title = "Weight Insights";

  @override
  State<PetWeight> createState() => _PetWeightState();
}

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

  void _getWeightDifference() async{
    await FirebaseFirestore.instance.collection("pets").doc("${widget.petID}").get()
        .then((value){

          currentWeight = value.data()?['weight'];
          name = value.data()?['name'];
          goal =  value.data()?['goal'];
          print("Name is" + name.toString());

          // currentWeight = double.parse(value.data()?['weight']);
          // print(" New Current Weight:" + currentWeight);
          //
          // goal =  double.parse(value.data()?['goal']);
          // print("New Current Goal:" + goal);

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

          Text("W List is" + weightList.length.toString()),




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
