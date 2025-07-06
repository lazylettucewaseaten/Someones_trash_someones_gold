import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleAppointmentPage extends StatefulWidget {
  final String counselorName;

  ScheduleAppointmentPage({required this.counselorName});

  @override
  _ScheduleAppointmentPageState createState() =>
      _ScheduleAppointmentPageState();
}

class _ScheduleAppointmentPageState extends State<ScheduleAppointmentPage> {
  DateTime? _selectedDate;
  final TextEditingController _additionalInputController =
      TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _scheduleAppointment() async {
    if (_selectedDate != null) {
      final String formattedDate =
          DateFormat('MM/dd/yyyy').format(_selectedDate!);

      // Save the appointment string in shared preferences
      final String appointmentString =
          '${widget.counselorName} appointment - $formattedDate';
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('response', appointmentString);

      // Display the confirmation message on the screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Your Appointment is scheduled on $formattedDate')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a date.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Appointment'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Date:',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent)),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent, width: 2),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDate == null
                          ? 'Choose a date'
                          : DateFormat('MM/dd/yyyy').format(_selectedDate!),
                      style: TextStyle(fontSize: 16),
                    ),
                    Icon(Icons.calendar_today, color: Colors.blueAccent),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Additional Information:',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent)),
            SizedBox(height: 10),
            TextField(
              controller: _additionalInputController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: 'Enter additional information here...',
                filled: true,
                fillColor: Colors.white,
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _scheduleAppointment,
                child: Text('Schedule Appointment'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}