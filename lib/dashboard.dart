import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _relay1Status = false;
  bool _relay2Status = false;
  List<Map<String, dynamic>> _sensorData = []; // List to store sensor data

  @override
  void initState() {
    super.initState();
    fetchSensorData(); // Fetch sensor data when the page initializes
  }

  // Method to fetch sensor data from the server
  Future<void> fetchSensorData() async {
    try {
      // Send HTTP GET request to fetch sensor data
      final response = await http.get(
        Uri.parse('https://kspiotproject.000webhostapp.com/fetch_data.php'),
      );

      if (response.statusCode == 200) {
        // Decode the JSON response and update the state
        setState(() {
          _sensorData =
              List<Map<String, dynamic>>.from(jsonDecode(response.body));
        });
      } else {
        print('Failed to fetch sensor data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching sensor data: $e');
    }
  }

  Future<void> toggleRelay1(bool newValue) async {
    // Update the UI optimistically
    setState(() {
      _relay1Status = newValue;
    });

    // Send command to the server to control Relay 1
    // Example: Implement HTTP request to toggle Relay 1 status
    try {
      // Send HTTP request to control Relay 1 based on newValue
      // Replace the URL and request parameters with your actual API endpoint
      final response = await http.post(
        Uri.parse('https://kspiotproject.000webhostapp.com/relay_control.php'),
        body: {
          'relay': '1',
          'status': newValue ? 'on' : 'off',
        },
      );

      if (response.statusCode == 200) {
        // Success, relay control command sent successfully
        // Handle any additional logic or UI updates
      } else {
        // Handle errors or display error message
        print('Failed to toggle Relay 1: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error toggling Relay 1: $e');
    }
  }

  // Method to toggle Relay 2
  Future<void> toggleRelay2(bool newValue) async {
    // Update the UI optimistically
    setState(() {
      _relay2Status = newValue;
    });

    // Send command to the server to control Relay 1
    // Example: Implement HTTP request to toggle Relay 1 status
    try {
      // Send HTTP request to control Relay 1 based on newValue
      // Replace the URL and request parameters with your actual API endpoint
      final response = await http.post(
        Uri.parse('https://kspiotproject.000webhostapp.com/relay_control.php'),
        body: {
          'relay': '2',
          'status': newValue ? 'on' : 'off',
        },
      );

      if (response.statusCode == 200) {
        // Success, relay control command sent successfully
        // Handle any additional logic or UI updates
      } else {
        // Handle errors or display error message
        print('Failed to toggle Relay 2: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error toggling Relay 2: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Relay 1',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: _relay1Status,
                  onChanged: toggleRelay1,
                ),
                const SizedBox(width: 20),
                const Text(
                  'Relay 2',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: _relay2Status,
                  onChanged: toggleRelay2,
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Sensor Data',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _sensorData.length,
                itemBuilder: (context, index) {
                  final sensor = _sensorData[index];
                  return ListTile(
                    title: Text(sensor['sensor_name']),
                    subtitle: Text(
                        'Value: ${sensor['sensor_value']}, Timestamp: ${sensor['timestamp']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
