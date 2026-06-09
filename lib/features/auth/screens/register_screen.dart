import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey        = GlobalKey<FormState>();
  final _nombreCtrl     = TextEditingController();
  final _emailCtrl      = TextEditingController();
  final _passwordCtrl   = TextEditingController();
  final _confirmCtrl    = TextEditingController();
  bool _cargando        = false;
  bool _verPassword     = false;
  bool _aceptoTerminos  = false;
  String? _error;

  final supabase = Supabase.instance.client;


Future<void> _registrar() async {
  if (!_formKey.currentState!.validate()) return;
  if (!_aceptoTerminos) {
    setState(() => _error = 'Debes aceptar los términos y condiciones');
    return;
  }
  setState(() { _cargando = true; _error = null; });

  try {
    print('=== Intentando registrar: ${_emailCtrl.text.trim()}');
    
    final response = await supabase.auth.signUp(
      email:    _emailCtrl.text.trim(),
      password: _passwordCtrl.text.trim(),
      data: {
        'nombre': _nombreCtrl.text.trim(),
      },
    );

    print('=== Respuesta: ${response.user}');
    print('=== Session: ${response.session}');

    if (response.user != null && mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
          title: Row(children: [
            Icon(Icons.mark_email_read,
              color: WeltaColors.accent, size: 28),
            const SizedBox(width: 10),
            const Text('¡Casi listo!',
              style: TextStyle(fontWeight: FontWeight.bold)),
          ]),
          content: Text(
            'Te enviamos un correo a:\n\n'
            '${_emailCtrl.text.trim()}\n\n'
            'Ábrelo y haz clic en el enlace.',
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: WeltaColors.accent,
                foregroundColor: WeltaColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Entendido',
                style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    } else {
      print('=== Usuario null en respuesta');
      setState(() => _error = 'No se pudo crear la cuenta');
    }
  } on AuthException catch (e) {
    print('=== AuthException: ${e.message} | statusCode: ${e.statusCode}');
    setState(() => _error = _traducirError(e.message));
  } catch (e) {
    print('=== Error general: $e');
    setState(() => _error = 'Error inesperado: $e');
  } finally {
    if (mounted) setState(() => _cargando = false);
  }
}

  String _traducirError(String mensaje) {
    if (mensaje.contains('already registered'))
      return 'Este correo ya tiene una cuenta registrada';
    if (mensaje.contains('Password should be'))
      return 'La contraseña debe tener mínimo 8 caracteres';
    if (mensaje.contains('Unable to validate'))
      return 'Correo no válido';
    return 'Error al registrarse. Intenta de nuevo';
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
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
                const SizedBox(height: 40),

                // ── Header ────────────────────────────────
                Row(children: [
                  Icon(Icons.home_repair_service_rounded,
                    color: WeltaColors.accent, size: 36),
                  const SizedBox(width: 8),
                  Text('Welta',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: WeltaColors.primary,
                    )),
                ]),
                const SizedBox(height: 8),
                Text('Crea tu cuenta',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: WeltaColors.primary,
                  )),
                Text('Es gratis y solo toma un minuto',
                  style: TextStyle(
                    fontSize: 14,
                    color: WeltaColors.gray,
                  )),

                const SizedBox(height: 32),

                // ── Nombre ────────────────────────────────
                TextFormField(
                  controller: _nombreCtrl,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Nombre completo',
                    prefixIcon: Icon(Icons.person_outline,
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
                    if (v == null || v.trim().isEmpty)
                      return 'Ingresa tu nombre';
                    if (v.trim().length < 3)
                      return 'Nombre muy corto';
                    return null;
                  },
                ),

                const SizedBox(height: 14),

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
                    if (!v.contains('@') || !v.contains('.'))
                      return 'Correo no válido';
                    return null;
                  },
                ),

                const SizedBox(height: 14),

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
                        color: WeltaColors.gray),
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
                    helperText:
                      'Mínimo 8 caracteres, una mayúscula y un número',
                    helperStyle: TextStyle(fontSize: 11),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty)
                      return 'Ingresa una contraseña';
                    if (v.length < 8)
                      return 'Mínimo 8 caracteres';
                    if (!v.contains(RegExp(r'[A-Z]')))
                      return 'Debe tener al menos una mayúscula';
                    if (!v.contains(RegExp(r'[0-9]')))
                      return 'Debe tener al menos un número';
                    return null;
                  },
                ),

                const SizedBox(height: 14),

                // ── Confirmar contraseña ──────────────────
                TextFormField(
                  controller: _confirmCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirmar contraseña',
                    prefixIcon: Icon(Icons.lock_outline,
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
                      return 'Confirma tu contraseña';
                    if (v != _passwordCtrl.text)
                      return 'Las contraseñas no coinciden';
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ── Términos y condiciones ─────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _aceptoTerminos,
                      activeColor: WeltaColors.accent,
                      onChanged: (v) =>
                        setState(() => _aceptoTerminos = v ?? false),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: WeltaColors.gray,
                              fontSize: 13),
                            children: [
                              TextSpan(text: 'Acepto los '),
                              TextSpan(text: 'Términos y Condiciones',
                                style: TextStyle(
                                  color: WeltaColors.accent,
                                  fontWeight: FontWeight.bold)),
                              TextSpan(text: ' y la '),
                              TextSpan(text: 'Política de Privacidad',
                                style: TextStyle(
                                  color: WeltaColors.accent,
                                  fontWeight: FontWeight.bold)),
                              TextSpan(text: ' de Welta'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // ── Error ─────────────────────────────────
                if (_error != null) ...[
                  const SizedBox(height: 8),
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
                          style: TextStyle(
                            color: WeltaColors.error,
                            fontSize: 13))),
                    ]),
                  ),
                ],

                const SizedBox(height: 24),

                // ── Botón Registrar ───────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _cargando ? null : _registrar,
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
                      : Text('CREAR CUENTA',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          )),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Ir a Login ────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('¿Ya tienes cuenta? ',
                      style: TextStyle(color: WeltaColors.gray)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text('Inicia sesión',
                        style: TextStyle(
                          color: WeltaColors.accent,
                          fontWeight: FontWeight.bold,
                        )),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}