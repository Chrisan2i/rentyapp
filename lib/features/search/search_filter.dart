// search_filter.dart
import 'package:flutter/material.dart';

class SearchFilter extends StatelessWidget {
  const SearchFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column( // Use a Column to stack the search bar and the filter chip vertically
      crossAxisAlignment: CrossAxisAlignment.start, // Align content to the start (left)
      children: [
        // Search Bar (TextField inside a styled Container)
        Container(
          height: 48, // Standard height for input fields
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05), // Slightly darker background for depth
            borderRadius: BorderRadius.circular(16), // Rounded corners for the search bar
            border: Border.all(color: const Color(0xFF0085FF)), // Distinct blue border as per desired design
          ),
          child: TextField(
            style: const TextStyle(color: Colors.white), // Ensures typed text is white
            decoration: InputDecoration(
              hintText: 'Search for products, categories...', // Placeholder text
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)), // Subtler hint text color
              prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.5)), // Search icon on the left
              suffixIcon: Icon(Icons.menu, color: Colors.white.withOpacity(0.5)), // Menu/filter icon on the right
              border: InputBorder.none, // Removes the default TextField underline border
              contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0), // Adjust text padding inside the field
            ),
            onChanged: (value) {
              // TODO: Implement search logic here (e.g., call a search provider or update state)
              print('Search query: $value');
            },
            onSubmitted: (value) {
              // TODO: Implement action when search is submitted (e.g., perform full search)
              print('Search submitted: $value');
            },
          ),
        ),
        const SizedBox(height: 8), // Small vertical space between the search bar and the filter chip

        // Filter Chip
        Chip(
          label: Row(
            mainAxisSize: MainAxisSize.min, // Ensures the chip only takes up necessary width
            children: [
              Text(
                'Price < \$20/day', // The filter text as seen in the desired image
                style: TextStyle(color: Colors.white.withOpacity(0.8)), // Chip text color
              ),
              const SizedBox(width: 4), // Space between text and the close icon
              Icon(
                Icons.close, // Close icon for removing the filter
                size: 16, // Icon size
                color: Colors.white.withOpacity(0.8), // Icon color
              ),
            ],
          ),
          backgroundColor: const Color(0xFF0085FF).withOpacity(0.2), // Light blue background for the chip
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Rounded corners for the chip
            side: BorderSide(color: const Color(0xFF0085FF).withOpacity(0.5)), // Blue border for the chip
          ),
          onDeleted: () {
            // TODO: Implement logic to remove this specific filter
            print('Filter "Price < \$20/day" removed.');
          },
          deleteIconColor: Colors.transparent, // Hides the default red 'x' icon provided by Chip, as we have a custom one
        ),
      ],
    );
  }
}