import 'package:flutter/material.dart';
import 'cat_api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CatPhotoScreen(),
    );
  }
}

class CatPhotoScreen extends StatefulWidget {
  @override
  _CatPhotoScreenState createState() => _CatPhotoScreenState();
}

class _CatPhotoScreenState extends State<CatPhotoScreen> {
  CatApi _catApi = CatApi();
  List<String> _catPhotos = [];

  @override
  void initState() {
    super.initState();
    _getCatPhotos();
  }

  void _getCatPhotos() async {
    try {
      List<String> photos = [];

      // Realiza chamadas separadas para obter mais fotos
      for (int i = 0; i < 5; i++) {
        List<String> photoList = await _catApi.getCatPhotos();
        String photo = photoList.isNotEmpty
            ? photoList.first
            : ''; // Pega a primeira foto, se houver
        photos.add(photo);
      }

      setState(() {
        _catPhotos = photos;
      });

      // Adiciona o print dos links das fotos
      for (int i = 0; i < _catPhotos.length; i++) {
        String url = _catPhotos[i];
        print('Link da Foto: $url');
      }
    } catch (e) {
      print('Erro ao obter fotos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fotos de Gatos'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: _catPhotos
              .map((url) => Image.network(
                    url,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        // Se o carregamento estiver completo, exibe a imagem
                        return child;
                      } else {
                        // Durante o carregamento, exibe um indicador de progresso
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        );
                      }
                    },
                    errorBuilder: (BuildContext context, Object error,
                        StackTrace? stackTrace) {
                      // Se ocorrer um erro, exibe uma mensagem ou uma imagem de erro padrão
                      return Center(
                        child: Icon(Icons.error),
                      );
                    },
                  ))
              .toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _getCatPhotos(),
        tooltip: 'Obter Novas Fotos',
        child: Icon(Icons.refresh),
      ),
    );
  }
}
