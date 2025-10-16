import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/category_tags_widget.dart';
import './widgets/photo_attachment_widget.dart';
import './widgets/post_type_selector_widget.dart';
import './widgets/privacy_settings_widget.dart';
import './widgets/text_formatting_toolbar_widget.dart';
import './widgets/urgency_toggle_widget.dart';

class PostCreationScreen extends StatefulWidget {
  const PostCreationScreen({Key? key}) : super(key: key);

  @override
  State<PostCreationScreen> createState() => _PostCreationScreenState();
}

class _PostCreationScreenState extends State<PostCreationScreen>
    with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  String _selectedPostType = 'Ajuda';
  List<XFile> _selectedImages = [];
  List<String> _selectedCategories = [];
  bool _isUrgent = false;
  String _selectedPrivacy = 'community';
  bool _isPublishing = false;
  bool _showKeyboardToolbar = false;

  // Draft auto-save
  String _lastSavedDraft = '';

  // Character limits
  static const int _maxCharacters = 500;

  @override
  void initState() {
    super.initState();
    _textFocusNode.addListener(_onFocusChanged);
    _textController.addListener(_onTextChanged);
    _loadDraft();
  }

  @override
  void dispose() {
    _textFocusNode.removeListener(_onFocusChanged);
    _textController.removeListener(_onTextChanged);
    _textFocusNode.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() {
      _showKeyboardToolbar = _textFocusNode.hasFocus;
    });
  }

  void _onTextChanged() {
    _saveDraft();
  }

  void _loadDraft() {
    // Simulate loading draft from local storage
    // In real implementation, use SharedPreferences or similar
  }

  void _saveDraft() {
    final currentText = _textController.text;
    if (currentText != _lastSavedDraft && currentText.isNotEmpty) {
      _lastSavedDraft = currentText;
      // In real implementation, save to SharedPreferences
    }
  }

  void _clearDraft() {
    _lastSavedDraft = '';
    // In real implementation, clear from SharedPreferences
  }

  String _getPlaceholderText() {
    switch (_selectedPostType) {
      case 'Ajuda':
        return 'Descreva sua necessidade de ajuda. Seja específico sobre o que precisa e quando...';
      case 'Serviço':
        return 'Descreva o serviço que você oferece. Inclua detalhes sobre experiência e disponibilidade...';
      case 'Doação':
        return 'Descreva o que você está doando. Inclua o estado do item e condições para retirada...';
      case 'Troca':
        return 'Descreva o que você quer trocar e o que está procurando em troca...';
      case 'Anúncio':
        return 'Escreva seu anúncio. Seja claro sobre datas, horários e informações importantes...';
      default:
        return 'Escreva sua mensagem para a comunidade...';
    }
  }

  bool _canPublish() {
    final hasText = _textController.text.trim().length >= 10;
    final hasCategory = _selectedCategories.isNotEmpty;
    return hasText && hasCategory && !_isPublishing;
  }

  int _getRemainingCharacters() {
    return _maxCharacters - _textController.text.length;
  }

  Color _getCharacterCountColor() {
    final remaining = _getRemainingCharacters();
    if (remaining < 50) return AppTheme.lightTheme.colorScheme.error;
    if (remaining < 100) return AppTheme.lightTheme.colorScheme.secondary;
    return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
  }

  Future<void> _publishPost() async {
    if (!_canPublish()) return;

    setState(() {
      _isPublishing = true;
    });

    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      // Clear draft after successful publication
      _clearDraft();

      // Show success message
      Fluttertoast.showToast(
        msg: "Post publicado com sucesso!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        textColor: Colors.white,
      );

      // Navigate back to community feed
      Navigator.pushReplacementNamed(context, '/community-feed-screen');
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Erro ao publicar. Tente novamente.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        textColor: Colors.white,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPublishing = false;
        });
      }
    }
  }

  void _showDiscardDialog() {
    if (_textController.text.trim().isEmpty && _selectedImages.isEmpty) {
      Navigator.pop(context);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Descartar post?',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Text(
            'Seu rascunho será salvo automaticamente. Você pode continuar editando mais tarde.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Continuar Editando'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(
                'Descartar',
                style: TextStyle(color: AppTheme.lightTheme.colorScheme.error),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  PostTypeSelectorWidget(
                    selectedType: _selectedPostType,
                    onTypeSelected: (type) {
                      setState(() {
                        _selectedPostType = type;
                        _selectedCategories.clear();
                        _isUrgent = false;
                      });
                    },
                  ),
                  _buildTextArea(),
                  PhotoAttachmentWidget(
                    selectedImages: _selectedImages,
                    onImagesChanged: (images) {
                      setState(() {
                        _selectedImages = images;
                      });
                    },
                  ),
                  CategoryTagsWidget(
                    postType: _selectedPostType,
                    selectedCategories: _selectedCategories,
                    onCategoriesChanged: (categories) {
                      setState(() {
                        _selectedCategories = categories;
                      });
                    },
                  ),
                  UrgencyToggleWidget(
                    isUrgent: _isUrgent,
                    onUrgencyChanged: (urgent) {
                      setState(() {
                        _isUrgent = urgent;
                      });
                    },
                    postType: _selectedPostType,
                  ),
                  PrivacySettingsWidget(
                    selectedPrivacy: _selectedPrivacy,
                    onPrivacyChanged: (privacy) {
                      setState(() {
                        _selectedPrivacy = privacy;
                      });
                    },
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
          if (_showKeyboardToolbar)
            TextFormattingToolbarWidget(
              textController: _textController,
              focusNode: _textFocusNode,
            ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      elevation: 1,
      leading: IconButton(
        onPressed: _showDiscardDialog,
        icon: CustomIconWidget(
          iconName: 'close',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 24,
        ),
      ),
      title: Text(
        'Novo Post',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 4.w),
          child: ElevatedButton(
            onPressed: _canPublish() ? _publishPost : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _canPublish()
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.3),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: _isPublishing
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'Publicar',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextArea() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              minHeight: 20.h,
              maxHeight: 40.h,
            ),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _textFocusNode.hasFocus
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.outline,
                width: _textFocusNode.hasFocus ? 2 : 1,
              ),
            ),
            child: TextField(
              controller: _textController,
              focusNode: _textFocusNode,
              maxLength: _maxCharacters,
              maxLines: null,
              textInputAction: TextInputAction.newline,
              style: AppTheme.lightTheme.textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: _getPlaceholderText(),
                hintStyle: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.6),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(4.w),
                counterText: '',
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mínimo 10 caracteres',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: _textController.text.length >= 10
                      ? AppTheme.lightTheme.colorScheme.tertiary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '${_getRemainingCharacters()} restantes',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: _getCharacterCountColor(),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}