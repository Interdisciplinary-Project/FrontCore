import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:escoteiro/app/HomeScreen.dart';
import 'package:escoteiro/app/activitiesscreen.dart';
import 'package:escoteiro/app/perfilscreen.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  static const int _maxImageCount = 55;
  static const int _initialImageCount = 10;
  static const int _imagesPerLoad = 10;

  int _loadedImageCount = _initialImageCount;

  void _loadMoreImages() {
    if (_loadedImageCount < _maxImageCount) {
      setState(() {
        final remainingImages = _maxImageCount - _loadedImageCount;
        final imagesToAdd = remainingImages < _imagesPerLoad ? remainingImages : _imagesPerLoad;
        _loadedImageCount += imagesToAdd;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool allImagesLoaded = _loadedImageCount >= _maxImageCount;

    return Scaffold(
      backgroundColor: const Color(0xFFE2F0E1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      _buildHeader(),
                      const SizedBox(height: 16),
                      _buildGallerySection(),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(context),
      floatingActionButton: allImagesLoaded
          ? null
          : FloatingActionButton(
              onPressed: _loadMoreImages,
              backgroundColor: const Color(0xFF4CAF50),
              child: const Icon(Icons.add_a_photo, color: Colors.white),
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: SvgPicture.asset(
              'assets/images/logos/logo-dark.svg',
              fit: BoxFit.contain,
              color: const Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Grupo Escoteiro Terra na Saudade - GETS',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF000000),
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGallerySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Text(
            'Galeria',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF000000),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(), 
          itemCount: _loadedImageCount,
          itemBuilder: (context, index) {
            return _buildPhotoCard(index);
          },
        ),
      ],
    );
  }

  Widget _buildPhotoCard(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0), 
      child: Card(
        elevation: 4, 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          child: Image.asset(
            'assets/images/imagem-${index + 1}.jpg',
            fit: BoxFit.contain, 
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: const Color(0xFFE0E0E0),
                child: const Center(
                  child: Icon(
                    Icons.broken_image,
                    size: 48,
                    color: Color(0xFF9E9E9E),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFFAFAFA),
        selectedItemColor: const Color(0xFF059A00),
        unselectedItemColor: const Color(0xFFAFAFAF),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        currentIndex: 1, 
        onTap: (i) {
          if (i == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          } else if (i == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ActivitiesScreen()),
            );
          } else if (i == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PerfilScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.photo), label: 'Galeria'),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline), label: 'Atividades'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
      ),
    );
  }
}