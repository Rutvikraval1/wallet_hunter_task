
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/countries.dart';

class CustomPhoneInput extends StatefulWidget {
  final ValueChanged<String> onChanged;
  const CustomPhoneInput({super.key,required this.onChanged});

  @override
  _CustomPhoneInputState createState() => _CustomPhoneInputState();
}

class _CustomPhoneInputState extends State<CustomPhoneInput> {
  String selectedCountryCode = '+91';
  String phoneNumber = '';
  int maxLength = 10;
  final TextEditingController controller = TextEditingController();

  void _openCountryPicker() async {
    final TextEditingController searchController = TextEditingController();
    List<Country> filteredCountries = List.from(countries); // Same as before

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: SizedBox(
                height: MediaQuery.of(context).size.height/1.5,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 🔍 Search bar
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search country',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (value) {
                          setModalState(() {
                            filteredCountries = countries.where((country) {
                              final search = value.toLowerCase();
                              return country.name.toLowerCase().contains(search) ||
                                  country.dialCode.contains(search);
                            }).toList();
                          });
                        },
                      ),
                    ),

                    // 📋 Country list
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: filteredCountries.map((country) {
                          return ListTile(
                            title: Text('${country.flag} ${country.name}'),
                            onTap: () {
                              setState(() {
                                selectedCountryCode = '+${country.dialCode}';
                                maxLength = country.maxLength ?? 10;
                                phoneNumber="";
                                controller.clear();
                              });
                              Navigator.pop(context);
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Country Code Button
        InkWell(
          onTap: _openCountryPicker,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            height: 48,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  selectedCountryCode,
                  style: const TextStyle(fontSize: 16),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10,),
        // Phone Number Field
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // only numbers
                LengthLimitingTextInputFormatter(maxLength), // limit input
              ],
              cursorColor: Colors.black,
              decoration:  InputDecoration(
                border: InputBorder.none,
                disabledBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                hintText: 'Phone Number',
              ),
              onChanged: (value) {
                setState(() {
                  phoneNumber = value;
                  if(phoneNumber.isNotEmpty){
                    String mobileNumber="$selectedCountryCode $phoneNumber";
                    widget.onChanged(mobileNumber);
                  }else{
                    widget.onChanged("");
                  }
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
