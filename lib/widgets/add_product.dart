import 'package:flutter/material.dart';
import 'package:fuck/data/category_data.dart';
import 'package:fuck/models/category.dart';
import 'package:fuck/models/product.dart';
import 'package:fuck/widgets/image_input.dart';
import 'package:fuck/widgets/persian_date_picker.dart';

class AddProduct extends StatelessWidget {
  const AddProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // 🔥 right-to-left everywhere
      child: Form(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Optional: for layout fix
            children: [
              TextFormField(
                autofocus: true,
                maxLength: 50,
                decoration: InputDecoration(
                  labelText: 'نام',
                  alignLabelWithHint: true,
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                ),
              ),
              DropdownButtonFormField<Dificulty>(
                items:
                    Dificulty.values
                        .map(
                          (dificulty) => DropdownMenuItem<Dificulty>(
                            value: dificulty,
                            child: Text(dificulty.toString().split('.').last),
                          ),
                        )
                        .toList(),
                onChanged: (value) {},
              ),
              DropdownButtonFormField<String>(
                items:
                    CategoryData.values
                        .map(
                          (category) => DropdownMenuItem<String>(
                            value: category.persianTitle,
                            child: Text(category.persianTitle),
                          ),
                        )
                        .toList(),
                onChanged: (value) {},
              ),
              JalaliDatePickerField(labelText: 'تاریخ شروع'),
              JalaliDatePickerField(labelText: 'تاریخ پایان'),
              ImageInput(onPickImage: (file) {}),
              ElevatedButton(onPressed: () {}, child: Text('افزودن')),
            ],
          ),
        ),
      ),
    );
  }
}
