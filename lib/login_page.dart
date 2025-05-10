import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'CanchasPage.dart';  // Importa la pantalla de canchas

class LoginPage extends StatelessWidget {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();

  // Método para verificar si el usuario ya existe en Firebase
  Future<void> verificarUsuario(BuildContext context) async {
    String email = emailCtrl.text.trim();
    String pass = passCtrl.text.trim();

    if (email.isNotEmpty && pass.isNotEmpty) {
      try {
        // Verificar si el usuario ya existe en Firebase
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('usuarios')
            .where('correo', isEqualTo: email)
            .get();

        // Si ya existe un usuario con ese correo
        if (snapshot.docs.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('✅ Usuario ya registrado. Iniciando sesión...')),
          );
          // Navegar a la pantalla de Canchas
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CanchasPage()),
          );
        } else {
          // Si no existe, crear el nuevo usuario en Firebase
          await FirebaseFirestore.instance.collection('usuarios').add({
            'correo': email,
            'contrasena': pass,
            'fecha': Timestamp.now(),
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('✅ Nuevo usuario registrado. Iniciando sesión...')),
          );
          // Navegar a la pantalla de Canchas
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CanchasPage()),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Error al procesar la solicitud')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('⚠️ Ingresa correo y contraseña')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade100,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(16),
            width: 320,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Fútbol Pasión ⚽',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
                SizedBox(height: 20),
                _buildInputField(
                  controller: emailCtrl,
                  label: 'Correo electrónico',
                  icon: Icons.email,
                  fillColor: Colors.yellow.shade50,
                ),
                SizedBox(height: 12),
                _buildInputField(
                  controller: passCtrl,
                  label: 'Contraseña',
                  icon: Icons.lock,
                  obscureText: true,
                  fillColor: Colors.yellow.shade50,
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () => verificarUsuario(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 5,
                    ),
                    child: Text('Iniciar Sesión'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    Color? fillColor,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.green.shade800),
        labelText: label,
        labelStyle: TextStyle(color: Colors.green.shade800),
        filled: true,
        fillColor: fillColor ?? Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green.shade600, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
