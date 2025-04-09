import 'package:flutter/material.dart';
import 'package:kkuk_kkuk/entities/pet/breed.dart'; // Assuming Breed object is used

class AnimatedDropdown extends StatefulWidget {
  final String? hintText;
  final Breed? value; // Current selected Breed
  final List<Breed> items; // List of Breed objects
  final ValueChanged<Breed?> onChanged; // Callback with selected Breed
  final String? Function(Breed?)? validator;
  final bool enabled;
  final InputDecoration? decoration; // Allow passing decoration style

  const AnimatedDropdown({
    super.key,
    this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    this.enabled = true,
    this.decoration,
  });

  @override
  State<AnimatedDropdown> createState() => _AnimatedDropdownState();
}

class _AnimatedDropdownState extends State<AnimatedDropdown>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  // Default decoration if none provided
  InputDecoration get _effectiveDecoration {
    return widget.decoration ??
        InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.grey[600]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.red.shade700, width: 1.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.red.shade700, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 16,
          ),
          filled: true,
          fillColor: Colors.white,
        );
  }

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    if (!widget.enabled) return; // Do nothing if disabled
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _rotationController.forward();
      } else {
        _rotationController.reverse();
      }
    });
  }

  void _handleItemSelected(Breed item) {
    widget.onChanged(item);
    _toggleExpansion(); // Collapse after selection
  }

  @override
  Widget build(BuildContext context) {
    // Use FormField to integrate with Form validation
    return FormField<Breed>(
      validator: widget.validator,
      initialValue: widget.value,
      enabled: widget.enabled,
      builder: (FormFieldState<Breed> field) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header (tappable area)
            GestureDetector(
              onTap: _toggleExpansion,
              child: InputDecorator(
                // Use InputDecorator to apply decoration and show validation error
                decoration: _effectiveDecoration.copyWith(
                  errorText: field.errorText, // Show validation error
                  fillColor:
                      widget.enabled
                          ? Colors.white
                          : Colors.grey.shade100, // Disabled color
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.value?.name ??
                          (_effectiveDecoration.hintText ??
                              ''), // Show value name or hint
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            widget.value != null
                                ? (widget.enabled
                                    ? Colors.black87
                                    : Colors.grey.shade700)
                                : Colors.grey[600], // Hint text color
                      ),
                    ),
                    RotationTransition(
                      turns: _rotationAnimation,
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color:
                            widget.enabled
                                ? Colors.grey[600]
                                : Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Expandable List
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child:
                  _isExpanded && widget.enabled
                      ? _buildListView()
                      : const SizedBox.shrink(),
            ),
          ],
        );
      },
    );
  }

  // List View Builder
  Widget _buildListView() {
    // Add a border and constrain height
    return Container(
      margin: const EdgeInsets.only(top: 4.0), // Space between header and list
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      constraints: const BoxConstraints(
        maxHeight: 200, // Limit max height
      ),
      child: ListView.builder(
        padding: EdgeInsets.zero, // Remove list padding
        shrinkWrap: true, // Prevent infinite height
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final item = widget.items[index];
          final isSelected =
              widget.value?.id == item.id; // Check if item is selected
          return Material(
            // For InkWell ripple effect
            color:
                isSelected
                    ? Theme.of(context).primaryColor.withOpacity(0.1)
                    : Colors.transparent,
            child: InkWell(
              onTap: () {
                _handleItemSelected(item);
                // Inform FormField about the change
                // We call onChanged which should trigger a rebuild with the new value
                // FormField's builder will get the new value. No need for field.didChange?
                // Let's rely on onChanged updating the parent state.
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
