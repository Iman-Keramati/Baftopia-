import 'package:flutter/material.dart';
import 'package:flutter_jalali_date_picker/flutter_jalali_date_picker.dart';
import 'package:shamsi_date/shamsi_date.dart';

class JalaliDatePickerField extends StatefulWidget {
  final String labelText;
  final Function(String jalaliDate)? onChanged;
  final DateTime? initialDate;

  const JalaliDatePickerField({
    super.key,
    required this.labelText,
    this.onChanged,
    this.initialDate,
  });

  @override
  State<JalaliDatePickerField> createState() => _JalaliDatePickerFieldState();
}

class _JalaliDatePickerFieldState extends State<JalaliDatePickerField> {
  String? _selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      final jalali = widget.initialDate!.toJalali();
      _selectedDate = '${jalali.year}/${jalali.month}/${jalali.day}';
    }
  }

  void _pickDate() async {
    final result = await showJalaliDatePicker(
      context,
      initialDate: widget.initialDate?.toJalali() ?? Jalali.now(),
      firstDate: Jalali(1390, 1, 1),
      lastDate: Jalali(1450, 12, 29),
    );

    if (result != null) {
      setState(() {
        _selectedDate = '${result.year}/${result.month}/${result.day}';
      });
      if (widget.onChanged != null) widget.onChanged!(_selectedDate!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickDate,
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: widget.labelText,
            hintText: 'انتخاب تاریخ شمسی',
          ),
          controller: TextEditingController(text: _selectedDate ?? ''),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'لطفاً تاریخ را وارد کنید';
            }
            return null;
          },
        ),
      ),
    );
  }
}
