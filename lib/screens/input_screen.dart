import 'package:flutter/material.dart';
import '../widgets/temperature_display.dart';
import '../services/api_service.dart';
import '../utils/connectivity_checker.dart';

class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _latController = TextEditingController();
  final _lonController = TextEditingController();
  double? _temperature;

  Future<void> _fetchTemperature() async {
    final double? latitude = double.tryParse(_latController.text);
    final double? longitude = double.tryParse(_lonController.text);

    if (latitude == null || longitude == null) {
      _showInvalidInputAlert();
      return;
    }

    bool isConnected = await ConnectivityChecker.isConnected();
    if (isConnected) {
      _temperature = await ApiService.getTemperature(latitude, longitude);
      if (_temperature == null) {
        _showInvalidCoordinatesAlert();
      }
    } else {
      _showNoConnectionAlert();
      _temperature = 17.0; // Valor predeterminado sin conexión
    }
    setState(() {});
  }

  void _showInvalidInputAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Entrada inválida"),
          content: Text(
              "Por favor, ingrese valores válidos para latitud y longitud."),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showInvalidCoordinatesAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error de coordenadas"),
          content: Text(
              "Las coordenadas ingresadas no son válidas o no se pudo obtener la temperatura."),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showNoConnectionAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Sin conexión"),
          content: Text(
              "No se pudo establecer conexión. Mostrando temperatura predeterminada de 17°C."),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Consultar Temperatura',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _latController,
              decoration: InputDecoration(
                labelText: 'Latitud',
                hintText: 'Ejemplo: 6.2447',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _lonController,
              decoration: InputDecoration(
                labelText: 'Longitud',
                hintText: 'Ejemplo: -75.5748',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 24),
            OutlinedButton(
              onPressed: _fetchTemperature,
              child: Text(
                'Consultar',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                side: BorderSide.none,
              ),
            ),
            SizedBox(height: 24),
            TemperatureDisplay(temperature: _temperature),
          ],
        ),
      ),
    );
  }
}
