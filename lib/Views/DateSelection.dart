import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Services/ApiClient.dart';
import 'TimeSelection.dart';

class DateSelection extends StatefulWidget {
  final String terrainId;
  final List<String> avaiDates;

  DateSelection(this.terrainId,this.avaiDates);

  @override
  _DateSelectionState createState() => _DateSelectionState();
}

class _DateSelectionState extends State<DateSelection> {
 late DateTime _selectedDate;


  @override
  void initState() {
    super.initState();
    _selectedDate=DateFormat('dd-MM-yyyy').parse(widget.avaiDates[0]);
  }

  Future<void> _selectDate(BuildContext context ,List<String> avDates) async {
    // ignore: use_build_context_synchronously
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: new DateFormat('dd-MM-yyyy').parse(avDates[0]),
      firstDate: new DateFormat('dd-MM-yyyy').parse(avDates[0]),
      lastDate: DateTime.now().add(Duration(days: 8)),
      selectableDayPredicate: (DateTime date) {
        String formattedDate = DateFormat('dd-MM-yyyy').format(date);
        return avDates.contains(formattedDate);
      },
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.teal.shade500,
            hintColor: Colors.teal.shade500,
            colorScheme:  ColorScheme.light(
              primary: Colors.teal.shade500,
              secondary: Colors.teal.shade500,
            ),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
  appBar: AppBar(
    title: Text(
      'Choose Date',
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.teal.shade500,
  ),
  body: Container(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.topCenter,
          child: Image.asset(
            'assets/calender.gif', // Replace with your image path
            width: 300,
            height: 300,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Selected Date:',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: Colors.black),
        ),
        SizedBox(height: 10),
        Text(
          '${DateFormat('dd-MM-yyyy').format(_selectedDate)}',
          style: TextStyle(fontSize: 25, color: Colors.red),
        ),
        SizedBox(height: 30),
        ElevatedButton.icon(
          onPressed: () => _selectDate(context, widget.avaiDates),
          icon: Icon(Icons.date_range),
          style: ElevatedButton.styleFrom(
            primary: Colors.teal.shade500,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          label: Text(
            'Choose Date',
            style: TextStyle(fontSize: 18),
          ),
        ),
        SizedBox(height: 30),
        FloatingActionButton.extended(
          onPressed: () async {
            List<int> tabres = await ApiClient.fetchUnavailableHours(widget.terrainId, _selectedDate);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TimeSelection(_selectedDate, widget.terrainId, tabres),
              ),
            );
          },
          label: Text(
            'Next',
            style: TextStyle(fontSize: 18),
          ),
          backgroundColor: Colors.green,
          icon: Icon(Icons.navigate_next_rounded),
        ),
      ],
    ),
  ),
);

  }
}
