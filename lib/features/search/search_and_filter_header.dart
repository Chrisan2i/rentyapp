// lib/features/search/widgets/search_and_filter_header.dart

import 'dart:async'; // Necesario para usar el Timer para el debounce
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
  Timer? _debounce; // El timer para gestionar el debounce

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      // Reconstruye el widget para mostrar/ocultar el botón de limpiar
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel(); // Cancela el timer al destruir el widget para evitar memory leaks
    _controller.dispose();
    super.dispose();
  }

  /// Función que implementa el debounce.
  /// Espera a que el usuario deje de escribir por 500ms antes de llamar a onSearchChanged.
  void _onSearchChangedWithDebounce(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onSearchChanged(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Campo de búsqueda expandido
        Expanded(
          child: TextField(
            controller: _controller,
            // AHORA: Llama a la función con debounce en lugar de directamente
            onChanged: _onSearchChangedWithDebounce,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
              hintText: 'Search for products...',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.white.withOpacity(0.7),
              ),
              // El botón para limpiar el texto aparece condicionalmente
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                icon: Icon(Icons.clear, color: Colors.white.withOpacity(0.7)),
                onPressed: () {
                  // Limpiar el texto no necesita debounce, debe ser inmediato
                  if (_debounce?.isActive ?? false) _debounce!.cancel();
                  _controller.clear();
                  widget.onSearchChanged(''); // Notifica que la búsqueda se limpió
                },
              )
                  : null,
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
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
            child: const Icon(
              Icons.filter_list_rounded,
              color: AppColors.primary,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }
}