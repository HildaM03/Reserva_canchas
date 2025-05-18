import 'package:flutter/material.dart'; 
import 'package:cached_network_image/cached_network_image.dart'; // IMPORTANTE
import 'ReservaPage.dart'; // Asegúrate de tener este archivo

class CanchasPage extends StatelessWidget {
  final List<Map<String, String>> canchas = [
    {
      'nombre': 'SportMania',
      'imagen':
          'https://scontent.fsap12-1.fna.fbcdn.net/v/t39.30808-6/489787440_29434847472795932_8830267978180362267_n.jpg?stp=dst-jpg_s960x960_tt6&_nc_cat=108&ccb=1-7&_nc_sid=cc71e4&_nc_ohc=ey9XhkOTiZoQ7kNvwGjxiuw&_nc_oc=AdltDweIoO8THuMbvQcDoE6h8YkB_HckUQ6eQyn87QbN5q0CHtD1ecjfS3FFWUjhsxY&_nc_zt=23&_nc_ht=scontent.fsap12-1.fna&_nc_gid=C4mW_5jjMvSudpMEOOHMbQ&oh=00_AfJPLexBWa2k9lfzdJVWQIw9N7MsYTEgmZyiMoIv4Ndf_Q&oe=682D79C5',
    },
    {
      'nombre': 'Maracana Palenque',
      'imagen':
          'https://scontent.fsap12-1.fna.fbcdn.net/v/t39.30808-6/305297731_519801253481214_1238331527813895484_n.jpg?_nc_cat=106&ccb=1-7&_nc_sid=6ee11a&_nc_ohc=0ewi9xTwvCAQ7kNvwHsE24m&_nc_oc=Adml5mTy13RALuS5gnkpX4xchyXWmgFvU7jPIRJghuTMjW6CrhqXmzC0ShkRIH1DKbs&_nc_zt=23&_nc_ht=scontent.fsap12-1.fna&_nc_gid=vjyOfBG9vag50J2bAZzyxA&oh=00_AfJVRBnBqiHBODxDOkWVGFEhCc3AP-UaBpRkq-HfBb7vHg&oe=682D7FB8',
    },
    {
      'nombre': 'Los Castaños',
      'imagen':
          'https://media.istockphoto.com/id/1997871782/es/foto/soccer-player-kicking-ball-at-goal.jpg?s=612x612&w=0&k=20&c=UUjRBFiY_PD1plhYrulPIloXErXqVZ0vi97YFobOl5Y=',
    },
    {
      'nombre': 'Cancha Rancho Tara',
      'imagen':
          'https://media.istockphoto.com/id/1610631888/es/foto/ni%C3%B1o-jugando-al-f%C3%BAtbol-en-el-parque-local.webp?a=1&b=1&s=612x612&w=0&k=20&c=WOL1stc3wtdT2KhxUvat4xd-6XclIed9hU_RBTd1QRA=',
    },
    {
      'nombre': 'Campisa',
      'imagen':
          'https://images.unsplash.com/photo-1579952363873-27f3bade9f55?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8YmFsJUMzJUIzbiUyMGRlJTIwZiVDMyVCQXRib2x8ZW58MHx8MHx8fDA%3D',
    },
    {
      'nombre': 'Complejo Deportivo Emil Martínez',
      'imagen':
          'https://images.unsplash.com/photo-1575361204480-aadea25e6e68?q=80&w=1471&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Canchas'),
        backgroundColor: Colors.green.shade600,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: canchas.length,
          itemBuilder: (context, index) {
            final cancha = canchas[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReservaPage(canchaNombre: cancha['nombre']!),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
                margin: EdgeInsets.only(bottom: 20),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: cancha['imagen']!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 200,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: Icon(Icons.error, size: 40, color: Colors.red),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.black54, Colors.transparent],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        child: Text(
                          cancha['nombre']!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(blurRadius: 5, color: Colors.black, offset: Offset(1, 1)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}