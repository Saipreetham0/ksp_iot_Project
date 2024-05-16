import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Map<String, dynamic>> _sensorData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      // Make HTTP GET request to fetch data from the provided URL
      final response = await http.get(Uri.parse('https://kspiotproject.000webhostapp.com/fetch_data.php'));

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Decode the JSON response
        final List<dynamic> responseData = jsonDecode(response.body);

        // Update state with the fetched sensor data
        setState(() {
          _sensorData = List<Map<String, dynamic>>.from(responseData);
        });
      } else {
        // Handle errors if the response is not successful
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: ListView.builder(
        itemCount: _sensorData.length,
        itemBuilder: (context, index) {
          final sensor = _sensorData[index];
          return ListTile(
            title: Text(sensor['sensor_name']),
            subtitle: Text('Value: ${sensor['sensor_value']}, Timestamp: ${sensor['timestamp']}'),
          );
        },
      ),
    );
  }
}
