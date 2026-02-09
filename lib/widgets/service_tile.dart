import 'package:flutter/material.dart';
import '../models/service_item.dart';

class ServiceTile extends StatefulWidget {
  final ServiceItem service;
  final VoidCallback? onTap;

  const ServiceTile({
    super.key,
    required this.service,
    this.onTap,
  });

  @override
  State<ServiceTile> createState() => _ServiceTileState();
}

class _ServiceTileState extends State<ServiceTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap ??
            () {
              Navigator.pushNamed(context, widget.service.route);
            },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          transform: _hover
              ? (Matrix4.identity()..scale(1.05))
              : Matrix4.identity(),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _hover
                  ? theme.colorScheme.primary
                  : Colors.white12,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_hover ? 0.4 : 0.25),
                blurRadius: _hover ? 16 : 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ICON (PNG / SVG compatible later)
              Image.asset(
                widget.service.icon,
                height: 28,
                width: 28,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 10),

              // TITLE
              Text(
                widget.service.title,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.75),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
