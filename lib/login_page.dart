import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'CanchasPage.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();

  Future<void> iniciarSesion(BuildContext context) async {
    String email = emailCtrl.text.trim();
    String pass = passCtrl.text.trim();

    if (email.isNotEmpty && pass.isNotEmpty) {
      try {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('usuarios')
            .where('correo', isEqualTo: email)
            .get();

        if (snapshot.docs.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('✅ Bienvenido. Iniciando sesión...')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CanchasPage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('❌ Usuario no registrado. Primero debes registrarte.')),
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

  Future<void> registrarUsuario(BuildContext context) async {
    String email = emailCtrl.text.trim();
    String pass = passCtrl.text.trim();

    if (email.isNotEmpty && pass.isNotEmpty) {
      try {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('usuarios')
            .where('correo', isEqualTo: email)
            .get();

        if (snapshot.docs.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('⚠️ Este usuario ya ha sido registrado.')),
          );
        } else {
          await FirebaseFirestore.instance.collection('usuarios').add({
            'correo': email,
            'contrasena': pass,
            'fecha': Timestamp.now(),
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('✅ Usuario registrado exitosamente. Iniciando sesión...')),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CanchasPage()),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Error al registrar el usuario')),
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
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://www.xtrafondos.com/thumbs/webp/1_12039.webp',
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return Center(child: Text('Error cargando la imagen'));
              },
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                width: 320,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
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
                        onPressed: () => iniciarSesion(context),
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
                    SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () => registrarUsuario(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade800,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 5,
                        ),
                        child: Text('Registrarse'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
