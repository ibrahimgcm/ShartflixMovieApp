import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'core/profile_provider.dart';
import 'dart:ui';
import 'home_screen.dart'; // HomeScreen'i içe aktar

class ProfilePhotoScreen extends StatefulWidget {
  const ProfilePhotoScreen({Key? key}) : super(key: key);

  @override
  State<ProfilePhotoScreen> createState() => _ProfilePhotoScreenState();
}

class _ProfilePhotoScreenState extends State<ProfilePhotoScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _showOfferModal = false;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      // Fotoğraf yolunu provider'a kaydet
      Provider.of<ProfileProvider>(context, listen: false).setPhotoPath(pickedFile.path);
    }
  }

  void _toggleOfferModal() {
    setState(() {
      _showOfferModal = !_showOfferModal;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Kırmızı blur arka plan
          Positioned(
            left: 43,
            top: -71,
            child: Container(
              width: 310,
              height: 208,
              decoration: BoxDecoration(
                gradient: const RadialGradient(
                  colors: [Color(0xFFFF1B1B), Color.fromRGBO(141, 0, 0, 0)],
                  center: Alignment.center,
                  radius: 0.5,
                ),
              ),
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25.3, sigmaY: 25.3),
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
          // Üst bar
          Positioned(
            top: 60,
            left: width / 2 - 201,
            child: Container(
              width: 402,
              height: 60,
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255,255,255,0.05),
                        border: Border.all(color: Color.fromRGBO(255,255,255,0.2)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 24),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Profil Detayı',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Instrument Sans',
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // İçerik
          Positioned(
            left: 103,
            top: 172,
            child: SizedBox(
              width: 196,
              height: 443,
              child: Column(
                children: [
                  // Profil simgesi
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Icon(Icons.person, size: 48, color: Colors.white.withOpacity(0.7)),
                  ),
                  const SizedBox(height: 16),
                  // Fotoğraf yükle başlık
                  Column(
                    children: const [
                      Text(
                        'Fotoğraf Yükle',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Instrument Sans',
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Profil fotoğrafın için görsel yükleyebilirsin',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Instrument Sans',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(255,255,255,0.9),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 52),
                  // Fotoğraf yükleme alanı (eklenmiş fotoğraf)
                  _image != null
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 176,
                              height: 176,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(255,255,255,0.05),
                                borderRadius: BorderRadius.circular(32),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(32),
                                child: Image.file(_image!, fit: BoxFit.cover, width: 176, height: 176),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _image = null;
                                  });
                                  // Fotoğrafı provider'dan sil
                                  Provider.of<ProfileProvider>(context, listen: false).clearPhoto();
                                },
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.8),
                                    border: Border.all(color: Color.fromRGBO(255,255,255,0.5), width: 1),
                                    borderRadius: BorderRadius.circular(900),
                                  ),
                                  child: Center(
                                    child: Icon(Icons.close, color: Colors.white, size: 24),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 176,
                            height: 176,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255,255,255,0.05),
                              border: Border.all(
                                color: Color.fromRGBO(255,255,255,0.2),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add, color: Colors.white, size: 32),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
          // Alt butonlar
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 177,
            top: 699,
            child: SizedBox(
              width: 354,
              child: Column(
                children: [
                  Opacity(
                    opacity: 0.5,
                    child: Container(
                      width: 354,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Color(0xFFE50914),
                        border: Border.all(color: Color(0xFFE50914)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          'Devam Et',
                          style: TextStyle(
                            fontFamily: 'Instrument Sans',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.05),
                                offset: Offset(0, 4),
                                blurRadius: 8,
                              ),
                              Shadow(
                                color: Colors.black.withOpacity(0.03),
                                offset: Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 13),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                    child: Container(
                      width: 354,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Color(0xFFE50914),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          'Atla',
                          style: TextStyle(
                            fontFamily: 'Instrument Sans',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Custom Sınırlı Teklif Modal
          if (_showOfferModal)
            Positioned(
              left: (width - 402) / 2,
              top: 0,
              child: Container(
                width: 402,
                height: 874,
                child: Stack(
                  children: [
                    // Arka plan overlay
                    Container(
                      width: 402,
                      height: 874,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(9, 9, 9, 0.8),
                      ),
                    ),
                    // Modal ana kutu
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: Container(
                        width: 402,
                        height: 665,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF090909), Color(0xFF3F0306)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Stack(
                          children: [
                            // Kırmızı blur üst
                            Positioned(
                              left: 46,
                              top: -60,
                              child: Container(
                                width: 310,
                                height: 208,
                                decoration: BoxDecoration(
                                  gradient: RadialGradient(
                                    colors: [Color(0xFFFF1B1B), Color.fromRGBO(141, 0, 0, 0)],
                                    center: Alignment.center,
                                    radius: 0.5,
                                  ),
                                ),
                                child: ClipRect(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 25.3, sigmaY: 25.3),
                                    child: Container(color: Colors.transparent),
                                  ),
                                ),
                              ),
                            ),
                            // Kırmızı blur alt
                            Positioned(
                              left: (402 - 217) / 2,
                              top: 514,
                              child: Container(
                                width: 217,
                                height: 217,
                                decoration: BoxDecoration(
                                  color: Color(0xFFE50914),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: ClipRect(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 125, sigmaY: 125),
                                    child: Container(color: Colors.transparent),
                                  ),
                                ),
                              ),
                            ),
                            // İçerik
                            Positioned(
                              left: 24,
                              top: 32,
                              child: Container(
                                width: 354,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Başlık ve açıklama
                                    SizedBox(height: 8),
                                    Text(
                                      'Sınırlı Teklif',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Instrument Sans',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 24,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Jeton paketin’ni seçerek bonus kazanın ve yeni bölümlerin kilidini açın!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Instrument Sans',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                    SizedBox(height: 24),
                                    // Bonuslar
                                    Container(
                                      width: 354,
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        gradient: RadialGradient(
                                          colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.03)],
                                          center: Alignment.center,
                                          radius: 1.0,
                                        ),
                                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Alacağınız Bonuslar',
                                            style: TextStyle(
                                              fontFamily: 'Instrument Sans',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 14),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              _bonusItem(Icons.diamond, 'Premium Hesap'),
                                              _bonusItem(Icons.people, 'Daha Fazla Eşleşme'),
                                              _bonusItem(Icons.arrow_upward, 'Öne Çıkarma'),
                                              _bonusItem(Icons.favorite, 'Daha Fazla Beğeni'),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 32),
                                    // Jeton paketleri başlık
                                    Text(
                                      'Kilidi açmak için bir jeton paketi seçin',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Instrument Sans',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 24),
                                    // Jeton paketleri
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        _coinOption(
                                          percent: '+10%',
                                          oldCoin: '200',
                                          coin: '300',
                                          price: '₺99,99',
                                          color: [Color(0xFF6F060B), Color(0xFFE50914)],
                                        ),
                                        _coinOption(
                                          percent: '+70%',
                                          oldCoin: '2.000',
                                          coin: '3.375',
                                          price: '₺799,99',
                                          color: [Color(0xFF5949E6), Color(0xFFE50914)],
                                        ),
                                        _coinOption(
                                          percent: '+35%',
                                          oldCoin: '1.000',
                                          coin: '1.350',
                                          price: '₺399,99',
                                          color: [Color(0xFF6F060B), Color(0xFFE50914)],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 32),
                                    // Ana buton
                                    GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        width: 354,
                                        height: 56,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFE50914),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Tüm Jetonları Gör',
                                            style: TextStyle(
                                              fontFamily: 'Instrument Sans',
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Kapatma butonu
                            Positioned(
                              right: 16,
                              top: 16,
                              child: GestureDetector(
                                onTap: _toggleOfferModal,
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.1),
                                    border: Border.all(color: Colors.white.withOpacity(0.5)),
                                    borderRadius: BorderRadius.circular(900),
                                  ),
                                  child: Center(
                                    child: Icon(Icons.close, color: Colors.white, size: 24),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _bonusItem(IconData icon, String title) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Color(0xFF6F060B),
            boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.2), blurRadius: 8, spreadRadius: 0)],
            borderRadius: BorderRadius.circular(900),
          ),
          child: Center(child: Icon(icon, color: Colors.white, size: 28)),
        ),
        SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Instrument Sans',
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _coinOption({
    required String percent,
    required String oldCoin,
    required String coin,
    required String price,
    required List<Color> color,
  }) {
    return Container(
      width: 110,
      height: 186,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: color,
          center: Alignment.topLeft,
          radius: 1.0,
        ),
        border: Border.all(color: Colors.white.withOpacity(0.4)),
        boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.3), blurRadius: 15, spreadRadius: 4)],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 12,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  oldCoin,
                  style: TextStyle(
                    fontFamily: 'Euclid Circular A',
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Colors.white.withOpacity(0.9),
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  coin,
                  style: TextStyle(
                    fontFamily: 'Instrument Sans',
                    fontWeight: FontWeight.w700,
                    fontSize: 32,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Jeton',
                  style: TextStyle(
                    fontFamily: 'Instrument Sans',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 14),
                Container(
                  width: 81,
                  height: 0.5,
                  color: Colors.white.withOpacity(0.1),
                ),
                SizedBox(height: 8),
                Text(
                  price,
                  style: TextStyle(
                    fontFamily: 'Instrument Sans',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Başına haftalık',
                  style: TextStyle(
                    fontFamily: 'Instrument Sans',
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          // Yüzdelik badge
          Positioned(
            top: -10,
            left: (110 - 61) / 2,
            child: Container(
              width: 61,
              height: 23,
              decoration: BoxDecoration(
                color: color.length > 1 ? color[0] : Color(0xFF6F060B),
                boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.2), blurRadius: 8)],
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Text(
                  percent,
                  style: TextStyle(
                    fontFamily: 'Instrument Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
