import 'package:flutter/material.dart';

Widget activityCard(String title, List<ActivityItem> activities) {
  return Card(
    color: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    elevation: 0.5,
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 10),
          ..._buildActivityList(activities),
        ],
      ),
    ),
  );
}

List<Widget> _buildActivityList(List<ActivityItem> activities) {
  final List<Widget> widgets = [];

  for (int i = 0; i < activities.length; i++) {
    final activity = activities[i];

    widgets.add(
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Colored dot
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              color: activity.dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),

          // Activity text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.description,
                  style: const TextStyle(fontSize: 14),
                ),
                if (activity.timestamp != null)
                  Text(
                    activity.timestamp!,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
              ],
            ),
          ),
        ],
      ),
    );

    // Divider except after last item
    if (i < activities.length - 1) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Divider(color: Colors.grey.shade300, thickness: 0.8),
        ),
      );
    }
  }

  return widgets;
}

class ActivityItem {
  final String description;
  final String? timestamp;
  final Color dotColor;

  ActivityItem({
    required this.description,
    this.timestamp,
    required this.dotColor,
  });
}
