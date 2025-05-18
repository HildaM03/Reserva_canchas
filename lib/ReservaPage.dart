  import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReservaPage extends StatefulWidget {
  final String canchaNombre;

  const ReservaPage({Key? key, required this.canchaNombre}) : super(key: key);

  @override
  State<ReservaPage> createState() => _ReservaPageState();
}

class _ReservaPageState extends State<ReservaPage> {
  final _formKey = GlobalKey<FormState>();

  final List<String> canchas = ['Cancha 1', 'Cancha 2', 'Cancha 3'];
  final List<String> horarios = [
    '08:00 - 09:30',
    '09:30 - 11:00',
    '11:00 - 12:30',
    '12:30 - 14:00',
    '14:00 - 15:30',
    '15:30 - 17:00',
    '17:00 - 18:30',
    '18:30 - 20:00',
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

  void _reservar() {
    if (_formKey.currentState!.validate()) {
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
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cerrar'),
              ),
            ],
          );
        },
      );
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