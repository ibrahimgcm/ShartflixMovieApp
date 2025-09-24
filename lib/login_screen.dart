import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'register_screen.dart'; // RegisterScreen için import eklendi
import 'package:provider/provider.dart';
import 'core/auth_provider.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool showPassword = false;
  bool showError = false;

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });
    final email = emailController.text.trim();
    final password = passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Lütfen e-posta ve şifreyi girin.';
      });
      return;
    }
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final error = await authProvider.loginWithEmail(email, password);
    setState(() {
      _isLoading = false;
      if (error == null) {
        _successMessage = 'Giriş başarılı!';
        Future.microtask(() {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        });
      } else {
        _errorMessage = error;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final contentWidth = screenWidth > 370 ? 354.0 : screenWidth * 0.95;
    final smallContentWidth = screenWidth > 270 ? 256.0 : screenWidth * 0.7;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 32),
                Container(
                  width: contentWidth,
                  height: 180,
                  child: Lottie.asset(
                    'assets/Artboard_1.json',
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 24),
                Container(
                  width: 78,
                  height: 78,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [Color(0xFFE50914), Color(0xFF7F050B)],
                      center: Alignment.topCenter,
                      radius: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(255, 88, 88, 0.25),
                        blurRadius: 14.2,
                        offset: Offset(0, 4),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(143.748),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/shartflix_logo.png',
                      width: 52,
                      height: 44,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Container(
                  width: smallContentWidth,
                  child: Column(
                    children: [
                      Text(
                        'Giriş Yap',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Instrument Sans',
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          height: 29 / 24,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Kullanıcı bilgilerinle giriş yap',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Instrument Sans',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          height: 17 / 14,
                          color: Colors.white.withAlpha(230),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 36),
                Container(
                  width: contentWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // E-posta input
                      Container(
                        width: contentWidth,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(13),
                          border: Border.all(color: Colors.white.withAlpha(51)),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Icon(Icons.mail, color: Colors.white, size: 24),
                            ),
                            Expanded(
                              child: TextField(
                                controller: emailController,
                                style: TextStyle(
                                  fontFamily: 'Instrument Sans',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'E-Posta',
                                  hintStyle: TextStyle(
                                    fontFamily: 'Instrument Sans',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      // Şifre input
                      Container(
                        width: contentWidth,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(13),
                          border: Border.all(color: Colors.white.withAlpha(51)),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Icon(Icons.lock, color: Colors.white, size: 24),
                            ),
                            Expanded(
                              child: TextField(
                                controller: passwordController,
                                obscureText: !showPassword,
                                style: TextStyle(
                                  fontFamily: 'Instrument Sans',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Şifre',
                                  hintStyle: TextStyle(
                                    fontFamily: 'Instrument Sans',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Icon(
                                  showPassword ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.white.withAlpha(77),
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      // Hata ve başarı mesajı
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ),
                      if (_successMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            _successMessage!,
                            style: const TextStyle(color: Colors.green, fontSize: 14),
                          ),
                        ),
                      // Giriş yap butonu
                      ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE50914),
                          minimumSize: Size(contentWidth, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Text(
                                'Giriş Yap',
                                style: TextStyle(
                                  fontFamily: 'Instrument Sans',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                // Sosyal medya butonları
                Container(
                  width: contentWidth * 0.6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialButton('assets/google.png'),
                      SizedBox(width: 15),
                      _socialButton('assets/apple.png'),
                      SizedBox(width: 15),
                      _socialButton('assets/facebook.png'),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                // Kayıt Ol linki
                Container(
                  width: contentWidth * 0.53,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Bir hesabın yok mu?',
                        style: TextStyle(
                          fontFamily: 'Instrument Sans',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.white.withAlpha(204),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegisterScreen()),
                          );
                        },
                        child: Text(
                          'Kayıt Ol',
                          style: TextStyle(
                            fontFamily: 'Instrument Sans',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialButton(String assetPath) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(13),
        border: Border.all(color: Colors.white.withAlpha(51)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Image.asset(
          assetPath,
          width: 24,
          height: 24,
        ),
      ),
    );
  }
}
