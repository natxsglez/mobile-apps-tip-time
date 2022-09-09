import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var totalController = TextEditingController();
  var radioGroup = {0: "Amazing 20%", 1: "Good 18%", 3: "Okay 15%"};
  var isSwitched = false;
  int? currentRadio;
  double totalTip = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tip time'),
      ),
      body: ListView(
        children: [
          SizedBox(height: 14),
          ListTile(
            leading: Icon(Icons.room_service),
            title: Padding(
              padding: EdgeInsets.only(right: 24),
              child: TextField(
                  keyboardType: TextInputType.number,
                  controller: totalController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Cost of service"))),
            ),
          ),
          ListTile(
            leading: Icon(Icons.dinner_dining),
            title: Text("How was the service?"),
            contentPadding: EdgeInsets.only(top: 5, bottom: 10, left: 18),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: _radioGroupGenerator(),
          ),
          ListTile(
            leading: Icon(Icons.credit_card),
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Round up tip"),
                  Switch(
                      value: isSwitched,
                      onChanged: (value) {
                        setState(() {
                          isSwitched = value;
                        });
                      }),
                ]),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              child: Text("CALCULATE"),
              onPressed: () {
                if (totalController.text == "" || currentRadio == null) {
                  showDialog(
                      context: context,
                      builder: (context) => _showAlertDialog());
                } else {
                  totalTip = _tipCalculation();
                  setState(() {});
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "Tip amount: \$${totalTip.toStringAsFixed(2)}",
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  _radioGroupGenerator() {
    return radioGroup.entries
        .map(
          (radioElement) => ListTile(
            contentPadding: EdgeInsets.fromLTRB(60, 0, 0, 0),
            leading: Radio<int>(
              value: radioElement.key,
              groupValue: currentRadio,
              onChanged: (int? selected) {
                currentRadio = selected;
                setState(() {});
              },
            ),
            title: Text(
              "${radioElement.value}",
              textAlign: TextAlign.left,
            ),
          ),
        )
        .toList();
  }

  double _tipCalculation() {
    double total = double.parse(totalController.text);
    double tipPercentage = currentRadio == 0
        ? 0.2
        : currentRadio == 1
            ? 0.18
            : 0.15;

    double tip = total * tipPercentage;
    
    if (isSwitched) {
      tip = tip.ceil().toDouble();
    }

    return tip;
  }

  AlertDialog _showAlertDialog() {
    return AlertDialog(
      title: const Text('Unable to calculate the Tip amount'),
      content: SingleChildScrollView(
        child: ListBody(children: const <Widget>[
          Text('One or more of the fields are empty, please try again.'),
        ]),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
