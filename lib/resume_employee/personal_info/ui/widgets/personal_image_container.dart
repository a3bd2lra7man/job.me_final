import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:job_me/_shared/api/entities/image_file.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/widgets/image_picker.dart';

class ImageContainer extends StatefulWidget {
  final String? imageUrl;
  final double height;
  final double width;
  final Function(ImageFile)? onImageSelected;

  const ImageContainer({
    super.key,
    this.imageUrl,
    this.onImageSelected,
    this.height = 160,
    this.width = 160,
  });

  @override
  State<ImageContainer> createState() => _ImageContainerState();
}

class _ImageContainerState extends State<ImageContainer> {
  ImageFile? memoryImage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        memoryImage != null
            ? Container(
                height: widget.height,
                width: widget.height,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: MemoryImage(memoryImage!.bytes),
                  ),
                ),
              )
            : widget.imageUrl != null
                ? SizedBox(
                    height: widget.height,
                    width: widget.height,
                    child: CachedNetworkImage(
                      imageUrl: widget.imageUrl!,
                      imageBuilder: (context, imageProvider) => Container(
                        height: widget.height,
                        width: widget.height,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: imageProvider,
                          ),
                        ),
                      ),
                    ),
                  )
                : Icon(
                    Icons.account_circle,
                    size: widget.height,
                    color: AppColors.grey.withOpacity(.7),
                  ),
        if (widget.onImageSelected != null)
          Positioned(
            bottom: 28,
            left: memoryImage != null || widget.imageUrl != null ? -10 : 10,
            child: GestureDetector(
              onTap: () async {
                await pickImage((image) {
                  memoryImage = image;
                  widget.onImageSelected!(image);
                  setState(() {});
                });
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
                child: Icon(
                  Icons.add_circle_outline_rounded,
                  size: 40,
                  color: AppColors.darkGrey,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
