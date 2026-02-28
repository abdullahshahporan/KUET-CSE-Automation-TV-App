import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../theme/tv_theme.dart';

/// Horizontal "Special Updates" bar — shows urgent/important items
/// in card-style like a broadcast channel's breaking-news strip.
class SpecialUpdatesBar extends StatefulWidget {
  final List<Announcement> updates;

  const SpecialUpdatesBar({super.key, required this.updates});

  @override
  State<SpecialUpdatesBar> createState() => _SpecialUpdatesBarState();
}

class _SpecialUpdatesBarState extends State<SpecialUpdatesBar>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  Timer? _timer;
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();

    if (widget.updates.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 5), (_) {
        _fadeController.reverse().then((_) {
          if (!mounted) return;
          setState(() {
            _currentIndex = (_currentIndex + 1) % widget.updates.length;
          });
          _fadeController.forward();
        });
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.updates.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 52,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            TVTheme.surfaceVariant,
            TVTheme.surface.withValues(alpha: 0.95),
          ],
        ),
        border: const Border(
          top: BorderSide(color: TVTheme.border, width: 0.5),
          bottom: BorderSide(color: TVTheme.border, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          // ── "SPECIAL UPDATE" label ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [TVTheme.specialBlue, Color(0xFF0066CC)],
              ),
              boxShadow: [
                BoxShadow(
                  color: TVTheme.specialBlue.withValues(alpha: 0.3),
                  blurRadius: 12,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Row(
              children: [
                Icon(Icons.bolt, color: Colors.white, size: 16),
                SizedBox(width: 6),
                Text(
                  'SPECIAL UPDATE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),

          // ── Cycling content ──
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: FadeTransition(
                opacity: _fadeAnim,
                child: _buildUpdateContent(widget.updates[_currentIndex]),
              ),
            ),
          ),

          // ── Counter ──
          if (widget.updates.length > 1)
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  widget.updates.length > 5 ? 5 : widget.updates.length,
                  (i) => Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == _currentIndex
                          ? TVTheme.specialBlue
                          : TVTheme.border,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUpdateContent(Announcement item) {
    return Row(
      children: [
        // Type badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: _typeColor(item.type).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: _typeColor(item.type).withValues(alpha: 0.4),
            ),
          ),
          child: Text(
            item.displayType,
            style: TextStyle(
              color: _typeColor(item.type),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            item.title,
            style: const TextStyle(
              color: TVTheme.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            item.content,
            style: const TextStyle(
              color: TVTheme.textSecondary,
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Color _typeColor(AnnouncementType type) {
    switch (type) {
      case AnnouncementType.classTest:
        return TVTheme.typeClassTest;
      case AnnouncementType.assignment:
        return TVTheme.typeAssignment;
      case AnnouncementType.notice:
        return TVTheme.typeNotice;
      case AnnouncementType.event:
        return TVTheme.typeEvent;
      case AnnouncementType.labTest:
        return TVTheme.typeLabTest;
      case AnnouncementType.quiz:
        return TVTheme.typeQuiz;
      case AnnouncementType.other:
        return TVTheme.textSecondary;
    }
  }
}
