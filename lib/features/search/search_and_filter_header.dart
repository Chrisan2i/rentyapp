// lib/features/search/widgets/search_and_filter_header.dart

import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';

class SearchAndFilterHeader extends StatefulWidget {
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onFilterTapped;

  const SearchAndFilterHeader({
    super.key,
    required this.onSearchChanged,
    required this.onFilterTapped,
  });

  @override
  State<SearchAndFilterHeader> createState() => _SearchAndFilterHeaderState();
}

class _SearchAndFilterHeaderState extends State<SearchAndFilterHeader> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Escucha los cambios en el TextField para mostrar/ocultar el botón de limpiar.
    _controller.addListener(() {
      setState(() {}); // Reconstruye para actualizar el icono de sufijo
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Campo de búsqueda expandido
        Expanded(
          child: TextField(
            controller: _controller,
            onChanged: widget.onSearchChanged, // Llama al callback en cada cambio
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
              hintText: 'Search for products...',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.white.withOpacity(0.7),
              ),
              // Muestra un botón para limpiar el texto solo si hay texto escrito
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                icon: Icon(Icons.clear, color: Colors.white.withOpacity(0.7)),
                onPressed: () {
                  _controller.clear();
                  widget.onSearchChanged(''); // Notifica que la búsqueda se limpió
                },
              )
                  : null,
              filled: true,
              fillColor: AppColors.surface, // Un color de superficie sutil
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none, // Sin borde visible por defecto
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Botón de filtro
        InkWell(
          onTap: widget.onFilterTapped,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Icon(
              Icons.filter_list_rounded,
              color: AppColors.primary, // Usa tu color primario para destacar
              size: 24,
            ),
          ),
        ),
      ],
    );
  }
}