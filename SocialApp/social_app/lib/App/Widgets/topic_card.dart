import 'dart:math' as math;
import 'dart:ui'; 
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app/app/utils/assets_manage.dart';

class TopicCard extends StatelessWidget {
  final String imagePath; 
  final String? overlayImagePath; 
  final String title;
  final bool alignLeft;

  const TopicCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.alignLeft,
    this.overlayImagePath, 
  });

  @override
  Widget build(BuildContext context) {
    final overlay = overlayImagePath ?? imagePath;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 140,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AssetsManager.showImage(imagePath, fit: BoxFit.cover),

            Opacity(
              opacity: 0.5,

              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                child: Transform.rotate(
                  angle: math.pi,
                  child: AssetsManager.showImage(overlay, fit: BoxFit.cover),
                ),
              ),
            ),

            Align(
              alignment:
                  alignLeft ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                width: 140,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin:
                        alignLeft
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                    end:
                        alignLeft
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                    colors: const [Colors.black54, Colors.transparent],
                  ),
                ),
              ),
            ),

            Positioned.fill(
              child: Align(
                alignment:
                    alignLeft ? Alignment.centerLeft : Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    title,
                    textAlign: alignLeft ? TextAlign.left : TextAlign.right,
                    style: GoogleFonts.manrope(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
