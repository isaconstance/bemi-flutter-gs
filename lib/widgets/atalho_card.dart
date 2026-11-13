import 'package:flutter/material.dart';

class AtalhoCard extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final VoidCallback onTap;

  const AtalhoCard({
    super.key,
    required this.icone,
    required this.titulo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFFFFAF2),
      elevation: 3,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(26),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icone,
                size: 36,
                color: const Color(0xFF286448),
              ),
              const SizedBox(height: 12),
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF292F29),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
