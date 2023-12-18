import 'package:flutter/material.dart';
import 'package:flutter_simple_page/Views/ReservationListScreen.dart';
import 'package:intl/intl.dart';
import '../Services/ApiClient.dart';


class TimeSelection extends StatefulWidget {
  final String terrainId;
  final DateTime date;
  final List<int> resHours;

  TimeSelection(this.date, this.terrainId, this.resHours);

  @override
  _TimeSelectionState createState() => _TimeSelectionState();
}

class _TimeSelectionState extends State<TimeSelection> {
  late int _selectedTime;

  @override
  void initState() {
    super.initState();
    if (widget.resHours.isNotEmpty) {
      _selectedTime = widget.resHours[0];
    }
  }

  void _onTimeSelected(int time) {
    setState(() {
      _selectedTime = time;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: AppBar(
    title: const Text(
      'Choose Time',
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.teal.shade500,
  ),
  body: Container(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.topCenter,
          child: Image.asset(
            'assets/time.gif', // Replace with your image path
            width: 200,
            height: 200,
          ),
        ),
        Text(
          DateFormat('yyyy-MM-dd').format(widget.date),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.red),
        ),
        const SizedBox(height: 20),
        const Text(
          'Selected Time:',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Colors.black),
        ),
        const SizedBox(height: 10),
        Text(
          '${_selectedTime.toString().padLeft(2, '0')}:00',
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Colors.green),
        ),
        const SizedBox(height: 30),
        const Text(
          'Select a time slot:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black),
        ),
        const SizedBox(height: 10),
        Wrap(
  alignment: WrapAlignment.center,
  spacing: 20,
  children: [
    for (int i = 15; i <= 24; i += 2)
      GestureDetector(
        onTap: widget.resHours.contains(i) ? () => _onTimeSelected(i) : null,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: _selectedTime == i
                ? Colors.teal.shade500
                : (widget.resHours.contains(i) ? Colors.grey[300] : Colors.white),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            '${i.toString().padLeft(2, '0')}:00',
            style: TextStyle(
              fontSize: 20,
              fontWeight: _selectedTime == i ? FontWeight.bold : FontWeight.normal,
              color: _selectedTime == i
                  ? Colors.white
                  : (widget.resHours.contains(i) ? Colors.grey : Colors.black),
            ),
          ),
        ),
      ),
  ],
),
        const SizedBox(height: 30),
        FloatingActionButton.extended(
          onPressed: () async {
            if (widget.resHours.isNotEmpty) {
              final response = await ApiClient.postReservation(widget.terrainId, widget.date, _selectedTime);
              if (response.statusCode == 200) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReservationListScreen()),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Registration Added successfully. Please wait for acceptance."),
                    duration: Duration(seconds: 3),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("You are already registered."),
                    duration: Duration(seconds: 3),
                  ),
                );
              }
            }
          },
          backgroundColor: Colors.teal.shade500,
          label: const Text('Confirm'),
          icon: const Icon(Icons.check_circle),
        ),
      ],
    ),
  ),
);
  }
}
