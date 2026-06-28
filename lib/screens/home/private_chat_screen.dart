import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/channel.dart';

class _Msg {
  final String? text;
  final Article? article;
  final bool fromMe;
  final String time;
  const _Msg.text(this.text, {required this.fromMe, required this.time})
      : article = null;
  const _Msg.article(this.article, {required this.fromMe, required this.time})
      : text = null;
}

/// Conversation privée entre l'abonné (nous) et le vendeur d'un canal.
class PrivateChatScreen extends StatefulWidget {
  final Channel channel;
  final Article? article;
  const PrivateChatScreen({super.key, required this.channel, this.article});

  @override
  State<PrivateChatScreen> createState() => _PrivateChatScreenState();
}

class _PrivateChatScreenState extends State<PrivateChatScreen> {
  final _msgController = TextEditingController();
  final _scrollController = ScrollController();
  final List<_Msg> _msgs = [];

  static const _replies = [
    'Oui, toujours disponible ✅',
    'Je peux vous faire un bon prix 😊',
    'Vous êtes sur Dakar ? Livraison possible.',
    'Parfait, je vous réserve l\'article.',
  ];
  int _replyIndex = 0;

  @override
  void initState() {
    super.initState();
    final a = widget.article;
    if (a != null) {
      _msgs.add(_Msg.article(a, fromMe: true, time: 'À l\'instant'));
      _msgs.add(_Msg.text(
        'Bonjour, je suis intéressé par « ${a.title} ». Est-il toujours disponible ?',
        fromMe: true,
        time: 'À l\'instant',
      ));
      _scheduleSellerReply(
          'Oui, toujours disponible ✅ Vous pouvez passer commande.');
    }
  }

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
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

  void _scheduleSellerReply(String text) {
    Future.delayed(const Duration(milliseconds: 1100), () {
      if (!mounted) return;
      setState(() {
        _msgs.add(_Msg.text(text, fromMe: false, time: 'À l\'instant'));
      });
      _scrollToBottom();
    });
  }

  void _send() {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _msgs.add(_Msg.text(text, fromMe: true, time: 'À l\'instant'));
      _msgController.clear();
    });
    _scrollToBottom();
    _scheduleSellerReply(_replies[_replyIndex % _replies.length]);
    _replyIndex++;
  }

  String get _initials {
    final parts = widget.channel.owner.trim().split(' ');
    return parts.map((w) => w.isEmpty ? '' : w[0]).take(2).join();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.channel;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
              child: Text(
                _initials,
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    c.owner,
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
                    c.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
      ),
      body: Column(
        children: [
          // Bandeau confiance
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: AppColors.accent.withValues(alpha: 0.08),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_rounded,
                    size: 13, color: AppColors.accentDark),
                const SizedBox(width: 6),
                Text(
                  'Conversation privée avec le vendeur',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accentDark.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              itemCount: _msgs.length,
              itemBuilder: (_, i) => _bubble(c, _msgs[i]),
            ),
          ),
          _composer(),
        ],
      ),
    );
  }

  Widget _bubble(Channel c, _Msg msg) {
    final align = msg.fromMe ? Alignment.centerRight : Alignment.centerLeft;
    if (msg.article != null) {
      return Align(
        alignment: align,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.divider),
          ),
          child: _articleCard(c, msg.article!),
        ),
      );
    }
    // Message texte
    final me = msg.fromMe;
    return Align(
      alignment: align,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        margin: EdgeInsets.only(
          bottom: 12,
          left: me ? 40 : 0,
          right: me ? 0 : 40,
        ),
        padding: const EdgeInsets.fromLTRB(14, 10, 12, 8),
        decoration: BoxDecoration(
          color: me ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(me ? 18 : 4),
            bottomRight: Radius.circular(me ? 4 : 18),
          ),
          border: me ? null : Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              msg.text!,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 15,
                height: 1.35,
                color: me ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  msg.time,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 11,
                    color: me
                        ? Colors.white.withValues(alpha: 0.7)
                        : AppColors.muted,
                  ),
                ),
                if (me) ...[
                  const SizedBox(width: 4),
                  Icon(
                    Icons.done_all_rounded,
                    size: 15,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _articleCard(Channel c, Article a) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: SizedBox(
            height: 120,
            width: double.infinity,
            child: a.imageUrl == null
                ? Container(
                    color: c.color.withValues(alpha: 0.08),
                    alignment: Alignment.center,
                    child: Icon(a.icon,
                        size: 40, color: c.color.withValues(alpha: 0.6)),
                  )
                : Image.network(
                    a.imageUrl!,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) =>
                        progress == null
                            ? child
                            : Container(color: c.color.withValues(alpha: 0.08)),
                    errorBuilder: (context, error, stack) => Container(
                      color: c.color.withValues(alpha: 0.08),
                      alignment: Alignment.center,
                      child: Icon(a.icon,
                          size: 40, color: c.color.withValues(alpha: 0.6)),
                    ),
                  ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                a.title,
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                a.price,
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.accentDark,
                ),
              ),
            ],
          ),
        ),
      ],
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
                    hintText: 'Écrire au vendeur...',
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
}
