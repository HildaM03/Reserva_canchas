import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:resrevacion_canchas/PagoPage.dart';

class ReservaPage extends StatefulWidget {
  final String canchaNombre;
  ReservaPage({required this.canchaNombre});

  @override
  _ReservaPageState createState() => _ReservaPageState();
}

class _ReservaPageState extends State<ReservaPage> {
  final _formKey = GlobalKey<FormState>();

  final List<String> canchas = ['Cancha 1', 'Cancha 2', 'Cancha 3'];
  final List<String> horarios = [
    '08:00 AM - 09:30 AM',
    '09:30 AM - 11:00 AM',
    '11:00 AM - 12:30 PM',
    '12:30 PM - 02:00 PM',
    '02:00 PM - 03:30 PM',
    '03:30 PM - 05:00 PM',
    '05:00 PM - 06:30 PM',
    '06:30 PM - 08:00 PM',
    '08:00 PM - 09:30 PM',
    '09:30 PM - 10:30 PM',
  ];

  String? selectedCancha;
  DateTime selectedDate = DateTime.now();
  String? selectedHora;
  String quienReserva = '';
  String equipoNombre = '';
  String jugadores = '';

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _reservar() async {
    if (_formKey.currentState!.validate()) {
      // Crear mapa con los datos de la reserva
      Map<String, dynamic> reservaData = {
        'cancha': selectedCancha,
        'fecha': Timestamp.fromDate(selectedDate),
        'hora': selectedHora,
        'quienReserva': quienReserva,
        'equipoNombre': equipoNombre,
        'jugadores': jugadores,
        'timestamp': Timestamp.now(),  // Fecha y hora de registro
      };

      try {
        // Guardar en Firestore en la colección "reservas"
        await FirebaseFirestore.instance.collection('reservas').add(reservaData);

        // Mostrar ticket de reserva
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Ticket de Reserva'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Cancha: $selectedCancha'),
                    Text('Fecha: ${formatDate(selectedDate)}'),
                    Text('Hora: $selectedHora'),
                    Text('Reservado por: $quienReserva'),
                    Text('Equipo: $equipoNombre'),
                    Text('Jugadores:\n$jugadores'),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cerrar ticket
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PagoPage()), // Tu pantalla de pago
                    );
                  },
                  child: Text('Continuar al Pago'),
                ),
              ],
            );
          },
        );
      } catch (e) {
        // Si hay error al guardar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar la reserva: $e')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    selectedCancha = canchas[0];
    selectedHora = horarios[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservar ${widget.canchaNombre}'),
        backgroundColor: Colors.green.shade600,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('Selecciona la Cancha:', style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                value: selectedCancha,
                items: canchas.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (val) => setState(() => selectedCancha = val),
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              Text('Selecciona la Fecha:', style: TextStyle(fontWeight: FontWeight.bold)),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(formatDate(selectedDate)),
                ),
              ),
              SizedBox(height: 20),
              Text('Selecciona el Horario:', style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                value: selectedHora,
                items: horarios.map((h) => DropdownMenuItem(value: h, child: Text(h))).toList(),
                onChanged: (val) => setState(() => selectedHora = val),
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nombre de quien reserva',
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => quienReserva = val,
                validator: (val) => val == null || val.isEmpty ? 'Por favor ingresa un nombre' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nombre del Equipo',
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => equipoNombre = val,
                validator: (val) => val == null || val.isEmpty ? 'Por favor ingresa el nombre del equipo' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Lista de jugadores',
                  hintText: 'Escribe los nombres separados por comas o líneas',
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => jugadores = val,
                validator: (val) => val == null || val.isEmpty ? 'Por favor ingresa la lista de jugadores' : null,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _reservar,
                child: Text('Reservar', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
