import 'package:flutter/material.dart';

class AddCategory extends StatelessWidget {
  const AddCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            autofocus: true,
            maxLength: 50,
            textDirection: TextDirection.rtl,
            decoration: InputDecoration(
              labelText: 'دسته بندی',
              alignLabelWithHint: true,
              floatingLabelAlignment: FloatingLabelAlignment.center,
            ),
          ),
          ElevatedButton(onPressed: () {}, child: Text('add')),
        ],
      ),
    );
  }
}
