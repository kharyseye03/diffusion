import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/channel.dart';

class CreateCanalScreen extends StatefulWidget {
  const CreateCanalScreen({super.key});

  @override
  State<CreateCanalScreen> createState() => _CreateCanalScreenState();
}

class _CreateCanalScreenState extends State<CreateCanalScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();

  static const _emojis = ['📱', '⚡', '🎧', '💎', '🛍️', '🔌', '📲', '⌚', '💻'];
  static const _colors = [
    Color(0xFF0F3D33),
    Color(0xFFA8862F),
    Color(0xFF1C5A4C),
    Color(0xFF2E7D5B),
    Color(0xFFB23B3B),
    Color(0xFF3B5BB2),
  ];

  String _emoji = '📱';
  Color _color = const Color(0xFF0F3D33);

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  bool get _isValid => _nameController.text.trim().isNotEmpty;

  void _create() {
    final channel = Channel(
      name: _nameController.text.trim(),
      owner: 'Vous',
      avatar: _emoji,
      color: _color,
      subscribers: 0,
      isMine: true,
      articles: const [],
    );
    Navigator.pop(context, channel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Créer un canal',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          // Aperçu
          Center(
            child: Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_color, _color.withValues(alpha: 0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _color.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(_emoji, style: const TextStyle(fontSize: 40)),
            ),
          ),
          const SizedBox(height: 28),

          _label('Nom du canal'),
          _field(_nameController, 'Ex : Dakar Phones Premium'),
          const SizedBox(height: 20),

          _label('Choisir une icône'),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _emojis.map((e) {
              final selected = e == _emoji;
              return GestureDetector(
                onTap: () => setState(() => _emoji = e),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : const Color(0xFFF5F5F3),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: selected ? AppColors.primary : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(e, style: const TextStyle(fontSize: 24)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          _label('Couleur'),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _colors.map((col) {
              final selected = col == _color;
              return GestureDetector(
                onTap: () => setState(() => _color = col),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: col,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected ? AppColors.accent : Colors.transparent,
                      width: 3,
                    ),
                  ),
                  child: selected
                      ? const Icon(Icons.check_rounded,
                          color: Colors.white, size: 20)
                      : null,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          _label('Description (optionnel)'),
          _field(_descController, 'À propos de ce canal...', maxLines: 3),
          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isValid ? _create : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor:
                    AppColors.primary.withValues(alpha: 0.25),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Créer le canal',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Manrope',
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _field(TextEditingController controller, String hint,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      onChanged: (_) => setState(() {}),
      style: const TextStyle(
        fontFamily: 'Manrope',
        fontSize: 15,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: 'Manrope',
          color: AppColors.muted,
        ),
        filled: true,
        fillColor: const Color(0xFFF5F5F3),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }
}
