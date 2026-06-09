import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _paginaActual = 0;
  final user = Supabase.instance.client.auth.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WeltaColors.background,
      body: SafeArea(
        child: Column(
          children: [

            // ── Header ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Icon(Icons.home_repair_service_rounded,
                      color: WeltaColors.accent, size: 30),
                    const SizedBox(width: 6),
                    Text('Welta',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: WeltaColors.primary,
                      )),
                  ]),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: WeltaColors.accent,
                    child: Icon(Icons.person,
                      color: WeltaColors.primary, size: 22),
                  ),
                ],
              ),
            ),

            // ── Saludo ───────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '¡Hola! ¿Listo para tu Welta?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: WeltaColors.primary,
                  )),
              ),
            ),

            // ── Barra de búsqueda ─────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: WeltaColors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: Row(children: [
                  Icon(Icons.search, color: WeltaColors.gray),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Buscar un trámite o servicio...',
                      style: TextStyle(
                        color: WeltaColors.gray,
                        fontSize: 14,
                      )),
                  ),
                  Icon(Icons.mic_rounded, color: WeltaColors.accent),
                ]),
              ),
            ),

            // ── Categorías ────────────────────────────────
            SizedBox(
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
                children: [
                  _buildCategoria('Trámites',
                    Icons.receipt_long, true),
                  _buildCategoria('Aseo',
                    Icons.cleaning_services, false),
                  _buildCategoria('Reparaciones',
                    Icons.build, false),
                  _buildCategoria('Mensajería',
                    Icons.directions_bike, false),
                ],
              ),
            ),

            // ── Mapa placeholder ──────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    color: const Color(0xFFE8F0E8),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.map_rounded,
                            size: 64, color: WeltaColors.gray),
                          const SizedBox(height: 8),
                          Text('Mapa próximamente',
                            style: TextStyle(color: WeltaColors.gray)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── Botón PEDIR AYUDA ─────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WeltaColors.accent,
                    foregroundColor: WeltaColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: const Text('PEDIR AYUDA',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    )),
                ),
              ),
            ),
          ],
        ),
      ),

      // ── Bottom Navigation ─────────────────────────────
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _paginaActual,
        onTap: (i) => setState(() => _paginaActual = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: WeltaColors.white,
        selectedItemColor: WeltaColors.accent,
        unselectedItemColor: WeltaColors.gray,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600, fontSize: 11),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded), label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_rounded), label: 'Historial'),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card_rounded), label: 'Pagos'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded), label: 'Perfil'),
        ],
      ),
    );
  }

  // ── Widget de categoría ───────────────────────────────
  Widget _buildCategoria(String nombre, IconData icono, bool activo) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(
          horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: activo ? WeltaColors.accent : WeltaColors.primary,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icono,
              color: activo ? WeltaColors.primary : WeltaColors.white,
              size: 26),
            const SizedBox(height: 4),
            Text(nombre,
              style: TextStyle(
                color: activo
                  ? WeltaColors.primary
                  : WeltaColors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              )),
          ],
        ),
      ),
    );
  }
}