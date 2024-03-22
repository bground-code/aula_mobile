import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PaginaUsuarios(),
    );
  }
}

class PaginaUsuarios extends StatefulWidget {
  @override
  _PaginaUsuariosState createState() => _PaginaUsuariosState();
}

class _PaginaUsuariosState extends State<PaginaUsuarios> {
  Future<List<Usuario>> lerJson() async {
    final String resposta = await rootBundle.loadString('assets/users.json');
    final dados = await json.decode(resposta);
    return List<Usuario>.from(dados["users"].map((x) => Usuario.fromJson(x)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuários'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<Usuario>>(
        future: lerJson(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (context, index) {
                  final usuario = snapshot.data![index];
                  return Dismissible(
                    key: Key(usuario.id.toString()),
                    onDismissed: (direction) {},
                    background: Container(color: Colors.green),
                    child: Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(usuario.imagemUrl),
                        ),
                        title: Text(
                            '${usuario.primeiroNome} ${usuario.sobrenome}'),
                        subtitle: Text(usuario.email),
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}

class Usuario {
  final int id;
  final String primeiroNome;
  final String sobrenome;
  final String email;
  final String imagemUrl;

  Usuario({
    required this.id,
    required this.primeiroNome,
    required this.sobrenome,
    required this.email,
    required this.imagemUrl,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      primeiroNome: json['firstName'],
      sobrenome: json['lastName'],
      email: json['email'],
      imagemUrl: json['image'],
    );
  }
}
