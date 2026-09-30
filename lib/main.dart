import 'package:flutter/material.dart';

void main() {
  runApp(const CampusOpportunitiesApp());
}

class CampusOpportunitiesApp extends StatelessWidget {
  const CampusOpportunitiesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Campus Opportunities',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const OpportunitiesPage(),
    );
  }
}

class OpportunitiesPage extends StatefulWidget {
  const OpportunitiesPage({super.key});

  @override
  State<OpportunitiesPage> createState() => _OpportunitiesPageState();
}

class _OpportunitiesPageState extends State<OpportunitiesPage> {
  String selectedCategory = 'All';
  String searchText = '';

  // List of opportunities
  final List<Map<String, String>> opportunities = [
    {
      'title': 'Software Engineering Internship',
      'type': 'Internship',
      'deadline': 'Apply before October 15',
      'icon': 'work',
    },
    {
      'title': 'Technology Scholarship',
      'type': 'Scholarship',
      'deadline': 'Apply before October 20',
      'icon': 'school',
    },
    {
      'title': 'Flutter Development Workshop',
      'type': 'Workshop',
      'deadline': 'Saturday, October 10',
      'icon': 'phone',
    },
    {
      'title': 'Innovation Challenge',
      'type': 'Competition',
      'deadline': 'Apply before October 25',
      'icon': 'lightbulb',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Filter opportunities according to search and category
    final filteredOpportunities = opportunities.where((opportunity) {
      final matchesCategory =
          selectedCategory == 'All' || opportunity['type'] == selectedCategory;

      final matchesSearch = opportunity['title']!.toLowerCase().contains(
        searchText.toLowerCase(),
      );

      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      // ---------------- APP BAR ----------------
      appBar: AppBar(
        title: const Text(
          'Campus Opportunities',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      // ---------------- BODY ----------------
      body: Column(
        children: [
          // ---------------- SEARCH BAR ----------------
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search opportunities...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),

              // Update search when user types
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
          ),

          // ---------------- CATEGORY FILTERS ----------------
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _categoryButton('All'),
                _categoryButton('Internship'),
                _categoryButton('Scholarship'),
                _categoryButton('Workshop'),
                _categoryButton('Competition'),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // ---------------- OPPORTUNITIES LIST ----------------
          Expanded(
            child: filteredOpportunities.isEmpty
                ? const Center(
                    child: Text(
                      'No opportunities found.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredOpportunities.length,

                    itemBuilder: (context, index) {
                      final opportunity = filteredOpportunities[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,

                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),

                          // ---------------- ICON ----------------
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.shade50,
                            child: Icon(
                              _getIcon(opportunity['icon']!),
                              color: Colors.blue,
                            ),
                          ),

                          // ---------------- TITLE ----------------
                          title: Text(
                            opportunity['title']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          // ---------------- DETAILS ----------------
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              '${opportunity['type']} • '
                              '${opportunity['deadline']}',
                            ),
                          ),

                          // ---------------- ARROW ----------------
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                          ),

                          // ---------------- CLICK ----------------
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'You selected ${opportunity['title']}',
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      // ---------------- ADD BUTTON ----------------
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Add opportunity feature coming soon!'),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // ==========================================================
  // CATEGORY BUTTON
  // ==========================================================

  Widget _categoryButton(String category) {
    final bool isSelected = selectedCategory == category;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(category),
        selected: isSelected,

        onSelected: (selected) {
          setState(() {
            selectedCategory = category;
          });
        },
      ),
    );
  }

  // ==========================================================
  // OPPORTUNITY ICONS
  // ==========================================================

  IconData _getIcon(String icon) {
    switch (icon) {
      case 'work':
        return Icons.work;

      case 'school':
        return Icons.school;

      case 'phone':
        return Icons.phone_android;

      case 'lightbulb':
        return Icons.lightbulb;

      default:
        return Icons.info;
    }
  }
}
