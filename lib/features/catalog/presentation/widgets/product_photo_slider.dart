import 'package:flutter/material.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/shared/shared.dart';
import 'package:agrifober_resellers/features/catalog/domain/domain.dart';
import 'package:agrifober_resellers/features/catalog/presentation/widgets/product_card.dart';

/// Edge-to-edge white block of the product screen (product shots are on
/// white): swipe through [Product.images], dots and a "2 / 4" counter when
/// there are several, tap to open them full screen.
class ProductPhotoSlider extends StatefulWidget {
  const ProductPhotoSlider({
    super.key,
    required this.product,
    this.height = 300,
  });

  final Product product;
  final double height;

  @override
  State<ProductPhotoSlider> createState() => _ProductPhotoSliderState();
}

class _ProductPhotoSliderState extends State<ProductPhotoSlider> {
  final _controller = PageController();
  int _page = 0;

  List<String> get _images => widget.product.images;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openFullScreen() {
    if (_images.isEmpty) return;
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => _PhotoViewer(images: _images, initialPage: _page),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final photoSize = widget.height - 40;
    final several = _images.length > 1;

    return Container(
      color: AppColors.white,
      height: widget.height,
      width: double.infinity,
      child: Stack(
        children: [
          if (_images.isEmpty)
            Center(child: ProductImage(product: product, size: photoSize))
          else
            PageView.builder(
              controller: _controller,
              itemCount: _images.length,
              onPageChanged: (page) => setState(() => _page = page),
              itemBuilder: (context, index) => GestureDetector(
                onTap: _openFullScreen,
                child: Center(
                  child: ProductImage(
                    product: product,
                    url: _images[index],
                    size: photoSize,
                  ),
                ),
              ),
            ),
          if (product.unitMargin != null)
            Positioned(
              top: AppSpacing.base,
              left: AppSpacing.base,
              child: MarginChip(product: product, compact: true),
            ),
          if (several) ...[
            Positioned(
              top: AppSpacing.base,
              right: AppSpacing.base,
              child: _Counter(page: _page, count: _images.length),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: AppSpacing.sm,
              child: _Dots(page: _page, count: _images.length),
            ),
          ],
        ],
      ),
    );
  }
}

class _Counter extends StatelessWidget {
  const _Counter({required this.page, required this.count, this.dark = false});

  final int page;
  final int count;

  /// Light text on the full-screen viewer's black background.
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: dark
            ? AppColors.white.withValues(alpha: 0.15)
            : AppColors.black.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppRadius.circle),
      ),
      child: TextUI(
        '${page + 1} / $count',
        style: CustomTextStyle(
          fontSize: AppFontSize.xs,
          fontWeight: AppFontWeight.medium,
          color: dark ? AppColors.white : AppColors.black54,
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.page, required this.count});

  final int page;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 6,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: i == page ? 18 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: i == page
                  ? AppColors.primary
                  : AppColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppRadius.circle),
            ),
          ),
      ],
    );
  }
}

/// Full-screen photos on black: swipe between them, pinch to zoom. Swiping
/// is paused while a photo is zoomed so panning moves the photo instead.
class _PhotoViewer extends StatefulWidget {
  const _PhotoViewer({required this.images, required this.initialPage});

  final List<String> images;
  final int initialPage;

  @override
  State<_PhotoViewer> createState() => _PhotoViewerState();
}

class _PhotoViewerState extends State<_PhotoViewer> {
  late final PageController _controller;
  late int _page;
  bool _zoomed = false;

  @override
  void initState() {
    super.initState();
    _page = widget.initialPage;
    _controller = PageController(initialPage: widget.initialPage);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            physics: _zoomed
                ? const NeverScrollableScrollPhysics()
                : const PageScrollPhysics(),
            itemCount: widget.images.length,
            onPageChanged: (page) => setState(() => _page = page),
            itemBuilder: (context, index) => _ZoomablePhoto(
              url: widget.images[index],
              onZoomChanged: (zoomed) {
                if (zoomed != _zoomed) setState(() => _zoomed = zoomed);
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xs),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: AppColors.white),
                    tooltip: 'Fermer',
                  ),
                  const Spacer(),
                  if (widget.images.length > 1)
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.xs),
                      child: _Counter(
                        page: _page,
                        count: widget.images.length,
                        dark: true,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ZoomablePhoto extends StatefulWidget {
  const _ZoomablePhoto({required this.url, required this.onZoomChanged});

  final String url;
  final ValueChanged<bool> onZoomChanged;

  @override
  State<_ZoomablePhoto> createState() => _ZoomablePhotoState();
}

class _ZoomablePhotoState extends State<_ZoomablePhoto> {
  final _transform = TransformationController();

  @override
  void dispose() {
    _transform.dispose();
    super.dispose();
  }

  void _reportZoom() {
    widget.onZoomChanged(_transform.value.getMaxScaleOnAxis() > 1.01);
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: _transform,
      minScale: 1,
      maxScale: 4,
      onInteractionEnd: (_) => _reportZoom(),
      child: Center(
        child: ImageUI.network(
          url: widget.url,
          fit: BoxFit.contain,
          placeholder: const Center(
            child: CircularProgressIndicator(color: AppColors.white),
          ),
          errorWidget: Center(
            child: AppIcons.boxRR(color: AppColors.white, size: 48),
          ),
        ),
      ),
    );
  }
}
