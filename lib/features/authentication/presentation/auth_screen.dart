import 'package:digihealth/features/authentication/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../generated_assets/assets.gen.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _keepSessionActive = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState == AuthStatus.unknown;

    return Scaffold(
      backgroundColor: const Color(0xFF051024),
      body: SafeArea(
        child: SingleChildScrollView(
          // Bounces nicely on iOS, standard scroll on Android
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            // Ensure minimum height is the full screen so it aligns properly
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // 1. The Map Section (Top Half)
                Positioned(
                  top: 20.h,
                  left: 0,
                  right: 0,
                  height: 350.h, // Takes up roughly half the 690 base height
                  child: _buildMapAsset(),
                ),

                // 2. The Login Panel (Overlapping from the bottom)
                Positioned(
                  top: 320.h, // Slightly overlaps the map
                  left: 20.w,
                  right: 20.w,
                  child: _buildLoginPanel(isLoading),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGET EXTRACTS ---

  Widget _buildMapAsset() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      // This is where your glowing map goes.
      // Using a placeholder with a glow effect for now.
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Simulated Map Glow
          Container(
            width: 200.w,
            height: 300.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.cyanAccent.withOpacity(0.15),
                  blurRadius: 60,
                  spreadRadius: 20,
                ),
              ],
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Assets.images.digihealth.image(
                      fit: BoxFit.contain,
                      height: 20.h,
                      color: Colors.cyanAccent),
                  10.horizontalSpace,
                  Assets.images.mediot.image(
                      fit: BoxFit.contain,
                      height: 20.h,
                      color: Colors.cyanAccent),
                ],
              ),
              Assets.images.map.image(fit: BoxFit.contain, height: 250.h),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoginPanel(bool isLoading) {
    return ClipPath(
      clipper: CyberClipper(cutSize: 15.w), // Applies the sci-fi angled corners
      child: Container(
        padding: EdgeInsets.all(10),
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage(Assets.images.loginPanel.path),
        //     fit: BoxFit.contain,
        //   ),
        color: const Color(0xFF081C38).withOpacity(0.85),
        // We use a custom border trick because ClipPath cuts off standard borders
        // ),
        child: Stack(
          children: [
            Image.asset(
              Assets.images.loginPanel.path,
              fit: BoxFit.contain,
              width: double.infinity,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'CONNEXION AU COMPTE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(height: 24.h),

                _buildSciFiTextField(
                  controller: _emailController,
                  hint: 'Email',
                  icon: Icons.mail_outline,
                  enabled: !isLoading,
                ),
                SizedBox(height: 16.h),

                _buildSciFiTextField(
                  controller: _passwordController,
                  hint: 'Mot de passe',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  enabled: !isLoading,
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: isLoading ? null : () {},
                    child: Text(
                      'Mot de passe oublié',
                      style:
                          TextStyle(color: Colors.grey[400], fontSize: 11.sp),
                    ),
                  ),
                ),

                SizedBox(height: 8.h),

                // On a 360 width screen, putting the checkbox and button on the same row
                // might overflow. We stack them vertically for mobile safety.
                Row(
                  children: [
                    SizedBox(
                      height: 24.h,
                      width: 24.w,
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(unselectedWidgetColor: Colors.cyanAccent),
                        child: Checkbox(
                          value: _keepSessionActive,
                          activeColor: Colors.cyanAccent,
                          checkColor: Colors.black,
                          onChanged: isLoading
                              ? null
                              : (val) => setState(
                                  () => _keepSessionActive = val ?? false),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Garder ma session active',
                      style:
                          TextStyle(color: Colors.cyanAccent, fontSize: 11.sp),
                    ),
                  ],
                ),

                SizedBox(height: 24.h),

                // Sci-Fi Login Button
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () => ref.read(authNotifierProvider.notifier).login(
                            _emailController.text,
                            _passwordController.text,
                          ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            4)), // Minor rounding to match inner fields
                  ),
                  child: isLoading
                      ? SizedBox(
                          height: 20.h,
                          width: 20.w,
                          child: const CircularProgressIndicator(
                              color: Colors.black, strokeWidth: 2),
                        )
                      : Text(
                          'CONNEXION',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              fontSize: 14.sp),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSciFiTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      enabled: enabled,
      style: TextStyle(color: Colors.white, fontSize: 14.sp),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.blueGrey[300], fontSize: 14.sp),
        prefixIcon: Icon(icon, color: Colors.cyanAccent, size: 20.sp),
        filled: true,
        fillColor: Colors.transparent,
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.cyan, width: 1)),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.cyanAccent, width: 2)),
        disabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.cyan.withOpacity(0.3), width: 1)),
        contentPadding: EdgeInsets.symmetric(vertical: 14.h),
        isDense: true, // Makes the text field more compact for mobile
      ),
    );
  }
}

class CyberClipper extends CustomClipper<Path> {
  final double cutSize;

  CyberClipper({this.cutSize = 20.0});

  @override
  Path getClip(Size size) {
    final path = Path();

    // Start at top-left, after the cut
    path.moveTo(cutSize, 0);
    // Line to top-right, before the cut
    path.lineTo(size.width - cutSize, 0);
    // Angle down to right edge
    path.lineTo(size.width, cutSize);
    // Line down to bottom-right, before the cut
    path.lineTo(size.width, size.height - cutSize);
    // Angle down to bottom edge
    path.lineTo(size.width - cutSize, size.height);
    // Line to bottom-left, before the cut
    path.lineTo(cutSize, size.height);
    // Angle up to left edge
    path.lineTo(0, size.height - cutSize);
    // Line up to top-left, before the cut
    path.lineTo(0, cutSize);
    // Close the path (angles to starting point)
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
