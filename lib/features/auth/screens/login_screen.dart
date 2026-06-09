import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey       = GlobalKey<FormState>();
  final _emailCtrl     = TextEditingController();
  final _passwordCtrl  = TextEditingController();
  bool _cargando       = false;
  bool _verPassword    = false;
  String? _error;

  final supabase = Supabase.instance.client;

  // ── Login ────────────────────────────────────────────────
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _cargando = true; _error = null; });

    try {
      await supabase.auth.signInWithPassword(
        email:    _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
      );
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on AuthException catch (e) {
      setState(() => _error = _traducirError(e.message));
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  // ── Traducir errores al español ───────────────────────────
  String _traducirError(String mensaje) {
    if (mensaje.contains('Invalid login'))
      return 'Correo o contraseña incorrectos';
    if (mensaje.contains('Email not confirmed'))
      return 'Debes verificar tu correo primero';
    if (mensaje.contains('too many requests'))
      return 'Demasiados intentos. Espera unos minutos';
    return 'Error al iniciar sesión. Intenta de nuevo';
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WeltaColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),

                // ── Logo ──────────────────────────────────
                Row(children: [
                  Icon(Icons.home_repair_service_rounded,
                    color: WeltaColors.accent, size: 40),
                  const SizedBox(width: 10),
                  Text('Welta',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      color: WeltaColors.primary,
                    )),
                ]),

                const SizedBox(height: 8),
                Text('¡Bienvenido de nuevo!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: WeltaColors.primary,
                  )),
                Text('Ingresa con tu cuenta',
                  style: TextStyle(
                    fontSize: 14,
                    color: WeltaColors.gray,
                  )),

                const SizedBox(height: 40),

                // ── Email ─────────────────────────────────
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Correo electrónico',
                    prefixIcon: Icon(Icons.email_outlined,
                      color: WeltaColors.accent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: WeltaColors.accent, width: 2)),
                    filled: true,
                    fillColor: WeltaColors.white,
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty)
                      return 'Ingresa tu correo';
                    if (!v.contains('@'))
                      return 'Correo no válido';
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ── Contraseña ────────────────────────────
                TextFormField(
                  controller: _passwordCtrl,
                  obscureText: !_verPassword,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: Icon(Icons.lock_outline,
                      color: WeltaColors.accent),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _verPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                        color: WeltaColors.gray,
                      ),
                      onPressed: () =>
                        setState(() => _verPassword = !_verPassword),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: WeltaColors.accent, width: 2)),
                    filled: true,
                    fillColor: WeltaColors.white,
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty)
                      return 'Ingresa tu contraseña';
                    if (v.length < 8)
                      return 'Mínimo 8 caracteres';
                    return null;
                  },
                ),

                // ── Olvidé contraseña ─────────────────────
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _olvidoPassword,
                    child: Text('¿Olvidaste tu contraseña?',
                      style: TextStyle(color: WeltaColors.accent)),
                  ),
                ),

                // ── Error ─────────────────────────────────
                if (_error != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: WeltaColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: WeltaColors.error.withOpacity(0.3)),
                    ),
                    child: Row(children: [
                      Icon(Icons.error_outline,
                        color: WeltaColors.error, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(_error!,
                          style: TextStyle(color: WeltaColors.error,
                            fontSize: 13))),
                    ]),
                  ),

                const SizedBox(height: 24),

                // ── Botón Login ───────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _cargando ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: WeltaColors.accent,
                      foregroundColor: WeltaColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: _cargando
                      ? SizedBox(
                          width: 22, height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: WeltaColors.primary))
                      : Text('INGRESAR',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          )),
                  ),
                ),

                const SizedBox(height: 24),

                // ── Ir a Registro ─────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('¿No tienes cuenta? ',
                      style: TextStyle(color: WeltaColors.gray)),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(
                        context, '/register'),
                      child: Text('Regístrate',
                        style: TextStyle(
                          color: WeltaColors.accent,
                          fontWeight: FontWeight.bold,
                        )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Recuperar contraseña ──────────────────────────────────
  Future<void> _olvidoPassword() async {
    if (_emailCtrl.text.trim().isEmpty) {
      setState(() => _error = 'Escribe tu correo primero');
      return;
    }
    try {
      await supabase.auth.resetPasswordForEmail(
        _emailCtrl.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Te enviamos un link para restablecer tu contraseña'),
            backgroundColor: WeltaColors.success,
          ),
        );
      }
    } catch (e) {
      setState(() => _error = 'Error al enviar el correo');
    }
  }
}