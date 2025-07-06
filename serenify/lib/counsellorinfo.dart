// CounselorInfoScreen.dart
import 'package:flutter/material.dart';
import 'make_appointment.dart';

class CounselorInfoScreen extends StatelessWidget {
  // Counselor's email

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Counselor Information'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage('https://content.mycutegraphics.com/graphics/bee/blue-buzzing-bee.png'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Dr. Avinash Patel',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Qualification: PhD in Clinical Psychology\n'
                    'Experience: 10 years\n'
                    'Contact: avinashpatel08963@gmail.com',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScheduleAppointmentPage(
                            counselorName: 'Dr. Avinash Patel',
                          ),
                        ),
                      );
                    },
                    child: Text('Schedule Appointment'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}