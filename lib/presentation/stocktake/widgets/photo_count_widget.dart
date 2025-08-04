import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/stock/stock_take.dart';
import '../stocktake_view_model.dart';

class PhotoCountWidget extends ConsumerStatefulWidget {
  final StockTakeItem item;
  final Function(int count, XFile photo)? onPhotoCountComplete;

  const PhotoCountWidget({
    Key? key,
    required this.item,
    this.onPhotoCountComplete,
  }) : super(key: key);

  @override
  ConsumerState<PhotoCountWidget> createState() => _PhotoCountWidgetState();
}

class _PhotoCountWidgetState extends ConsumerState<PhotoCountWidget> {
  final ImagePicker _picker = ImagePicker();
  XFile? _photo;
  final TextEditingController _countController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    if (widget.item.countedQuantity != null) {
      _countController.text = widget.item.countedQuantity.toString();
    }
    if (widget.item.notes != null) {
      _notesController.text = widget.item.notes!;
    }
  }

  @override
  void dispose() {
    _countController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (photo != null) {
        setState(() {
          _photo = photo;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error taking photo: $e')));
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);

      if (photo != null) {
        setState(() {
          _photo = photo;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error selecting photo: $e')));
    }
  }

  void _submitCount() async {
    final count = int.tryParse(_countController.text);
    if (count == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid count')),
      );
      return;
    }

    if (_photo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please take a photo for verification')),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      await ref
          .read(stockTakeViewModelProvider.notifier)
          .updateItemWithPhoto(
            itemId: widget.item.id,
            count: count,
            photo: _photo!,
            notes: _notesController.text.isEmpty ? null : _notesController.text,
          );

      if (widget.onPhotoCountComplete != null) {
        widget.onPhotoCountComplete!(count, _photo!);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Count submitted successfully')),
      );

      // Clear the form
      setState(() {
        _photo = null;
        _isProcessing = false;
      });
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error submitting count: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.item.productName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Code: ${widget.item.productCode}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'System Quantity: ${widget.item.systemQuantity}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),

            // Photo Section
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _photo != null
                  ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(_photo!.path),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.black54,
                            ),
                            onPressed: () {
                              setState(() {
                                _photo = null;
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.camera_alt,
                            size: 48,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 8),
                          const Text('Take or select a photo'),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: _takePhoto,
                                icon: const Icon(Icons.camera),
                                label: const Text('Camera'),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton.icon(
                                onPressed: _pickFromGallery,
                                icon: const Icon(Icons.photo_library),
                                label: const Text('Gallery'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: 16),

            // Count Input
            TextField(
              controller: _countController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Counted Quantity',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.numbers),
              ),
            ),
            const SizedBox(height: 16),

            // Notes Input
            TextField(
              controller: _notesController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Notes (Optional)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note),
              ),
            ),
            const SizedBox(height: 16),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _submitCount,
                child: _isProcessing
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Submit Count'),
              ),
            ),

            // Show existing photos if any
            if (widget.item.photoUrls != null &&
                widget.item.photoUrls!.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Previous Photos:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.item.photoUrls!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          widget.item.photoUrls![index],
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey[300],
                              child: const Icon(Icons.error),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
