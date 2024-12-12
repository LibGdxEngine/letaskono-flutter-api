import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:letaskono_flutter/core/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/user_bloc.dart';

class FilterBottomSheet extends StatefulWidget {
  final UserBloc userBloc;

  const FilterBottomSheet(this.userBloc, {super.key});

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late SharedPreferences prefs;
  RangeValues ageRange = const RangeValues(24, 50); // Default range
  String maritalStatus = 'الكل';
  String ordering = '';

  String gender = ''; // Gender selection
  String selectedCountry = 'مصر'; // Default country
  List<String> availableStates = [];
  List<String> selectedStates = [];
  Map<String, String> orders = {
    '': "",
    'العمر-تصاعدي': "age",
    'العمر-تنازلي': "-age",
    'أخر ظهور-تصاعدي': "last_seen",
    'أخر ظهور-تنازلي': "-last_seen",
    'تاريخ التسجيل-تصاعدي': "user__date_joined",
    'تاريخ التسجيل-تنازلي': "-user__date_joined",
  };

  @override
  void initState() {
    super.initState();
    prefs = GetIt.instance<SharedPreferences>();
    _loadPreferences();
    _updateStatesForCountry(selectedCountry);
  }

  void _loadPreferences() async {
    setState(() {
      ageRange = RangeValues(
        prefs.getDouble('filter_age_min') ?? 18,
        prefs.getDouble('filter_age_max') ?? 50,
      );
      maritalStatus = prefs.getString('filter_marital_status') ?? 'All';
      ordering = prefs.getString('ordering') ?? 'profile__age';
    });
  }

  void _updateStatesForCountry(String country) {
    setState(() {
      availableStates = Constants.countryStateMap[country] ?? [];
      selectedStates = []; // Reset selected states
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height * 0.9,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filters',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context); // Close the bottom sheet
                  },
                ),
              ],
            ),
            const Divider(),
            // Age Min Field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Age Range',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                RangeSlider(
                  values: ageRange,
                  min: 13,
                  max: 80,
                  divisions: 67,
                  // Total range divided into increments
                  labels: RangeLabels(
                    ageRange.start.round().toString(),
                    ageRange.end.round().toString(),
                  ),
                  onChanged: (RangeValues newRange) {
                    setState(() {
                      ageRange = newRange;
                    });
                  },
                ),
                Text(
                  'Selected Range: ${ageRange.start.round()} - ${ageRange.end.round()}',
                  style: const TextStyle(fontSize: 14.0),
                ),
              ],
            ),

            const SizedBox(height: 16.0),
            // Marital Status Dropdown
            DropdownButton<String>(
              value: maritalStatus,
              onChanged: (String? newValue) {
                setState(() {
                  maritalStatus = newValue!;
                });
              },
              items: <String>['الكل', 'أعزب', 'متزوج', 'أرمل', 'مطلق']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            // Ordering Dropdown
            DropdownButton<String>(
              value: orders.keys.firstWhere((key) => orders[key] == ordering,
                  orElse: () => ''),
              onChanged: (String? newKey) {
                setState(() {
                  ordering = orders[
                      newKey]!; // Update `ordering` with the value from `orders`.
                });
              },
              items: orders.keys.map<DropdownMenuItem<String>>((String key) {
                return DropdownMenuItem<String>(
                  value: key,
                  // Use the key as the value for the DropdownMenuItem.
                  child: Text(key.isEmpty
                      ? 'اختر ترتيبًا'
                      : key), // Display the key text (or placeholder if empty).
                );
              }).toList(),
            ),
            DropdownButton<String>(
              value: selectedCountry,
              onChanged: (String? newCountry) {
                setState(() {
                  selectedCountry = newCountry!;
                  _updateStatesForCountry(newCountry);
                });
              },
              items: Constants.countryStateMap.keys
                  .map<DropdownMenuItem<String>>((String country) {
                return DropdownMenuItem<String>(
                  value: country,
                  child: Text(country),
                );
              }).toList(),
            ),
            // State MultiSelect
            _buildMultiSelect(
              label: 'States',
              selectedItems: selectedStates,
              availableItems: availableStates,
              onChanged: (values) {
                setState(() {
                  selectedStates = values;
                });
              },
            ),
            // Gender Selection using RadioListTile
            _buildGenderSelection(),
            // Apply Filters Button
            ElevatedButton(
              onPressed: () {
                // Dispatch the ApplyFiltersEvent with the selected filters
                widget.userBloc.add(
                  ApplyFiltersEvent(
                    maritalStatus: maritalStatus,
                    ageMin: ageRange.start.round(),
                    ageMax: ageRange.end.round(),
                    ordering: ordering,
                    countries: [selectedCountry],
                    states: selectedStates,
                    gender: gender,
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text('Apply Filters'),
            ),
          ],
        ),
      ),
    );
  }

  // Gender Selection
  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Gender'),
        RadioListTile<String>(
          value: 'M',
          groupValue: gender,
          onChanged: (String? value) {
            setState(() {
              gender = value!;
            });
          },
          title: Text('Male'),
        ),
        RadioListTile<String>(
          value: 'F',
          groupValue: gender,
          onChanged: (String? value) {
            setState(() {
              gender = value!;
            });
          },
          title: Text('Female'),
        ),
      ],
    );
  }

  // MultiSelect Widget for states
  Widget _buildMultiSelect({
    required String label,
    required List<String> selectedItems,
    required List<String> availableItems,
    required Function(List<String>) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Wrap(
          spacing: 10.0,
          children: availableItems
              .map((item) => ChoiceChip(
                    label: Text(item),
                    selected: selectedItems.contains(item),
                    onSelected: (selected) {
                      final newSelectedItems = List<String>.from(selectedItems);
                      if (selected) {
                        newSelectedItems.add(item);
                      } else {
                        newSelectedItems.remove(item);
                      }
                      onChanged(newSelectedItems);
                    },
                  ))
              .toList(),
        ),
      ],
    );
  }
}
