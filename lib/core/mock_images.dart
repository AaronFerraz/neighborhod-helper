import 'package:flutter/material.dart';

/// Helper para fornecer imagens mockadas sem URL.
/// Cada chamada retorna uma imagem diferente usando avatars customizados ou placeholders.
class MockImages {
  static const String _defaultProfileImage = 'images/profile_default.png';

  // Lista de avatares mockados que o app pode usar
  static const List<String> profileAvatars = [
    'images/profile_avatar_1.png',
    'images/profile_avatar_2.png',
    'images/profile_avatar_3.png',
    'images/profile_avatar_4.png',
  ];

  /// Retorna um widget de imagem mockada para perfil
  /// Se não houver imagem local, mostra um avatar padrão colorido
  static Widget buildProfileImage({
    required double size,
    String? imageUrl,
    String? semanticLabel,
  }) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      // Se houver URL, tenta carregar (para posts com imagens reais)
      return ClipOval(
        child: Image.network(
          imageUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultAvatar(size: size);
          },
        ),
      );
    }

    // Se não houver URL, mostra avatar padrão
    return _buildDefaultAvatar(size: size);
  }

  /// Avatar padrão quando não há imagem
  static Widget _buildDefaultAvatar({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getRandomAvatarColor(),
      ),
      child: Center(
        child: Text(
          '👤',
          style: TextStyle(fontSize: size * 0.5),
        ),
      ),
    );
  }

  /// Retorna uma cor de avatar baseada em hash
  static Color _getRandomAvatarColor() {
    final colors = [
      Colors.blue.shade200, // Azul claro
      Colors.green.shade200, // Verde claro
      Colors.purple.shade200, // Roxo claro
      Colors.orange.shade200, // Laranja claro
      Colors.amber.shade200, // Âmbar claro
    ];
    return colors[DateTime.now().millisecond % colors.length];
  }

  /// Retorna um placeholder mockado para imagens de posts
  static Widget buildPostImage({
    required double width,
    required double height,
    String? imageUrl,
  }) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildImagePlaceholder(width: width, height: height);
        },
      );
    }

    return _buildImagePlaceholder(width: width, height: height);
  }

  static Widget _buildImagePlaceholder({
    required double width,
    required double height,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image,
              size: height * 0.2,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 8),
            Text(
              'Imagem não disponível',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
