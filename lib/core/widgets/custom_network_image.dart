// lib/core/widgets/custom_network_image.dart

import 'package:flutter/material.dart';

// Definimos los posibles estados de carga de la imagen
enum _ImageStatus { loading, loaded, failed }

class CustomNetworkImage extends StatefulWidget {
  final String imageUrl;
  final Widget Function(BuildContext context)? placeholder;
  final Widget Function(BuildContext context, Object error)? errorWidget;
  final BoxFit? fit;
  final double? width;
  final double? height;

  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    this.placeholder,
    this.errorWidget,
    this.fit,
    this.width,
    this.height,
  });

  @override
  State<CustomNetworkImage> createState() => _CustomNetworkImageState();
}

class _CustomNetworkImageState extends State<CustomNetworkImage> {
  // Guardamos la información de la imagen y su estado
  late ImageStream _imageStream;
  ImageInfo? _imageInfo;
  _ImageStatus _status = _ImageStatus.loading;
  dynamic _error; // Para guardar el error si ocurre

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  // Si la URL de la imagen cambia, necesitamos volver a cargarla
  @override
  void didUpdateWidget(CustomNetworkImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageUrl != oldWidget.imageUrl) {
      _imageStream.removeListener(_createImageStreamListener());
      _loadImage();
    }
  }

  // Creamos un listener que se adjuntará al stream de la imagen
  ImageStreamListener _createImageStreamListener() {
    return ImageStreamListener(
          (ImageInfo imageInfo, bool synchronousCall) {
        // Éxito: La imagen se cargó
        if (mounted) {
          setState(() {
            _imageInfo = imageInfo;
            _status = _ImageStatus.loaded;
          });
        }
      },
      onError: (dynamic error, StackTrace? stackTrace) {
        // Error: Falló la carga (por red, 404, etc.)
        if (mounted) {
          // ... dentro de onError:
          setState(() {
            _error = error;
            _status = _ImageStatus.failed;
          });
        }
      },
    );
  }

  void _loadImage() {
    // Si la URL está vacía, fallamos inmediatamente para no intentar una llamada de red inútil.
    if (widget.imageUrl.isEmpty) {
      if (mounted) {
        setState(() {
          _status = _ImageStatus.failed;
          _error = 'Image URL is empty';
        });
      }
      return;
    }

    // Usamos Image.network(...).image que es un ImageProvider.
    // Este nos da acceso al "stream" de la imagen para escuchar eventos.
    final imageProvider = NetworkImage(widget.imageUrl);

    _imageStream = imageProvider.resolve(const ImageConfiguration());
    _imageStream.addListener(_createImageStreamListener());
  }

  @override
  void dispose() {
    // Es CRUCIAL quitar el listener para evitar fugas de memoria.
    _imageStream.removeListener(_createImageStreamListener());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (_status) {
      case _ImageStatus.loading:
      // Si el usuario proporcionó un widget de placeholder, lo mostramos.
      // Si no, mostramos un CircularProgressIndicator por defecto.
        return widget.placeholder?.call(context) ??
            const Center(child: CircularProgressIndicator(strokeWidth: 2));

      case _ImageStatus.loaded:
      // Si la imagen cargó, la mostramos usando RawImage, que es muy eficiente.
        return RawImage(
          image: _imageInfo!.image,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
        );

      case _ImageStatus.failed:
      // Si falló, mostramos el widget de error del usuario.
      // Si no, un Icono por defecto.
        return widget.errorWidget?.call(context, _error) ??
            const Center(child: Icon(Icons.broken_image_outlined));
    }
  }
}