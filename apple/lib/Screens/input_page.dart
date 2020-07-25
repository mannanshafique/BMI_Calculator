import 'dart:io';

import 'package:flutter/material.dart';
import 'package:apple/components/icon_contents.dart';
import 'package:apple/components/bottom_button.dart';
import 'package:apple/components/resuable_card.dart';
import 'package:apple/components/round_edit_button.dart';
import 'package:apple/constants.dart';
import 'package:numberpicker/numberpicker.dart';
import 'result_page.dart';
import 'package:apple/calculator_brain.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum Gender {
  male,
  female,
}

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: Text('Are you sure?', style: kAlertFontcolor),
            content: Text('Do you want to exit an App', style: kAlertFontcolor),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'No',
                  style: kAlertFontcolor,
                ),
              ),
              FlatButton(
                onPressed: () => exit(0),
                /*Navigator.of(context).pop(true)*/
                child: Text(
                  'Yes',
                  style: kAlertFontcolor,
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Gender selectedGender;
  int heightFeet;
  int heightInch;
  double wholeHeight;
  int weight = 50;
  int age = 20;
  TextEditingController feet = TextEditingController();
  TextEditingController inch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
            title: Text('BMI CALCULATOR'),
            centerTitle: true,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ReuseableCard(
                    onPress: () {
                      setState(() {
                        selectedGender = Gender.male;
                      });
                    },
                    colour: selectedGender == Gender.male
                        ? kActiveCardColour
                        : kInactiveCardColour,
                    cardChild: Iconcontext(
                      icon: FontAwesomeIcons.mars,
                      label: 'MALE',
                    ),
                  ),
                  ReuseableCard(
                    onPress: () {
                      setState(() {
                        selectedGender = Gender.female;
                      });
                    },
                    colour: selectedGender == Gender.female
                        ? kActiveCardColour
                        : kInactiveCardColour,
                    cardChild: Iconcontext(
                      icon: FontAwesomeIcons.venus,
                      label: 'FEMALE',
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ReuseableCard(
                  colour: kActiveCardColour,
                  cardChild: Column(
                    children: <Widget>[
                      Text(
                        'HEIGHT',
                        style: kLabelTextStyle,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text("Feet"),
                      SizedBox(
                        height: 3,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40, right: 40),
                        child: TextField(
                          controller: feet,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              labelText: "Feet",
                              contentPadding:
                                  EdgeInsets.only(left: 10, right: 10),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                      Text("Inch"),
                      SizedBox(
                        height: 3,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40, right: 40),
                        child: TextField(
                          controller: inch,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              labelText: "Inch",
                              contentPadding:
                                  EdgeInsets.only(left: 10, right: 10),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ReuseableCard(
                        colour: kActiveCardColour,
                        cardChild: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        'WEIGHT',
                                        style: kLabelTextStyle,
                                      ),
                                      Text(
                                        weight.toString(),
                                        style: kNumberTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: <Widget>[
                                    NumberPicker.integer(
                                        initialValue: weight,
                                        minValue: 18,
                                        maxValue: 200,
                                        onChanged: (newValue) =>
                                            setState(() => weight = newValue)),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ReuseableCard(
                        colour: kActiveCardColour,
                        cardChild: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        'AGE',
                                        style: kLabelTextStyle,
                                      ),
                                      Text(
                                        age.toString(),
                                        style: kNumberTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: <Widget>[
                                    NumberPicker.integer(
                                        initialValue: age,
                                        minValue: 5,
                                        maxValue: 100,
                                        onChanged: (newValue) =>
                                            setState(() => age = newValue)),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              BottomButton(
                buttonTitle: 'CALCULATE',
                onTap: () {
                  setState(() {
                    wholeHeight = double.parse(feet.text) * 30.48 +
                        double.parse(inch.text) * 2.54;
                  });
                  CalculatorBrain calc =
                      CalculatorBrain(height: wholeHeight, weight: weight);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultsPage(
                        bmiResult: calc.calculateBMI(),
                        resultText: calc.getResult(),
                        interpretation: calc.getInterpretation(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ));
  }
}
