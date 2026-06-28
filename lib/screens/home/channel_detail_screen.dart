import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/channel.dart';
import 'add_subscriber_screen.dart';
import 'private_chat_screen.dart';

/// Un message du fil : soit un article structuré, soit un simple texte
class _Post {
  final Article? article;
  final String? text;
  final String time;
  const _Post.article(this.article, this.time) : text = null;
  const _Post.text(this.text, this.time) : article = null;
}

class ChannelDetailScreen extends StatefulWidget {
  final Channel channel;
  const ChannelDetailScreen({super.key, required this.channel});

  @override
  State<ChannelDetailScreen> createState() => _ChannelDetailScreenState();
}

class _ChannelDetailScreenState extends State<ChannelDetailScreen> {
  final _msgController = TextEditingController();
  final _scrollController = ScrollController();
  late final List<_Post> _posts;

  @override
  void initState() {
    super.initState();
    _posts = [
      for (final a in widget.channel.articles) _Post.article(a, a.timeAgo),
    ];
  }

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _posts.add(_Post.text(text, 'À l\'instant'));
      _msgController.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _openPrivateChat(Article? article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PrivateChatScreen(
          channel: widget.channel,
          article: article,
        ),
      ),
    );
  }

  void _attach() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Ajouter une photo',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _attachOption(
              sheetContext,
              icon: Icons.photo_camera_rounded,
              label: 'Prendre une photo',
              subtitle: 'Utiliser l\'appareil photo',
            ),
            _attachOption(
              sheetContext,
              icon: Icons.photo_library_rounded,
              label: 'Choisir depuis la galerie',
              subtitle: 'Importer une image existante',
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _attachOption(
    BuildContext sheetContext, {
    required IconData icon,
    required String label,
    required String subtitle,
  }) {
    return ListTile(
      onTap: () {
        Navigator.pop(sheetContext);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(
              label,
              style: const TextStyle(fontFamily: 'Manrope'),
            ),
          ),
        );
      },
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.10),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Manrope',
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontFamily: 'Manrope',
          fontSize: 13,
          color: AppColors.textSecondary,
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.channel;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(c),
      body: Column(
        children: [
          Expanded(
            child: _posts.isEmpty
                ? _emptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    itemCount: _posts.length,
                    itemBuilder: (_, i) => _bubble(c, _posts[i]),
                  ),
          ),
          if (c.isMine) _composer() else _readOnlyBanner(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(Channel c) {
    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: AppColors.textPrimary,
      surfaceTintColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 0,
      shape: const Border(
        bottom: BorderSide(color: AppColors.divider, width: 1),
      ),
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [c.color, c.color.withValues(alpha: 0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(c.avatar, style: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  c.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  c.isMine
                      ? '${c.subscribers} abonnés'
                      : 'par ${c.owner}',
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        if (c.isMine)
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_rounded,
                color: AppColors.primary),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddSubscriberScreen(channel: c),
              ),
            ),
          ),
        IconButton(
          icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _bubble(Channel c, _Post post) {
    // Message texte envoyé → bulle verte à droite (style WhatsApp)
    if (post.article == null) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.78,
          ),
          margin: const EdgeInsets.only(bottom: 12, left: 40),
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(4),
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(18),
            ),
          ),
          child: _textBubble(post.text!, post.time),
        ),
      );
    }
    // Article : dans mon canal → envoyé (vert, à droite)
    //           côté abonné → reçu (blanc, à gauche)
    final sent = c.isMine;
    return Align(
      alignment: sent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.82,
        ),
        margin: EdgeInsets.only(
          bottom: 12,
          left: sent ? 40 : 0,
          right: sent ? 0 : 40,
        ),
        decoration: BoxDecoration(
          color: sent ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(sent ? 18 : 4),
            topRight: Radius.circular(sent ? 4 : 18),
            bottomLeft: const Radius.circular(18),
            bottomRight: const Radius.circular(18),
          ),
          border: sent ? null : Border.all(color: AppColors.divider),
        ),
        child: _articleBubble(c, post.article!, post.time, sent),
      ),
    );
  }

  Widget _articleBubble(Channel c, Article a, String time, bool sent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(sent ? 18 : 4),
            topRight: Radius.circular(sent ? 4 : 18),
          ),
          child: SizedBox(
            height: 170,
            width: double.infinity,
            child: a.imageUrl == null
                ? _thumbPlaceholder(a, c)
                : Image.network(
                    a.imageUrl!,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) =>
                        progress == null ? child : _thumbPlaceholder(a, c),
                    errorBuilder: (_, __, ___) => _thumbPlaceholder(a, c),
                  ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                a.title,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: sent ? Colors.white : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                a.description,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 13,
                  color: sent
                      ? Colors.white.withValues(alpha: 0.8)
                      : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    a.price,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: sent ? AppColors.accentLight : AppColors.accentDark,
                    ),
                  ),
                  const Spacer(),
                  if (sent)
                    _sentMeta(time)
                  else
                    _timeLabel(time),
                ],
              ),
              if (!sent) ...[
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => _openPrivateChat(a),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline_rounded,
                            size: 16, color: Colors.white),
                        SizedBox(width: 6),
                        Text(
                          'Je suis intéressé',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _sentMeta(String time) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          time,
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 11,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(width: 4),
        Icon(
          Icons.done_all_rounded,
          size: 15,
          color: Colors.white.withValues(alpha: 0.7),
        ),
      ],
    );
  }

  Widget _textBubble(String text, String time) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 12, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 15,
              color: Colors.white,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                time,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.done_all_rounded,
                size: 15,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _timeLabel(String time) {
    return Text(
      time,
      style: const TextStyle(
        fontFamily: 'Manrope',
        fontSize: 11,
        color: AppColors.muted,
      ),
    );
  }

  Widget _thumbPlaceholder(Article a, Channel c) {
    return Container(
      color: c.color.withValues(alpha: 0.08),
      alignment: Alignment.center,
      child: Icon(a.icon, size: 44, color: c.color.withValues(alpha: 0.6)),
    );
  }

  Widget _composer() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: AppColors.divider, width: 1),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Bouton +
            GestureDetector(
              onTap: _attach,
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add_rounded,
                    color: Colors.white, size: 24),
              ),
            ),
            const SizedBox(width: 8),
            // Champ texte
            Expanded(
              child: Container(
                constraints: const BoxConstraints(minHeight: 44),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.divider, width: 1.5),
                ),
                child: TextField(
                  controller: _msgController,
                  minLines: 1,
                  maxLines: 4,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                  decoration: const InputDecoration(
                    isCollapsed: true,
                    filled: false,
                    contentPadding: EdgeInsets.symmetric(vertical: 13),
                    hintText: 'Écrire une diffusion...',
                    hintStyle: TextStyle(
                      fontFamily: 'Manrope',
                      color: AppColors.muted,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Bouton envoyer
            GestureDetector(
              onTap: _send,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _msgController.text.trim().isEmpty
                      ? AppColors.muted
                      : AppColors.accent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send_rounded,
                    color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _readOnlyBanner() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: AppColors.divider, width: 1),
          ),
        ),
        child: GestureDetector(
          onTap: () => _openPrivateChat(null),
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat_bubble_outline_rounded,
                    size: 18, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Contacter le vendeur',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.campaign_rounded,
                color: AppColors.muted, size: 34),
          ),
          const SizedBox(height: 16),
          const Text(
            'Aucune diffusion pour le moment',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Écrivez votre première diffusion ci-dessous.',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
