import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'home.dart';
import 'services/firebase_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool rememberMe = false;
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _isLogin = true; // true for login, false for register
  late AnimationController _controller;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this, 
      duration: const Duration(seconds: 12)
    )..repeat();
    
    // Check if user is already logged in
    _checkLoginStatus();
  }

  void _checkLoginStatus() {
    if (FirebaseService.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailAuth() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Additional validation
    if (_emailController.text.trim().isEmpty || _passwordController.text.isEmpty) {
      _showError("Please fill in all required fields");
      return;
    }

    if (!_isLogin && _nameController.text.trim().isEmpty) {
      _showError("Please enter your name");
      return;
    }

    // Email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(_emailController.text.trim())) {
      _showError("Please enter a valid email address");
      return;
    }

    // Password validation
    if (!_isLogin && _passwordController.text.length < 6) {
      _showError("Password must be at least 6 characters");
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isLogin) {
        // Login with email and password
        final userCredential = await FirebaseService.signInWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        if (userCredential != null && mounted) {
          _showSuccess("Login successful!");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      } else {
        // Register with email and password
        final userCredential = await FirebaseService.signUpWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          name: _nameController.text.trim(),
        );

        if (userCredential != null && mounted) {
          _showSuccess("Registration successful!");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    try {
      final userCredential = await FirebaseService.signInWithGoogle();
      
      if (userCredential != null && mounted) {
        _showSuccess("Google sign-in successful!");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        _showError("Google sign-in cancelled");
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.hennyPenny(fontSize: 13),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.hennyPenny(fontSize: 13),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFB3E5FC),
              Color.fromARGB(255, 212, 241, 255),
              Color.fromARGB(255, 251, 241, 255),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Orbiting Veggies
              _orbitingVeg("assets/icons/leek.png", radius: 270, angle: 0),
              _orbitingVeg("assets/icons/tomato.png", radius: 270, angle: 60),
              _orbitingVeg("assets/icons/broccoli.png", radius: 270, angle: 120),
              _orbitingVeg("assets/icons/carrots.png", radius: 270, angle: 180),
              _orbitingVeg("assets/icons/grape-fruit.png", radius: 270, angle: 240),
              _orbitingVeg("assets/icons/lettuce.png", radius: 270, angle: 300),

              // Login/Register Form
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Welcome To Fresh Veg",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.hennyPenny(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ).animate().fadeIn(duration: 800.ms).slideY(begin: -0.3),
                        const SizedBox(height: 25),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 196, 238, 255)
                                .withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 12,
                                spreadRadius: 2,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                _isLogin ? "LOGIN" : "REGISTER",
                                style: GoogleFonts.hennyPenny(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ).animate().fadeIn().scale(),
                              const SizedBox(height: 20),
                              _buildTextField(
                                "Email", 
                                _emailController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              if (!_isLogin) ...[
                                _buildTextField(
                                  "Name", 
                                  _nameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your name';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 12),
                              ],
                              _buildTextField(
                                "Password", 
                                _passwordController, 
                                isPassword: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (!_isLogin && value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 15),
                              if (_isLogin)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: rememberMe,
                                            onChanged: (val) {
                                              setState(() {
                                                rememberMe = val ?? false;
                                              });
                                            },
                                            activeColor: Colors.cyan,
                                          ),
                                          Flexible(
                                            child: Text(
                                              "Remember Me",
                                              style: GoogleFonts.hennyPenny(
                                                fontSize: 13,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Forgot password feature coming soon!",
                                              style: GoogleFonts.hennyPenny(),
                                            ),
                                            backgroundColor: Colors.orange,
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Forgot Password?",
                                        style: GoogleFonts.hennyPenny(
                                          fontSize: 12,
                                          color: Colors.blue.shade700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 20),
                              _isLoading
                                  ? const CircularProgressIndicator(color: Colors.cyan)
                                  : ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size.fromHeight(45),
                                        backgroundColor: Colors.cyan,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        elevation: 4,
                                      ),
                                      onPressed: _handleEmailAuth,
                                      child: Text(
                                        _isLogin ? "Login" : "Register",
                                        style: GoogleFonts.hennyPenny(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ).animate().fadeIn().scale(),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  Expanded(child: Divider(color: Colors.grey.shade600)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: Text(
                                      "OR",
                                      style: GoogleFonts.hennyPenny(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(child: Divider(color: Colors.grey.shade600)),
                                ],
                              ),
                              const SizedBox(height: 15),
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(45),
                                  side: const BorderSide(color: Colors.cyan, width: 2),
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: _isLoading ? null : _handleGoogleSignIn,
                                icon: Image.asset(
                                  'assets/icons/google.png',
                                  height: 24,
                                  width: 24,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.g_mobiledata,
                                    color: Colors.cyan,
                                    size: 28,
                                  ),
                                ),
                                label: Text(
                                  "Continue with Google",
                                  style: GoogleFonts.hennyPenny(
                                    color: Colors.cyan,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isLogin = !_isLogin;
                                    _formKey.currentState?.reset();
                                  });
                                },
                                child: Text(
                                  _isLogin 
                                      ? "Don't have an account? Register"
                                      : "Already have an account? Login",
                                  style: GoogleFonts.hennyPenny(
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue.shade700,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 1.seconds).slideY(begin: 0.2),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label, 
    TextEditingController controller, 
    {bool isPassword = false, String? Function(String?)? validator}
  ) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? _obscurePassword : false,
      validator: validator,
      style: GoogleFonts.hennyPenny(
        fontSize: 15,
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.hennyPenny(
          color: Colors.grey.shade700,
        ),
        hintText: "Enter your $label",
        hintStyle: GoogleFonts.hennyPenny(
          color: Colors.grey.shade500,
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.cyan, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        errorStyle: GoogleFonts.hennyPenny(fontSize: 11),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey.shade600,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              )
            : null,
      ),
    );
  }

  Widget _orbitingVeg(String path, {required double radius, required double angle}) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double rotation = 2 * pi * _controller.value + angle * pi / 180;
        final double x = radius * cos(rotation);
        final double y = radius * sin(rotation);

        return Positioned(
          left: MediaQuery.of(context).size.width / 2 + x - 25,
          top: MediaQuery.of(context).size.height / 2 + y - 25,
          child: child!,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image.asset(
            path,
            height: 55,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.green.shade200,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  Icons.eco,
                  color: Colors.green.shade700,
                  size: 30,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}