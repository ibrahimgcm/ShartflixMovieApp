import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/auth_provider.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isChecked = false;
  bool showPassword = false;
  bool showPasswordRepeat = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordRepeatController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final passwordRepeat = _passwordRepeatController.text;
    if (name.isEmpty || email.isEmpty || password.isEmpty || passwordRepeat.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Lütfen tüm alanları doldurun.';
      });
      return;
    }
    if (password != passwordRepeat) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Şifreler eşleşmiyor.';
      });
      return;
    }
    if (!isChecked) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Kullanım koşullarını kabul etmelisiniz.';
      });
      return;
    }
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final error = await authProvider.registerWithEmail(name, email, password);
    setState(() {
      _isLoading = false;
      if (error == null) {
        _successMessage = 'Kayıt başarılı!';
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 76),
              // Logo
              Container(
                width: 78,
                height: 78,
                decoration: BoxDecoration(
                  gradient: const RadialGradient(
                    center: Alignment.topCenter,
                    radius: 1,
                    colors: [Color(0xFFE50914), Color(0xFF7F050B)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(255, 88, 88, 0.25),
                      offset: const Offset(0, 4),
                      blurRadius: 14.2,
                      spreadRadius: -2,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(21.8991),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/shartflix_logo.png',
                    width: 39.75,
                    height: 33.61,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Başlık
              SizedBox(
                width: 256,
                child: Column(
                  children: const [
                    Text(
                      'Hesap Oluştur',
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
                      'Kullanıcı bilgilerini girerek kaydol',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Instrument Sans',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color.fromRGBO(255, 255, 255, 0.9),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Input alanları
              SizedBox(
                width: 354,
                child: Column(
                  children: [
                    _buildInputField(
                      controller: _nameController,
                      icon: Icons.person,
                      hint: 'Kullanıcı Adı',
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(255, 255, 255, 0.5),
                    ),
                    const SizedBox(height: 24),
                    _buildInputField(
                      controller: _emailController,
                      icon: Icons.email,
                      hint: 'E-Posta',
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(255, 255, 255, 0.5),
                    ),
                    const SizedBox(height: 24),
                    _buildInputField(
                      controller: _passwordController,
                      icon: Icons.lock,
                      hint: 'Şifre',
                      isPassword: true,
                      showPassword: showPassword,
                      onEyeTap: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(255, 255, 255, 0.5),
                    ),
                    const SizedBox(height: 24),
                    _buildInputField(
                      controller: _passwordRepeatController,
                      icon: Icons.lock,
                      hint: 'Şifreyi Tekrar Girin',
                      isPassword: true,
                      showPassword: showPasswordRepeat,
                      onEyeTap: () {
                        setState(() {
                          showPasswordRepeat = !showPasswordRepeat;
                        });
                      },
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(255, 255, 255, 0.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Checkbox ve sözleşme
              SizedBox(
                width: 354,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isChecked = !isChecked;
                        });
                      },
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: isChecked ? Color(0xFFE50914) : Color.fromRGBO(255, 255, 255, 0.05),
                          border: Border.all(
                            color: Color.fromRGBO(255, 255, 255, 0.2),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: isChecked
                            ? Icon(Icons.check, color: Colors.white, size: 20)
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Kullanıcı sözleşmesini ',
                              style: TextStyle(
                                fontFamily: 'Instrument Sans',
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: Color.fromRGBO(255, 255, 255, 0.6),
                              ),
                            ),
                            TextSpan(
                              text: 'Okudum ve Kabul ediyorum.',
                              style: TextStyle(
                                fontFamily: 'Instrument Sans',
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(
                              text: ' Bu sözleşmeyi okuyarak devam ediniz lütfen.',
                              style: TextStyle(
                                fontFamily: 'Instrument Sans',
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: Color.fromRGBO(255, 255, 255, 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Kayıt butonu ve hata/başarı mesajı
              SizedBox(
                width: 354,
                child: Column(
                  children: [
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
                    ElevatedButton(
                      onPressed: _isLoading ? null : _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE50914),
                        minimumSize: const Size(354, 56),
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
                              'Kayıt Ol',
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
              const SizedBox(height: 24),
              // Sosyal medya butonları
              SizedBox(
                width: 210,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialButton('assets/google.png'),
                    const SizedBox(width: 15),
                    _buildSocialButton('assets/apple.png'),
                    const SizedBox(width: 15),
                    _buildSocialButton('assets/facebook.png'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Hesabın var mı? Giriş Yap
              SizedBox(
                width: 168,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Hesabın var mı?',
                      style: TextStyle(
                        fontFamily: 'Instrument Sans',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color.fromRGBO(255, 255, 255, 0.8),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Giriş Yap',
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
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required IconData icon,
    required String hint,
    bool isPassword = false,
    bool showPassword = false,
    VoidCallback? onEyeTap,
    FontWeight fontWeight = FontWeight.w400,
    Color color = const Color.fromRGBO(255, 255, 255, 0.5),
    TextEditingController? controller,
  }) {
    return Container(
      width: 354,
      height: 56,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.05),
        border: Border.all(
          color: const Color.fromRGBO(255, 255, 255, 0.2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: isPassword ? !showPassword : false,
              style: TextStyle(
                fontFamily: 'Instrument Sans',
                fontWeight: fontWeight,
                fontSize: 14,
                color: color,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: TextStyle(
                  fontFamily: 'Instrument Sans',
                  fontWeight: fontWeight,
                  fontSize: 14,
                  color: color,
                ),
              ),
            ),
          ),
          if (isPassword)
            GestureDetector(
              onTap: onEyeTap,
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Icon(
                  showPassword ? Icons.visibility : Icons.visibility_off,
                  color: const Color.fromRGBO(255, 255, 255, 0.3),
                  size: 24,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(String assetPath) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.05),
        border: Border.all(
          color: const Color.fromRGBO(255, 255, 255, 0.2),
          width: 1,
        ),
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
