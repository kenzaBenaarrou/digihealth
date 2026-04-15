/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/background.png
  AssetGenImage get background =>
      const AssetGenImage('assets/images/background.png');

  /// File path: assets/images/circles.png
  AssetGenImage get circles => const AssetGenImage('assets/images/circles.png');

  /// File path: assets/images/consultation_logo.png
  AssetGenImage get consultationLogo =>
      const AssetGenImage('assets/images/consultation_logo.png');

  /// File path: assets/images/cs.png
  AssetGenImage get cs => const AssetGenImage('assets/images/cs.png');

  /// File path: assets/images/cu.png
  AssetGenImage get cu => const AssetGenImage('assets/images/cu.png');

  /// File path: assets/images/diabete.png
  AssetGenImage get diabete => const AssetGenImage('assets/images/diabete.png');

  /// File path: assets/images/digihealth.png
  AssetGenImage get digihealth =>
      const AssetGenImage('assets/images/digihealth.png');

  /// File path: assets/images/digihealth_logo.png
  AssetGenImage get digihealthLogo =>
      const AssetGenImage('assets/images/digihealth_logo.png');

  /// File path: assets/images/hta.png
  AssetGenImage get hta => const AssetGenImage('assets/images/hta.png');

  /// File path: assets/images/kids.png
  AssetGenImage get kids => const AssetGenImage('assets/images/kids.png');

  /// File path: assets/images/life_signal.png
  AssetGenImage get lifeSignal =>
      const AssetGenImage('assets/images/life_signal.png');

  /// File path: assets/images/login_panel.png
  AssetGenImage get loginPanel =>
      const AssetGenImage('assets/images/login_panel.png');

  /// File path: assets/images/map.png
  AssetGenImage get map => const AssetGenImage('assets/images/map.png');

  /// File path: assets/images/mediot.png
  AssetGenImage get mediot => const AssetGenImage('assets/images/mediot.png');

  /// File path: assets/images/pni.png
  AssetGenImage get pni => const AssetGenImage('assets/images/pni.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    background,
    circles,
    consultationLogo,
    cs,
    cu,
    diabete,
    digihealth,
    digihealthLogo,
    hta,
    kids,
    lifeSignal,
    loginPanel,
    map,
    mediot,
    pni,
  ];
}

class $AssetsSvgGen {
  const $AssetsSvgGen();

  /// File path: assets/svg/cancer_col.svg
  SvgGenImage get cancerCol => const SvgGenImage('assets/svg/cancer_col.svg');

  /// File path: assets/svg/cancer_sein.svg
  SvgGenImage get cancerSein => const SvgGenImage('assets/svg/cancer_sein.svg');

  /// File path: assets/svg/cardiologist.svg
  SvgGenImage get cardiologist =>
      const SvgGenImage('assets/svg/cardiologist.svg');

  /// File path: assets/svg/consultation_generale.svg
  SvgGenImage get consultationGenerale =>
      const SvgGenImage('assets/svg/consultation_generale.svg');

  /// File path: assets/svg/dermatologist.svg
  SvgGenImage get dermatologist =>
      const SvgGenImage('assets/svg/dermatologist.svg');

  /// File path: assets/svg/diabete.svg
  SvgGenImage get diabete => const SvgGenImage('assets/svg/diabete.svg');

  /// File path: assets/svg/endocrinologist.svg
  SvgGenImage get endocrinologist =>
      const SvgGenImage('assets/svg/endocrinologist.svg');

  /// File path: assets/svg/gynecologist.svg
  SvgGenImage get gynecologist =>
      const SvgGenImage('assets/svg/gynecologist.svg');

  /// File path: assets/svg/hta.svg
  SvgGenImage get hta => const SvgGenImage('assets/svg/hta.svg');

  /// File path: assets/svg/nephrologist.svg
  SvgGenImage get nephrologist =>
      const SvgGenImage('assets/svg/nephrologist.svg');

  /// File path: assets/svg/ophthalmologist.svg
  SvgGenImage get ophthalmologist =>
      const SvgGenImage('assets/svg/ophthalmologist.svg');

  /// File path: assets/svg/orl.svg
  SvgGenImage get orl => const SvgGenImage('assets/svg/orl.svg');

  /// File path: assets/svg/pediatrician.svg
  SvgGenImage get pediatrician =>
      const SvgGenImage('assets/svg/pediatrician.svg');

  /// File path: assets/svg/prise_encharge.svg
  SvgGenImage get priseEncharge =>
      const SvgGenImage('assets/svg/prise_encharge.svg');

  /// File path: assets/svg/pulmonologist.svg
  SvgGenImage get pulmonologist =>
      const SvgGenImage('assets/svg/pulmonologist.svg');

  /// File path: assets/svg/soins_infirmier.svg
  SvgGenImage get soinsInfirmier =>
      const SvgGenImage('assets/svg/soins_infirmier.svg');

  /// File path: assets/svg/tele_expertise.svg
  SvgGenImage get teleExpertise =>
      const SvgGenImage('assets/svg/tele_expertise.svg');

  /// File path: assets/svg/urgence.svg
  SvgGenImage get urgence => const SvgGenImage('assets/svg/urgence.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
    cancerCol,
    cancerSein,
    cardiologist,
    consultationGenerale,
    dermatologist,
    diabete,
    endocrinologist,
    gynecologist,
    hta,
    nephrologist,
    ophthalmologist,
    orl,
    pediatrician,
    priseEncharge,
    pulmonologist,
    soinsInfirmier,
    teleExpertise,
    urgence,
  ];
}

class Assets {
  const Assets._();

  static const String aEnv = '.env';
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsSvgGen svg = $AssetsSvgGen();

  /// List of all assets
  static List<String> get values => [aEnv];
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size, this.flavors = const {}});

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class SvgGenImage {
  const SvgGenImage(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = false;

  const SvgGenImage.vec(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter:
          colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
