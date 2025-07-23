import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/model/collection.dart';
import '../../../data/model/shot.dart';

class CollectionDetailPage extends StatelessWidget {
  final Collection collection;

  const CollectionDetailPage({super.key, required this.collection});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.pop(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Center(
                      child: Text(
                        collection.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FutureBuilder<List<Shot>>(
                  future: _fetchCollectionShots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Image.asset('assets/images/img_18.png', width: 200, height: 200),
                      );
                    }
                    final shots = snapshot.data!;
                    return GridView.builder(
                      itemCount: shots.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.75,
                      ),
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            shots[index].imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Image.asset(
                              'assets/images/img_18.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Shot>> _fetchCollectionShots() async {
    List<Shot> shots = [];
    for (String shotId in collection.imageIds) {
      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('shots')
            .doc(shotId)
            .get();
        if (doc.exists) {
          shots.add(Shot.fromMap(doc.data() as Map<String, dynamic>, doc.id));
        }
      } catch (e) {
        print('Error fetching shot $shotId: $e');
      }
    }
    return shots;
  }
}