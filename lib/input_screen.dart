import 'package:flutter/material.dart';
import 'package:ptracker/results_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _lastPeriodDate;
  int _cycleLength = 28;
  int _periodDuration = 5;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  void _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _lastPeriodDate = prefs.containsKey('lastPeriodDate')
          ? DateTime.parse(prefs.getString('lastPeriodDate')!)
          : null;
      _cycleLength = prefs.getInt('cycleLength') ?? 28;
      _periodDuration = prefs.getInt('periodDuration') ?? 5;
    });
  }

  void _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_lastPeriodDate != null) {
      await prefs.setString(
          'lastPeriodDate', _lastPeriodDate!.toIso8601String());
    }
    await prefs.setInt('cycleLength', _cycleLength);
    await prefs.setInt('periodDuration', _periodDuration);
  }

  void _calculateResults() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _saveData();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsScreen(
            lastPeriodDate: _lastPeriodDate!,
            cycleLength: _cycleLength,
            periodDuration: _periodDuration,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Period Tracker'),
        backgroundColor: const Color.fromARGB(255, 235, 54, 244),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Card(
                  elevation: 15,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  shadowColor: const Color.fromARGB(255, 235, 54, 244),
                  child: Container(
                    width: 300,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        "assets/images/hema.webp",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Last Period Date',
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                    labelText: 'Last Period Date',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 235, 54, 244), width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 244, 54, 209), width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  keyboardType: TextInputType.datetime,
                  onTap: () async {
                    DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      setState(() {
                        _lastPeriodDate = date;
                      });
                    }
                  },
                  validator: (value) {
                    if (_lastPeriodDate == null) {
                      return 'Please select a date';
                    }
                    return null;
                  },
                  readOnly: true,
                  controller: TextEditingController(
                    text: _lastPeriodDate == null
                        ? ''
                        : _lastPeriodDate!.toLocal().toString().split(' ')[0],
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Cycle Length (days)',
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                    labelText: 'Cycle Length (days)',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 235, 54, 244), width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 244, 54, 209), width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  initialValue: _cycleLength.toString(),
                  onSaved: (value) {
                    _cycleLength = int.parse(value!);
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Period Duration (days)',
                    hintStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                    labelText: 'Period Duration (days)',
                    labelStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 235, 54, 244), width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 244, 54, 209), width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  initialValue: _periodDuration.toString(),
                  onSaved: (value) {
                    _periodDuration = int.parse(value!);
                  },
                ),
                const SizedBox(height: 20),
                Material(
                  elevation: 10,
                  color: const Color.fromARGB(255, 235, 54, 244),
                  borderRadius: BorderRadius.circular(10),
                  shadowColor: const Color.fromARGB(255, 209, 54, 244),
                  surfaceTintColor: Colors.black,
                  child: MaterialButton(
                    onPressed: _calculateResults,
                    minWidth: 200,
                    height: 42,
                    child: const Text(
                      'Calculate',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
