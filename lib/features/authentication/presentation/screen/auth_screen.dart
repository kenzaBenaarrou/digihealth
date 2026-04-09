import 'package:digihealth/features/authentication/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../generated_assets/assets.gen.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _emailController = TextEditingController(text: "m.benouda");
  final _passwordController = TextEditingController(text: r'7642$%#19');
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.status == AuthStatus.loading;

    return Scaffold(
      backgroundColor: const Color(0xFF051024),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // 1. The Map Section (Top Half)
              SizedBox(
                height: 380.h, // Takes up roughly half the 690 base height
                child: _buildMapAsset(),
              ),

              // 2. The Login Panel (Overlapping from the bottom)
              SizedBox(
                height: 230.h, // Base height for the login panel
                child: _buildLoginPanel(isLoading),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET EXTRACTS ---

  Widget _buildMapAsset() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      // This is where your glowing map goes.
      // Using a placeholder with a glow effect for now.
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Simulated Map Glow
          Container(
            width: 220.w,
            height: 320.h,
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Assets.images.digihealth.image(
                    fit: BoxFit.contain,
                    height: 20.h,
                    color: Colors.cyanAccent,
                  ),
                  10.horizontalSpace,
                  Assets.images.mediot.image(
                    fit: BoxFit.contain,
                    height: 20.h,
                    color: Colors.cyanAccent,
                  ),
                ],
              ),
              30.verticalSpace,
              Assets.images.map.image(
                fit: BoxFit.cover,
                height: 250.h,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoginPanel(bool isLoading) {
    return Stack(
      children: [
        Image.asset(
          Assets.images.loginPanel.path,
          fit: BoxFit.contain,
          width: double.infinity,
          // height: 260.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 33.h),
                child: Text(
                  'CONNEXION AU COMPTE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              5.verticalSpace,
              _buildSciFiTextField(
                controller: _emailController,
                hint: 'Email',
                icon: Icons.mail_outline,
                enabled: isLoading,
              ),
              5.verticalSpace,
              _buildSciFiTextField(
                controller: _passwordController,
                hint: 'Mot de passe',
                icon: Icons.lock_outline,
                isPassword: true,
                enabled: isLoading,
              ),
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size(50.w, 20.h),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: isLoading ? null : () {},
                  child: Text(
                    'Mot de passe oublié',
                    style: TextStyle(color: Colors.grey[400], fontSize: 9.sp),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.007),
              Padding(
                padding: EdgeInsets.only(left: 35.w),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: isLoading
                          ? null
                          : () => ref
                              .read(keepSessionActiveProvider.notifier)
                              .toggle(),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 8.5.h,
                            width: 9.w,
                            decoration: BoxDecoration(
                              color: ref.watch(keepSessionActiveProvider)
                                  ? Colors.cyanAccent
                                  : Colors.transparent,
                              border: Border.all(
                                color: Colors.cyanAccent,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: ref.watch(keepSessionActiveProvider)
                                ? Icon(
                                    Icons.check,
                                    size: 6.sp,
                                    color: Colors.black,
                                  )
                                : null,
                          ),
                          4.horizontalSpace,
                          Text(
                            'Garder ma session active',
                            style: TextStyle(
                                color: Colors.cyanAccent, fontSize: 5.9.sp),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 30.w),
                      child: ClipPath(
                        clipper: DoubleCutClipper(),
                        child: GestureDetector(
                          onTap: isLoading
                              ? null
                              : () =>
                                  ref.read(authNotifierProvider.notifier).login(
                                        _emailController.text,
                                        _passwordController.text,
                                      ),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            width: 170.w,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF00FFDD), // bright cyan
                                  Color(0xFF00C4B4), // slightly deeper teal
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF00FFDD).withOpacity(0.6),
                                  blurRadius: 16.sp,
                                  spreadRadius: 2.sp,
                                  offset: Offset(0, 5.h),
                                ),
                              ],
                            ),
                            child: Center(
                              child: isLoading
                                  ? SizedBox(
                                      height: 15.h,
                                      width: 15.w,
                                      child: const CircularProgressIndicator(
                                          color: Colors.white, strokeWidth: 2),
                                    )
                                  : Text(
                                      "CONNEXION",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
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
      obscureText: isPassword ? _obscurePassword : false,
      enabled: enabled,
      style: TextStyle(color: Colors.white, fontSize: 14.sp),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.blueGrey[300], fontSize: 14.sp),
        prefixIcon: Icon(icon, color: Colors.cyanAccent, size: 20.sp),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.cyanAccent,
                  size: 20.sp,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              )
            : null,

        filled: true,
        fillColor: Colors.transparent,
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.cyan, width: 1)),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.cyanAccent, width: 2)),
        disabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.cyan.withOpacity(0.3), width: 1)),
        contentPadding: EdgeInsets.symmetric(vertical: 8.h),
        isDense: true, // Makes the text field more compact for mobile
      ),
    );
  }
}

class DoubleCutClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    const double cut = 28.0; // How deep the cut is (adjust this value)

    // Start from top left - no cut
    path.moveTo(0, 0);

    // Top line to top right - no cut
    path.lineTo(size.width, 0);

    // Right edge down, stopping before the bottom cut
    path.lineTo(size.width, size.height - cut);

    // Diagonal cut to bottom right corner
    path.lineTo(size.width - cut, size.height);

    // Bottom edge to left side, stopping before the left cut
    path.lineTo(cut, size.height);

    // Diagonal cut up the left side
    path.lineTo(0, size.height - cut);

    // Left edge back to top
    path.lineTo(0, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
