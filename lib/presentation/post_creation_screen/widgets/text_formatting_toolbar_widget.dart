import 'package:emoji_picker_flutter/emoji_picker_flutter.dart' as emoji;
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TextFormattingToolbarWidget extends StatefulWidget {
  final TextEditingController textController;
  final FocusNode focusNode;

  const TextFormattingToolbarWidget({
    Key? key,
    required this.textController,
    required this.focusNode,
  }) : super(key: key);

  @override
  State<TextFormattingToolbarWidget> createState() =>
      _TextFormattingToolbarWidgetState();
}

class _TextFormattingToolbarWidgetState
    extends State<TextFormattingToolbarWidget> {
  bool _showEmojiPicker = false;

  void _insertText(String text) {
    final currentText = widget.textController.text;
    final selection = widget.textController.selection;
    final newText = currentText.replaceRange(
      selection.start,
      selection.end,
      text,
    );

    widget.textController.text = newText;
    widget.textController.selection = TextSelection.collapsed(
      offset: selection.start + text.length,
    );
  }

  void _toggleEmojiPicker() {
    setState(() {
      _showEmojiPicker = !_showEmojiPicker;
    });

    if (_showEmojiPicker) {
      widget.focusNode.unfocus();
    } else {
      widget.focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 6.h,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
            border: Border(
              top: BorderSide(
                color: AppTheme.lightTheme.colorScheme.outline,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              _buildToolbarButton(
                icon: 'format_bold',
                onTap: () => _insertText('**texto em negrito**'),
                tooltip: 'Negrito',
              ),
              _buildToolbarButton(
                icon: 'format_italic',
                onTap: () => _insertText('*texto em itálico*'),
                tooltip: 'Itálico',
              ),
              _buildToolbarButton(
                icon: 'format_list_bulleted',
                onTap: () => _insertText('\n• '),
                tooltip: 'Lista',
              ),
              _buildToolbarButton(
                icon: 'link',
                onTap: () => _insertText('[texto do link](url)'),
                tooltip: 'Link',
              ),
              Spacer(),
              _buildToolbarButton(
                icon: 'emoji_emotions',
                onTap: _toggleEmojiPicker,
                tooltip: 'Emojis',
                isActive: _showEmojiPicker,
              ),
            ],
          ),
        ),
        if (_showEmojiPicker)
          Container(
            height: 30.h,
            child: emoji.EmojiPicker(
              onEmojiSelected: (category, emoji) {
                _insertText(emoji.emoji);
              },
              config: emoji.Config(
                height: 30.h,
                checkPlatformCompatibility: true,
                emojiViewConfig: emoji.EmojiViewConfig(
                  backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                  columns: 7,
                  emojiSizeMax: 28,
                  recentsLimit: 28,
                  noRecents: Text(
                    'Nenhum emoji recente',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                categoryViewConfig: emoji.CategoryViewConfig(
                  backgroundColor:
                      AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                  iconColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  iconColorSelected: AppTheme.lightTheme.colorScheme.primary,
                  indicatorColor: AppTheme.lightTheme.colorScheme.primary,
                ),
                bottomActionBarConfig: emoji.BottomActionBarConfig(
                  backgroundColor:
                      AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                  buttonColor:
                      AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                  buttonIconColor:
                      AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                searchViewConfig: emoji.SearchViewConfig(
                  backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                  buttonIconColor:
                      AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  hintText: 'Buscar emoji...',
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildToolbarButton({
    required String icon,
    required VoidCallback onTap,
    required String tooltip,
    bool isActive = false,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(2.w),
          margin: EdgeInsets.symmetric(horizontal: 1.w),
          decoration: BoxDecoration(
            color: isActive
                ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: icon,
            color: isActive
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
        ),
      ),
    );
  }
}