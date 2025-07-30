import 'package:appoint/features/search/models/search_result.dart';
import 'package:flutter/material.dart';

class SearchResultCard extends StatelessWidget {
  const SearchResultCard({
    required this.result,
    super.key,
    this.onTap,
  });

  final SearchResult result;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Card(
        elevation: 2,
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                _buildImage(),
                const SizedBox(width: 16),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitle(),
                      const SizedBox(height: 4),
                      _buildDescription(),
                      const SizedBox(height: 8),
                      _buildMetadata(),
                    ],
                  ),
                ),

                // Action button
                _buildActionButton(),
              ],
            ),
          ),
        ),
      );

  Widget _buildImage() => ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[200],
          ),
          child: result.imageUrl.isNotEmpty
              ? Image.network(
                  result.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildPlaceholderIcon(),
                )
              : _buildPlaceholderIcon(),
        ),
      );

  Widget _buildPlaceholderIcon() {
    IconData iconData;
    Color iconColor;

    switch (result.type) {
      case 'business':
        iconData = Icons.business;
        iconColor = Colors.blue;
      case 'service':
        iconData = Icons.miscellaneous_services;
        iconColor = Colors.green;
      case 'user':
        iconData = Icons.person;
        iconColor = Colors.orange;
      default:
        iconData = Icons.search;
        iconColor = Colors.grey;
    }

    return Icon(
      iconData,
      color: iconColor,
      size: 30,
    );
  }

  Widget _buildTitle() => Row(
        children: [
          Expanded(
            child: Text(
              result.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (result.rating > 0) ...[
            const SizedBox(width: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star,
                  size: 16,
                  color: Colors.amber[600],
                ),
                const SizedBox(width: 4),
                Text(
                  result.rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      );

  Widget _buildDescription() => Text(
        result.description,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );

  Widget _buildMetadata() {
    final metadataWidgets = <Widget>[];

    // Type badge
    metadataWidgets.add(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _getTypeColor().withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          _getTypeLabel(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: _getTypeColor(),
          ),
        ),
      ),
    );

    // Distance
    if (result.distance != null) {
      metadataWidgets.add(const SizedBox(width: 8));
      metadataWidgets.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_on,
              size: 14,
              color: Colors.grey[500],
            ),
            const SizedBox(width: 4),
            Text(
              '${result.distance!.toStringAsFixed(1)} km',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    // Price
    if (result.price != null) {
      metadataWidgets.add(const SizedBox(width: 8));
      metadataWidgets.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.attach_money,
              size: 14,
              color: Colors.grey[500],
            ),
            const SizedBox(width: 4),
            Text(
              '\$${result.price!.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      );
    }

    // Availability
    if (result.availability != null) {
      metadataWidgets.add(const SizedBox(width: 8));
      metadataWidgets.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              result.availability! ? Icons.check_circle : Icons.cancel,
              size: 14,
              color: result.availability! ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 4),
            Text(
              result.availability! ? 'Available' : 'Unavailable',
              style: TextStyle(
                fontSize: 12,
                color: result.availability! ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      );
    }

    return Wrap(
      children: metadataWidgets,
    );
  }

  Widget _buildActionButton() {
    IconData iconData;
    String tooltip;

    switch (result.type) {
      case 'business':
        iconData = Icons.visibility;
        tooltip = 'View Business';
      case 'service':
        iconData = Icons.book_online;
        tooltip = 'Book Service';
      case 'user':
        iconData = Icons.person_add;
        tooltip = 'View Profile';
      default:
        iconData = Icons.arrow_forward;
        tooltip = 'View Details';
    }

    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(iconData),
        onPressed: onTap,
        color: Colors.grey[600],
      ),
    );
  }

  Color _getTypeColor() {
    switch (result.type) {
      case 'business':
        return Colors.blue;
      case 'service':
        return Colors.green;
      case 'user':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getTypeLabel() {
    switch (result.type) {
      case 'business':
        return 'Business';
      case 'service':
        return 'Service';
      case 'user':
        return 'User';
      default:
        return 'Other';
    }
  }
}
