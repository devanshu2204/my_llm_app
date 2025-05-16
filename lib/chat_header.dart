import 'package:flutter/material.dart';

class ChatHeader extends StatelessWidget {
  final String botName;
  final bool isDarkMode;
  final VoidCallback? onBackClick;
  final ValueChanged<bool> onToggleDarkMode;

  const ChatHeader({
    super.key,
    required this.botName,
    this.onBackClick,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  size: 18,
                  color: Colors.black, // Hardcode for debugging
                ),
                onPressed: onBackClick,
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    botName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const Text(
                    'Online',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
                size: 16,
                color: isDarkMode ? Colors.blue : Colors.black, // Hardcode for debugging
              ),
              const SizedBox(width: 8),
              Switch(
                value: isDarkMode,
                onChanged: onToggleDarkMode,
                activeColor: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(
                  Icons.more_vert,
                  size: 18,
                  color: Colors.black, // Hardcode for debugging
                ),
                onPressed: () {},
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}